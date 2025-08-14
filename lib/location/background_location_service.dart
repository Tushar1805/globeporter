// background_location_service.dart
import 'dart:async';
import 'dart:math';

import 'package:core/di/service_locator.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:globeporter/location/cubit/location_cubit.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';

/// ---- CONFIG ----
/// Poll interval in seconds when "idle" and when "active" (e.g., on-trip).
const _idleInterval = Duration(seconds: 10);
const _activeInterval = Duration(seconds: 10);

final authCubit = sl<AuthCubit>();
final locationCubit = sl<LocationCubit>();

/// Distance threshold to reduce spam if stationary (meters).
const _minDistanceMeters = 25;

/// Entry point called by the plugin in a background isolate.
@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  // ANDROID: make sure we run as a Foreground Service with a notification.
  if (service is AndroidServiceInstance) {
    await service.setAsForegroundService();
    await service.setForegroundNotificationInfo(
      title: 'Location tracking active',
      content: 'We are updating your position for rides.',
    );
  }

  // Allow UI isolate to send commands to this service.
  service.on('stopService').listen((_) async {
    await service.stopSelf();
  });

  // Dynamic config updates (optional)
  String? userId = '';
  String? role = 'driver';
  String? type;
  bool activeMode = false; // you can flip this when a ride starts/ends

  service.on('updateConfig').listen((data) {
    if (data == null) return;
    userId = (data['userId'] ?? userId)?.toString();
    role = (data['role'] ?? role)?.toString();
    type = (data['type'] ?? type)?.toString();
    activeMode = (data['active'] ?? activeMode) == true;
  });

  // Ensure location services + permissions (the UI should do this beforehand).
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // We can't prompt from background; bail early.
    return;
  }

  LocationPermission perm = await Geolocator.checkPermission();
  if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
  if (perm == LocationPermission.deniedForever || perm == LocationPermission.denied) {
    return; // cannot continue
  }

  // Stream settings (battery-friendly, distance filter).
  // Geolocator streams are OK, but polling is more reliable across OEM killers.
  // We'll combine: prefer stream; if it stops, fall back to polling.
  final locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high, // tune: balanced for idle, high for active
    distanceFilter: _minDistanceMeters.toInt(),
  );

  Position? lastUploaded;
  DateTime lastUploadTime = DateTime.fromMillisecondsSinceEpoch(0);
  Duration currentInterval = _idleInterval;

  Timer? pollTimer;

  // Helper to decide whether to upload (time and distance based).
  bool shouldUpload(Position p) {
    final since = DateTime.now().difference(lastUploadTime);
    final distOk = () {
      if (lastUploaded == null) return true;
      final d = _distanceMeters(
        lastUploaded!.latitude,
        lastUploaded!.longitude,
        p.latitude,
        p.longitude,
      );
      return d >= _minDistanceMeters;
    }();
    return since >= currentInterval || distOk;
  }

  Future<void> doUpload(Position p) async {
    if (userId?.isEmpty ?? false) return; // wait until UI provided config
    lastUploadTime = DateTime.now();
    lastUploaded = p;
    await locationCubit.updateMyLocation(
      lat: p.latitude,
      lng: p.longitude,
      role: authCubit.userDetails?.data?.userType == 2 ? 'driver' : 'customer',
      userId: authCubit.userDetails?.data?.id.toString(),
      type: authCubit.userDetails?.data?.vehicleDetailData?.vehicleTypeName,
    );

    // Update notification text occasionally (Android)
    if (service is AndroidServiceInstance) {
      await service.setForegroundNotificationInfo(
        title: 'Tracking: ${activeMode ? 'on-trip' : 'idle'}',
        content: 'lat: ${p.latitude.toStringAsFixed(5)}, '
            'lng: ${p.longitude.toStringAsFixed(5)}',
      );
    }
  }

  // Start the stream; if it completes, we fall back to polling.
  StreamSubscription<Position>? sub;

  void startPolling() {
    sub?.cancel();
    pollTimer?.cancel();
    currentInterval = activeMode ? _activeInterval : _idleInterval;

    pollTimer = Timer.periodic(currentInterval, (_) async {
      try {
        final p = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(
            accuracy: activeMode
                ? LocationAccuracy.best
                : LocationAccuracy.medium, // replaces desiredAccuracy
            // Optional: Set distance filter if you only want updates after movement
            distanceFilter: 0,
          ),
        ).timeout(
          const Duration(seconds: 8), // replaces timeLimit
          onTimeout: () => throw TimeoutException("Location request timed out"),
        );

        if (shouldUpload(p)) {
          await doUpload(p);
        }
      } catch (_) {
        // ignore; will retry next tick
      }
    });
  }

  void startStream() {
    sub?.cancel();
    sub = Geolocator.getPositionStream(locationSettings: locationSettings).listen((p) async {
      // Update interval depending on active/idle
      currentInterval = activeMode ? _activeInterval : _idleInterval;
      if (shouldUpload(p)) {
        await doUpload(p);
      }
    }, onError: (_) {
      // In case OEM kills stream, we’ll switch to polling
      startPolling();
    }, onDone: () {
      startPolling();
    });
  }

  // react to foreground/background switches (Android)
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((_) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((_) {
      service.setAsBackgroundService();
    });
  }

  // Start!
  startStream();

  // Keep the Dart isolate alive
  // ignore: unused_local_variable
  final keepAlive = Timer.periodic(const Duration(minutes: 30), (_) {
    // noop; some OEMs like a heartbeat
  });
}

/// Initialize + configure the background service. Call once (e.g., in main()).
Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
      autoStartOnBoot: true,
      foregroundServiceNotificationId: 991,
      notificationChannelId: 'location_tracking_channel',
      initialNotificationTitle: 'Location tracking starting…',
      initialNotificationContent: 'Preparing sensors',
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: _onIosBackground, // must be a top-level/entry-point fn
    ),
  );
}

/// iOS background handler (required to return true)
@pragma('vm:entry-point')
Future<bool> _onIosBackground(ServiceInstance service) async {
  // iOS will wake you for brief windows; keep it quick.
  return true;
}

/// Simple haversine helper
double _distanceMeters(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371000.0; // meters
  final dLat = _deg2rad(lat2 - lat1);
  final dLon = _deg2rad(lon2 - lon1);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return R * c;
}

double _deg2rad(double d) => d * (pi / 180.0);
