import 'dart:async';

import 'package:core/di/service_locator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/location/cubit/location_cubit.dart';
import 'package:globeporter/presentation/customer/model/customer_ride_response.dart' as customer;
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_utils.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackDriverScreen extends StatefulWidget {
  const TrackDriverScreen({super.key, required this.data, required this.type});
  final customer.Data? data;
  final String? type;

  @override
  State<TrackDriverScreen> createState() => _TrackDriverScreenState();
}

class _TrackDriverScreenState extends State<TrackDriverScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final locationCubit = sl<LocationCubit>();

  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  Marker? driverMarker;

  CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(20.5574253, 78.8386951),
    zoom: 14,
  );

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

  /// Show pickup and drop route initially
  // void getInitialRoute() async {
  //   try {
  //     final GoogleMapController controller = await _controller.future;

  //     _kGooglePlex = CameraPosition(
  //       target: LatLng(widget.data?.pickupLat ?? 20.5574253, widget.data?.pickupLng ?? 78.8386951),
  //       zoom: 14,
  //     );

  //     _markers = [
  //       Marker(
  //         markerId: const MarkerId('pickup'),
  //         position:
  //             LatLng(widget.data?.pickupLat ?? 20.5574253, widget.data?.pickupLng ?? 78.8386951),
  //       ),
  //       Marker(
  //         markerId: const MarkerId('drop'),
  //         position: LatLng(widget.data?.dropLat ?? 20.5574253, widget.data?.dropLng ?? 78.838695),
  //         infoWindow: const InfoWindow(title: 'Destination'),
  //       ),
  //     ];

  //     // Draw initial polyline
  //     final response = await locationCubit.routeDirection(
  //       pickupLat: widget.data?.pickupLat ?? 20.5574253,
  //       pickupLng: widget.data?.pickupLng ?? 78.838695,
  //       dropLat: widget.data?.dropLat ?? 20.5574253,
  //       dropLng: widget.data?.dropLng ?? 78.838695,
  //     );

  //     final points = response?.routes?[0].overviewPolyline?.points ?? '';
  //     polylineCoordinates = decodePolyline(points);

  //     polylines.add(
  //       Polyline(
  //         polylineId: const PolylineId("route"),
  //         points: polylineCoordinates,
  //         color: Colors.black,
  //         width: 5,
  //       ),
  //     );

  //     controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
  //     setState(() {});
  //   } catch (e) {
  //     debugPrint("Error: Getting initial route: $e");
  //   }
  // }

  /// Listen to driver location from Firebase Realtime Database
  void listenToDriverLocation() {
    final driverId = widget.data?.driverId?.toString() ?? '';
    if (driverId.isEmpty) return;

    final dbRef = FirebaseDatabase.instance.ref("locations/$driverId");

    _driverLocationSub = dbRef.onValue.listen((event) async {
      if (!event.snapshot.exists) return;

      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null || data['latitude'] == null || data['longitude'] == null) return;

      final driverLat = (data['latitude'] as num).toDouble();
      final driverLng = (data['longitude'] as num).toDouble();

      // final dropLat = widget.data?.dropLat ?? 0.0;
      // final dropLng = widget.data?.dropLng ?? 0.0;
      final pickupLat = widget.data?.pickupLat ?? 0.0;
      final pickupLng = widget.data?.pickupLng ?? 0.0;

      // Update route polyline
      final response = await locationCubit.routeDirection(
        pickupLat: driverLat,
        pickupLng: driverLng,
        dropLat: pickupLat,
        dropLng: pickupLng,
      );

      final points = response?.routes?[0].overviewPolyline?.points ?? '';
      polylineCoordinates = decodePolyline(points);

      polylines.clear();
      polylines.add(
        Polyline(
          polylineId: const PolylineId("route"),
          points: polylineCoordinates,
          color: Colors.black,
          width: 5,
        ),
      );

      // Update driver marker
      driverMarker = await getMarker(
        vehicleType: widget.data?.vehicleTypeData?.nameEn ?? '',
        markerId: const MarkerId('driver'),
        position: LatLng(driverLat, driverLng),
        info: "Driver",
      );

      _markers = [
        driverMarker!,
        Marker(
          markerId: const MarkerId('drop'),
          position: LatLng(pickupLat, pickupLng),
          infoWindow: const InfoWindow(title: 'Destination'),
        ),
      ];

      setState(() {});

      // Move camera
      final controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(LatLng(driverLat, driverLng)));

      // Check if driver reached destination
      final distance = Geolocator.distanceBetween(driverLat, driverLng, pickupLat, pickupLng);
      if (distance <= 50) {
        _driverLocationSub?.cancel();
        // You can trigger a popup or completion logic here
      }
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
          initialCameraPosition: _kGooglePlex,
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
