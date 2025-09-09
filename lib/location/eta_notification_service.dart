// eta_notification_service.dart
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:core/utils/core_utils.dart';
import 'package:globeporter/resources/app_colors.dart'; // your custom logger

const _etaNotificationId = 2001;
const _etaChannelId = 'eta_channel';
const _etaChannelName = 'ETA Notifications';

class EtaNotificationService {
  final FlutterLocalNotificationsPlugin _flnp = FlutterLocalNotificationsPlugin();
  StreamSubscription<dynamic>? _subscription;
  AndroidFlutterLocalNotificationsPlugin? _androidPlugin;
  int? _etaTotalSeconds;
  int? _etaRemainingSeconds;
  String _etaTitle = 'Driver ETA';
  String _etaBody = 'Calculating...';
  bool _initialized = false;

  EtaNotificationService();

  /// Call this from the background isolate (inside `onStart`), passing the ServiceInstance.
  Future<void> init(ServiceInstance service) async {
    // Background isolates need binding
    WidgetsFlutterBinding.ensureInitialized();
    if (_initialized) return;

    // Initialize plugin
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettings = InitializationSettings(android: androidInit, iOS: null);
    await _flnp.initialize(initializationSettings);

    // Create channel on Android
    _androidPlugin =
        _flnp.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (_androidPlugin != null) {
      final channel = AndroidNotificationChannel(
        _etaChannelId,
        _etaChannelName,
        description: 'Driver ETA & progress',
        importance: Importance.low,
      );
      await _androidPlugin!.createNotificationChannel(channel);
    }

    // Listen for ETA events coming through the FlutterBackgroundService channel
    _subscription = service.on('etaUpdate').listen(
          _onEtaEvent,
          onError: (e) => customPrint('EtaService: onError: $e'),
          cancelOnError: false,
        );

    _initialized = true;
    customPrint('EtaService: initialized');
  }

  Future<void> _onEtaEvent(dynamic event) async {
    try {
      if (event == null) return;

      // event expected to be a Map with keys like:
      // { 'remaining': int, 'total': int (optional), 'title': String (optional), 'body': String (optional) }
      final Map data = event as Map;

      final remRaw = data['remaining'] ?? data['remainingSeconds'] ?? data['etaSeconds'];
      final totRaw = data['total'] ?? data['etaTotalSeconds'];
      final titleRaw = data['title'];
      final bodyRaw = data['body'] ?? data['etaText'];

      final int? rem = remRaw != null ? int.tryParse(remRaw.toString()) : null;
      final int? tot = totRaw != null ? int.tryParse(totRaw.toString()) : null;

      if (rem == null) {
        customPrint('EtaService: ignored etaUpdate (no remaining provided)');
        return;
      }

      _etaRemainingSeconds = rem;
      if (tot != null) _etaTotalSeconds = tot;
      if (titleRaw != null) _etaTitle = titleRaw.toString();
      if (bodyRaw != null) _etaBody = bodyRaw.toString();

      final useTotal = _etaTotalSeconds ?? _etaRemainingSeconds ?? 1;

      await _showEtaNotification(
        remainingSeconds: _etaRemainingSeconds!,
        totalSeconds: useTotal,
        title: _etaTitle,
        body: _etaBody,
      );

      if (_etaRemainingSeconds != null && _etaRemainingSeconds! <= 0) {
        await showArrived();
      }
    } catch (e) {
      customPrint('EtaService: failed to parse event: $e');
    }
  }

  Future<void> _showEtaNotification({
    required int remainingSeconds,
    required int totalSeconds,
    String? title,
    String? body,
  }) async {
    final total = totalSeconds > 0 ? totalSeconds : 1;
    final completed = (total - remainingSeconds).clamp(0, total);

    final androidDetails = AndroidNotificationDetails(
      _etaChannelId,
      _etaChannelName,
      channelDescription: 'Driver ETA progress',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: total,
      progress: completed,
      playSound: false,
      visibility: NotificationVisibility.public,
      icon: '@drawable/ic_icon',
      color: primaryColor,
    );

    final platformDetails = NotificationDetails(android: androidDetails, iOS: null);

    final titleString = title ?? _etaTitle;
    final bodyString = body ?? '${_formatEta(remainingSeconds)} • ${remainingSeconds}s left';

    await _flnp.show(_etaNotificationId, titleString, bodyString, platformDetails);
  }

  String _formatEta(int seconds) {
    if (seconds <= 0) return 'Arrived';
    final m = seconds ~/ 60;
    final s = seconds % 60;
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  Future<void> showArrived() async {
    await _flnp.show(
      _etaNotificationId,
      'Driver has arrived',
      'Driver is at your pickup location',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _etaChannelId,
          _etaChannelName,
          channelDescription: 'Driver ETA',
          importance: Importance.low,
          priority: Priority.low,
          ongoing: false,
          icon: '@drawable/ic_icon',
          color: primaryColor,
        ),
        iOS: null,
      ),
    );
  }

  /// Cleanup when service stops
  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    customPrint('EtaService: disposed');
  }
}
