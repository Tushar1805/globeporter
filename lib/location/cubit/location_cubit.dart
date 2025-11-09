import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:globeporter/basecubit/base_cubit.dart';
import 'package:globeporter/location/model/route_direction_response.dart';
import 'package:globeporter/location/repository/location_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:globeporter/location/states/location_states.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/resources/app_keys.dart';
import 'package:globeporter/resources/app_storage.dart';
import 'package:uuid/uuid.dart';

class LocationCubit extends BaseCubit {
  final LocationRepository _locationRepository;
  LocationCubit(this._locationRepository);
  final storage = sl<SecureStorage>();
  final authCubit = sl<AuthCubit>();
  Position? position;
  String? currentLocation;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('locations');

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
  );

  Future<void> _initUserId() async {
    final userId = await storage.safeRead(userIdKey);
    if (userId == null) {
      await storage.saveValue(value: const Uuid().v4(), key: userIdKey);
    }
  }

  Future<void> requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      await _initUserId();

      // ✅ Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Fluttertoast.showToast(msg: 'Location services are disabled. Please enable GPS.');

        return Future.error('Location services are disabled.');
      }

      // ✅ Check and request permissions
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Fluttertoast.showToast(msg: 'Location permission denied.');

          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(
            msg: 'Location permission permanently denied. Enable it from app settings.');

        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // ✅ Try to get the last known position
      Position? position = await Geolocator.getLastKnownPosition();

      if (position != null) {
        this.position = position;
        emit(LocationLoadedState(data: position));
        return position;
      }

      // ✅ Fallback to current position
      position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      this.position = position;
      emit(LocationLoadedState(data: this.position));
      return this.position!;
    } catch (e) {
      debugPrint('❌ Error getting location: $e');

      Fluttertoast.showToast(msg: 'Unable to get your current location: $e');

      // Return a default/fallback position to prevent crashes
      final fallback = Position(
        latitude: 20.5937, // center of India
        longitude: 78.9629,
        timestamp: DateTime.now(),
        accuracy: 100,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0,
      );

      emit(LocationLoadedState(data: fallback));
      return fallback;
    }
  }

  Future<void> searchPickupPlaces({
    required final String input,
    required final String? sesssionToken,
  }) async {
    try {
      final response =
          await _locationRepository.searchPlaces(input: input, sessionToken: sesssionToken);
      emit(SearchPickupLocationResultState(data: response));
    } catch (e) {
      customPrint("Error: Searching Location: $e");
    }
  }

  Future<void> searchDestinationPlaces({
    required final String input,
    required final String? sesssionToken,
  }) async {
    try {
      final response =
          await _locationRepository.searchPlaces(input: input, sessionToken: sesssionToken);
      emit(SearchDestinationLocationResultState(data: response));
    } catch (e) {
      customPrint("Error: Searching Location: $e");
    }
  }

  Future<RouteDirectionsResponse?> routeDirection({
    required final double pickupLat,
    required final double pickupLng,
    required final double dropLat,
    required final double dropLng,
  }) async {
    try {
      final response = await _locationRepository.routeDirection(
        pickupLat: pickupLat,
        pickupLng: pickupLng,
        dropLat: dropLat,
        dropLng: dropLng,
      );

      emit(RouteDirectionsLoadedState(data: response));
      return response;
    } catch (e) {
      customPrint("Error: Routing Directions: $e");
      return null;
    }
  }

  Future<void> updateMyLocation({
    required final double lat,
    required final double lng,
    required final String role,
    final String? userId,
    final String? type,
  }) async {
    final id = userId ?? authCubit.userDetails?.data?.id.toString();
    // final type = authCubit.userDetails?.data?.vehicleDetailData?.vehicleTypeData?.nameEn;
    final lang = await storage.safeRead(languageCodeKey);
    final accessToken = await storage.safeRead(accessTokenKey);
    await _locationRepository.updateUserLocation(
      lang: lang ?? 'en',
      token: accessToken ?? '',
      logitude: lng.toString(),
      latitude: lat.toString(),
    );
    try {
      if (id != null && id != '') {
        await _dbRef.child(id).set({
          "latitude": lat,
          "longitude": lng,
          "last_updated": ServerValue.timestamp,
          "type": type ?? "truck",
          "role": role,
        });
      }
      customPrint('Location Update for RTDB: lat: $lat Lng: $lng');
    } catch (e) {
      debugPrint('Something went wrong: $e');
    }
  }

  Future<Map?> fetchNearbyUsers() async {
    try {
      final snapshot = await _dbRef.once();
      final data = snapshot.snapshot.value as Map?;
      return data;
    } catch (e) {
      debugPrint('Something went wrong: $e');
      return null;
    }
  }
}
