// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:core/di/service_locator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/location/cubit/location_cubit.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_utils.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:globeporter/presentation/driver_ride_back/model/customer_posted_ride_list_model.dart'
    as posted_ride;

class TrackRideBackDriverScreen extends StatefulWidget {
  const TrackRideBackDriverScreen({super.key, required this.data});
  final posted_ride.Data? data;

  @override
  State<TrackRideBackDriverScreen> createState() => _TrackRideBackDriverScreenState();
}

class _TrackRideBackDriverScreenState extends State<TrackRideBackDriverScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final locationCubit = sl<LocationCubit>();
  final authCubit = sl<AuthCubit>();

  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  Marker? driverMarker;

  List<Marker>? _markers;
  StreamSubscription<DatabaseEvent>? _driverLocationSub;

  @override
  void initState() {
    super.initState();
    // getInitialRoute();
    listenToDriverLocation();
  }

  @override
  void dispose() {
    _driverLocationSub?.cancel();
    super.dispose();
  }

  /// Listen to driver location from Firebase Realtime Database
  void listenToDriverLocation() {
    final driverId = widget.data?.driverId?.toString() ?? '';
    final myId = authCubit.userDetails?.data?.id.toString();
    if (driverId.isEmpty) return;

    final dbRef = FirebaseDatabase.instance.ref("locations/$myId");
    _driverLocationSub =
        dbRef.onValue.throttleTime(const Duration(seconds: 5)).listen((event) async {
      if (!event.snapshot.exists) return;

      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null || data['latitude'] == null || data['longitude'] == null) return;

      final customerLat = (data['latitude'] as num).toDouble();
      final customerLng = (data['longitude'] as num).toDouble();

      // Fetch Driver location  from RTDB
      final driverSnapshot = await FirebaseDatabase.instance.ref("locations/$driverId").get();
      final driverData = driverSnapshot.value as Map?;
      if (driverData == null) return;
      final driverLat = (driverData['latitude'] as num).toDouble();
      final driverLng = (driverData['longitude'] as num).toDouble();

      // Calculate distance between customer and driver
      final distance = Geolocator.distanceBetween(
        customerLat,
        customerLng,
        widget.data?.pickupLat ?? 123,
        widget.data?.pickupLng ?? 123,
      );

      // Update route polyline (optional)
      final response = await locationCubit.routeDirection(
        pickupLat: customerLat,
        pickupLng: customerLng,
        dropLat: widget.data?.pickupLat ?? 123,
        dropLng: widget.data?.pickupLng ?? 123,
      );

      final points = response?.routes?[0].overviewPolyline?.points ?? '';
      polylineCoordinates = decodePolyline(points);

      polylines
        ..clear()
        ..add(
          Polyline(
            polylineId: const PolylineId("route"),
            points: polylineCoordinates,
            color: primaryColor,
            width: 5,
          ),
        );

      // Update markers
      final customerMarker = Marker(
        markerId: const MarkerId('customer'),
        position: LatLng(widget.data?.pickupLat ?? 123, widget.data?.pickupLng ?? 123),
        infoWindow: const InfoWindow(title: 'You'),
      );

      final driverMarker = await getMarker(
        vehicleType: widget.data?.vehicleTypeData?.nameEn ?? '',
        markerId: const MarkerId('driver'),
        position: LatLng(driverLat, driverLng),
        info: "Driver",
      );

      _markers = [driverMarker, customerMarker];
      setState(() {});

      final controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(LatLng(customerLat, customerLng)));

      //  Stop tracking when customer reaches near driver
      if (distance <= 50) {
        _driverLocationSub?.cancel();

        // Stop background tracking
        final service = FlutterBackgroundService();
        service.invoke('stopService');

        popUp(); // show “You’ve reached pickup location”
      }
    });
  }

  void popUp() {
    Future.delayed(Duration(milliseconds: 100), () {
      showCustomDialogOneButton(
        barrierDismissible: false,
        context: context,
        borderRadius: 18,
        title: AppLocalizations.of(context)!.reachedPickupLocationMsgString,
        buttonTitle: AppLocalizations.of(context)!.okString,
        onTap: () async {
          context.pop();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.25),
        child: CustomStatusBarWidget(
          title: AppLocalizations.of(context)!.trackString,
        ),
      ),
      body: SizedBox(
        height: size.height,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              locationCubit.position?.latitude ?? 20.5574253,
              locationCubit.position?.longitude ?? 78.8386951,
            ),
            zoom: 14,
          ),
          markers: Set<Marker>.of(_markers ?? []),
          mapToolbarEnabled: false,
          myLocationEnabled: true,
          onMapCreated: (final controller) {
            _controller.complete(controller);
          },
          polylines: polylines,
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          },
        ),
      ),
    );
  }
}
