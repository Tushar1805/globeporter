import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
    distanceFilter: 100,
  );

  Future<void> _initUserId() async {
    final userId = await storage.readValue(userIdKey);
    if (userId == null) {
      await storage.saveValue(value: const Uuid().v4(), key: userIdKey);
    }
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    await _initUserId();

    // Test if location services are enabled.
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

    Position? position = await Geolocator.getLastKnownPosition();
    if (position != null) {
      this.position = position;
      emit(LocationLoadedState(data: position));
      return position;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    this.position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    emit(LocationLoadedState(data: this.position));
    return this.position!;
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
  }) async {
    final userId = authCubit.userDetails?.data?.id.toString();
    // final type = authCubit.userDetails?.data?.vehicleDetailData?.vehicleTypeData?.nameEn;
    try {
      if (userId != null && userId != '') {
        await _dbRef.child(userId).set({
          "latitude": lat,
          "longitude": lng,
          "last_updated": ServerValue.timestamp,
          "type": "truck",
        });
      }
      debugPrint('Location Updaget: lat: $lat Lng: $lng');
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
