// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/location/cubit/location_cubit.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/driver/cubit/driver_cubit.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_extension_functions.dart';
import 'package:globeporter/presentation/customer/model/booking_details_response.dart' as booking;
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_utils.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

class TripInfoScreen extends StatefulWidget {
  const TripInfoScreen({super.key, required this.type, required this.data});
  final String? type;
  final booking.Data data;

  @override
  State<TripInfoScreen> createState() => _TripInfoScreenState();
}

class _TripInfoScreenState extends State<TripInfoScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final locationCubit = sl<LocationCubit>();
  final driverCubit = sl<DriverCubit>();
  final authCubit = sl<AuthCubit>();
  Position? position;
  StreamSubscription<loc.LocationData>? _locationSubscription;
  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  FToast? fToast;
  Marker? driverMarker;

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(20.5574253, 78.8386951),
    zoom: 14,
  );

  List<Marker>? _markers;

  void getCurrentLocation() async {
    try {
      customPrint('***************** Current location 1 ');
      final GoogleMapController controller = await _controller.future;

      _kGooglePlex = CameraPosition(
        target: LatLng(widget.data.pickupLat ?? 20.5574253, widget.data.pickupLng ?? 78.8386951),
        zoom: 14,
      );
      _markers = <Marker>[
        Marker(
          markerId: MarkerId('1'),
          position:
              LatLng(widget.data.pickupLat ?? 20.5574253, widget.data.pickupLat ?? 20.5574253),
          // infoWindow: InfoWindow(title: 'The title of the marker'),
        )
      ];
      controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));

      customPrint('***************** Current location 2 ');

      final latLng = LatLng(
        widget.data.pickupLat ?? 20.5574253,
        widget.data.pickupLng ?? 78.838695,
      );
      // await locationCubit
      //     .routeDirection(
      //   pickupLat: widget.data.pickupLat ?? 20.5574253,
      //   pickupLng: widget.data.pickupLng ?? 78.838695,
      //   dropLat: widget.data.dropLat ?? 20.5574253,
      //   dropLng: widget.data.dropLng ?? 78.838695,
      // )
      //     .then((final response) {
      //   final points = response?.routes?[0].overviewPolyline?.points ?? '';
      //   polylineCoordinates = decodePolyline(points);

      //   polylines.add(
      //     Polyline(
      //       polylineId: PolylineId("route"),
      //       points: polylineCoordinates,
      //       color: Colors.black,
      //       width: 5,
      //     ),
      //   );
      //   _markers?.add(
      //     Marker(
      //       markerId: MarkerId('drop'),
      //       position: latLng,
      //       infoWindow: InfoWindow(title: 'Destination'),
      //     ),
      //   );
      // });

      // setState(() {});

      customPrint('***************** Current location 3 ');

      final GoogleMapController mapController = await _controller.future;
      mapController.animateCamera(CameraUpdate.newLatLng(latLng));

      customPrint('***************** Current location 4 ');
    } catch (e) {
      debugPrint("Error: Getting Location: $e");
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final status = await Permission.phone.request();

    if (status.isGranted) {
      FlutterPhoneDirectCaller.callNumber(phoneNumber);
    } else {
      showToast(
        context: context,
        fToast: fToast!,
        msg: AppLocalizations.of(context)!.phoneCallPermissionDeniedString,
        duration: 5,
      );
    }
  }

  Future<void> startTracking() async {
    final location = loc.Location();
    final permissionGranted = await location.requestPermission();
    final serviceEnabled = await location.serviceEnabled() || await location.requestService();

    // customPrint('***************** Tracking 1 ');

    if (permissionGranted != loc.PermissionStatus.granted || !serviceEnabled) {
      // customPrint('***************** Checking if permissions ');
      return;
    }

    // customPrint('***************** Tracking 2 ');

    _locationSubscription?.cancel(); // cancel previous listener if any

    // customPrint('***************** Tracking 3 ');
    void onError(final object, stack) {
      customPrint('Error Tracking: $stack ');
    }

    try {
      await location.changeSettings(
        accuracy: loc.LocationAccuracy.high,
        interval: 5000, // 5 secods
        distanceFilter: 20, // 20 meters
      );
      // customPrint('***************** Tracking 4 ');

      _locationSubscription = location.onLocationChanged
          .doOnError(onError)
          .throttleTime(const Duration(seconds: 5))
          .listen((locationData) async {
        if (locationData.latitude == null || locationData.longitude == null) return;

        // customPrint('***************** Stream 1 ');

        final currentLat = locationData.latitude!;
        final currentLng = locationData.longitude!;
        final pickupLat = widget.data.pickupLat ?? 0.0;
        final pickupLng = widget.data.pickupLng ?? 0.0;

        // Update backend
        locationCubit.updateMyLocation(
          lat: currentLat,
          lng: currentLng,
          role: 'customer',
          userId: widget.data.driverId.toString(),
        );

        // Update route polyline
        await locationCubit
            .routeDirection(
          pickupLat: currentLat,
          pickupLng: currentLng,
          dropLat: pickupLat,
          dropLng: pickupLng,
        )
            .then((response) {
          final points = response?.routes?[0].overviewPolyline?.points ?? '';
          polylineCoordinates = decodePolyline(points);

          polylines.clear(); // clear previous route
          polylines.add(
            Polyline(
              polylineId: PolylineId("route"),
              points: polylineCoordinates,
              color: Colors.black,
              width: 5,
            ),
          );
        });

        // Update driver marker
        final currentLatLng = LatLng(currentLat, currentLng);
        driverMarker = await getMarker(
            vehicleType: widget.data.vehicleTypeData?.nameEn ?? '',
            markerId: const MarkerId('driver'),
            position: currentLatLng,
            info: "You");

        // Update marker list
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
        controller.animateCamera(CameraUpdate.newLatLng(currentLatLng));

        // Check if driver reached destination
        final distance = Geolocator.distanceBetween(currentLat, currentLng, pickupLat, pickupLng);
        if (distance <= 70) {
          _locationSubscription?.cancel();
          popUp();
        }
      });
    } catch (e) {
      customPrint("ERROR: unable to initialize stream: $e");
    }
  }

  void popUp() {
    Future.delayed(Duration(milliseconds: 100), () {
      widget.type == 'urban'
          ? showCustomDialogOneButton(
              barrierDismissible: false,
              context: context,
              borderRadius: 18,
              title: AppLocalizations.of(context)!.reachedPickupLocationMsgString,
              buttonTitle: AppLocalizations.of(context)!.okString,
              onTap: () async {
                context.pop();
                await driverCubit
                    .changeRideStatus(
                  bookingId: widget.data.id ?? 1,
                  status: RideStatus.arrivedAtPickup.value,
                )
                    .then((value) {
                  context.pushReplacementNamed(startTripScreen, extra: {
                    'type': widget.type,
                    'data': widget.data,
                  });
                });
                await driverCubit.getDriverBookings();
              },
            )
          : showDynamicItemDialog(
              context: context,
              type: widget.type,
              bookingId: widget.data.id.toString(),
              data: widget.data,
            );
    });
  }

  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);
    getCurrentLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startTracking();
    });
    super.initState();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.35),
        child: Stack(
          children: [
            Container(
              height: size.width * 0.35,
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(size.width * 0.127),
                  bottomRight: Radius.circular(size.width * 0.127),
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.05,
              left: size.width * 0.05,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: size.width * 0.1,
                    child: CircleAvatar(
                      radius: size.width * 0.097,
                      backgroundImage: NetworkImage(
                        widget.data.driverData?.profilePhotoUrl ?? sampleNetworkImage,
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Center(
                    child: Text(
                      widget.data.driverData?.name ?? '',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  SizedBox(width: size.width * 0.09),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          makePhoneCall(widget.data.receiverContactNo ?? '');
                        },
                        child: Image.asset(
                          phoneCallIcon,
                          width: 24,
                          color: whiteColor,
                        ),
                      ),
                      SizedBox(width: size.width * 0.05),
                      GestureDetector(
                        onTap: () {
                          context.pushNamed(chatScreen, extra: {
                            'senderId': widget.data.driverId != null
                                ? widget.data.driverId.toString()
                                : authCubit.userDetails?.data?.id.toString(),
                            'receiverId': widget.data.userId.toString(),
                            'senderName': authCubit.userDetails?.data?.name,
                            'type': 'customer',
                            'receiverName': widget.data.userData?.name,
                            'receiverImageUrl': widget.data.userData?.profilePhotoUrl,
                          });
                        },
                        child: Icon(
                          Icons.chat,
                          color: whiteColor,
                          size: 24,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 15,
              top: size.width * 0.1,
              child: Text(
                widget.type == 'urban'
                    ? AppLocalizations.of(context)!.urbanString
                    : AppLocalizations.of(context)!.ruralString,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: 22, color: whiteColor),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          CustomText(text: AppLocalizations.of(context)!.pickupLocationString),
          const SizedBox(
            height: 4,
          ),
          ShowLocationWidget(
            address: widget.data.pickupAddress,
          ),
          const SizedBox(
            height: 12,
          ),
          CustomText(text: AppLocalizations.of(context)!.destinationLocationString),
          const SizedBox(
            height: 4,
          ),
          ShowLocationWidget(
            address: widget.data.dropAddress,
          ),
          const SizedBox(
            height: 24,
          ),
          CustomText(
            text: AppLocalizations.of(context)!.mapString,
            fontSize: 18,
          ),
          const SizedBox(
            height: 24,
          ),
          Expanded(
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
        ],
      ),
    );
  }
}
