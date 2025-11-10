// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:datasource/states/data_state.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/location/cubit/location_cubit.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/driver_ride_back/cubit/driver_ride_back_cubit.dart';
import 'package:globeporter/presentation/driver_ride_back/model/driver_posted_ride_model.dart';
import 'package:globeporter/presentation/driver_ride_back/states/driver_ride_back_state.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_utils.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverRideBackTrackScreen extends StatefulWidget {
  const DriverRideBackTrackScreen({required this.data, required this.customerData, super.key});

  final RideData? data;
  final AcceptedDriverBookingRideStatus? customerData;

  @override
  State<DriverRideBackTrackScreen> createState() => _DriverRideBackTrackScreenState();
}

class _DriverRideBackTrackScreenState extends State<DriverRideBackTrackScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final locationCubit = sl<LocationCubit>();
  final authCubit = sl<AuthCubit>();
  final driverRideBackCubit = sl<DriverRideBackCubit>();
  Position? position;
  StreamSubscription<dynamic>? _locationSubscription;
  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  FToast? fToast;
  Marker? driverMarker;
  bool rideStarted = false;
  bool loading = false;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('locations');

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(20.5574253, 78.8386951),
    zoom: 14,
  );

  List<Marker>? _markers;

  void getCurrentLocation() async {
    try {
      final GoogleMapController controller = await _controller.future;

      _kGooglePlex = CameraPosition(
        target: LatLng(widget.data?.pickupLat ?? 20.5574253, widget.data?.pickupLng ?? 78.8386951),
        zoom: 14,
      );
      _markers = <Marker>[
        Marker(
          markerId: MarkerId('1'),
          position:
              LatLng(widget.data?.pickupLat ?? 20.5574253, widget.data?.pickupLat ?? 20.5574253),
          // infoWindow: InfoWindow(title: 'The title of the marker'),
        )
      ];
      controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));

      final latLng = LatLng(
        widget.data?.pickupLat ?? 20.5574253,
        widget.data?.pickupLng ?? 78.838695,
      );

      final GoogleMapController mapController = await _controller.future;
      mapController.animateCamera(CameraUpdate.newLatLng(latLng));
    } catch (e) {
      debugPrint("Error: Getting Location: $e");
    }
  }

  Future<void> startCustomerTracking() async {
    final pickupLat = widget.data?.pickupLat ?? 0.0; // Driver's pickup point (fixed)
    final pickupLng = widget.data?.pickupLng ?? 0.0;
    final customerId = widget.customerData?.userData?.id?.toString();

    if (customerId == null || customerId.isEmpty) {
      customPrint('❌ No customerId found');
      return;
    }

    try {
      // Listen to customer's location from Firebase
      _locationSubscription = _dbRef.child(customerId).onValue.listen((event) async {
        final data = event.snapshot.value as Map?;
        if (data == null || data['latitude'] == null || data['longitude'] == null) return;

        final currentLat = (data['latitude'] as num).toDouble();
        final currentLng = (data['longitude'] as num).toDouble();
        final currentLatLng = LatLng(currentLat, currentLng);

        // 🗺 Update route between customer and pickup point
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
          polylines.clear();
          polylines.add(
            Polyline(
              polylineId: const PolylineId("route"),
              points: polylineCoordinates,
              color: primaryColor,
              width: 5,
            ),
          );
        });

        // 👤 Update customer marker
        final customerMarker = await getMarker(
          vehicleType: widget.data?.vehicleTypeData?.nameEn ?? '',
          markerId: const MarkerId('customer'),
          position: currentLatLng,
          info: "Customer",
        );

        _markers = [
          customerMarker,
          Marker(
            markerId: const MarkerId('pickup'),
            position: LatLng(pickupLat, pickupLng),
            infoWindow: const InfoWindow(title: 'Pickup Point'),
          ),
        ];

        setState(() {});

        //  Move camera smoothly
        final controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newLatLng(currentLatLng));

        //  Calculate distance between customer and pickup
        final pickupDistance =
            Geolocator.distanceBetween(currentLat, currentLng, pickupLat, pickupLng);
        customPrint('Customer distance from pickup: ${pickupDistance.toStringAsFixed(2)} m');

        if (pickupDistance <= 70) {
          //  Customer reached pickup
          _locationSubscription?.cancel();
          popUp(); // your existing dialog when reached
        }
      });
    } catch (e) {
      customPrint("ERROR: Unable to listen to customer tracking: $e");
    }
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
          await driverRideBackCubit.generatePostedRideOtp(bookingId: widget.data?.id ?? 1);
          showOtpDialog(
            context: context,
            borderRadius: 18,
            title:
                "${AppLocalizations.of(context)!.startString} ${AppLocalizations.of(context)!.rideString}",
            onOtpSubmit: (otp) async {
              customPrint("OTP entered: $otp");
              await driverRideBackCubit.verifyStartRideOtpByDriver(
                bookingId: widget.data?.id ?? 1,
                otp: otp,
              );
            },
          );
        },
      );
    });
  }

  Future<void> startRideTracking() async {
    final driverId = widget.data?.driverId?.toString() ?? '';
    final dropLat = widget.data?.dropLat ?? 0.0;
    final dropLng = widget.data?.dropLng ?? 0.0;

    if (driverId.isEmpty) {
      customPrint('❌ Driver ID not found');
      return;
    }

    try {
      // Cancel any previous subscription (from customer tracking)
      await _locationSubscription?.cancel();

      // Start listening to driver’s location from Firebase
      _locationSubscription = _dbRef.child(driverId).onValue.listen((event) async {
        final data = event.snapshot.value as Map?;
        if (data == null || data['latitude'] == null || data['longitude'] == null) return;

        final driverLat = (data['latitude'] as num).toDouble();
        final driverLng = (data['longitude'] as num).toDouble();
        final driverLatLng = LatLng(driverLat, driverLng);

        // Get and draw the route between driver → drop location
        await locationCubit
            .routeDirection(
          pickupLat: driverLat,
          pickupLng: driverLng,
          dropLat: dropLat,
          dropLng: dropLng,
        )
            .then((response) {
          final points = response?.routes?[0].overviewPolyline?.points ?? '';
          polylineCoordinates = decodePolyline(points);

          polylines
            ..clear()
            ..add(
              Polyline(
                polylineId: const PolylineId("driver_to_drop"),
                points: polylineCoordinates,
                color: primaryColor,
                width: 5,
              ),
            );
        });

        // Update driver marker
        final driverMarker = await getMarker(
          vehicleType: widget.data?.vehicleTypeData?.nameEn ?? '',
          markerId: const MarkerId('driver'),
          position: driverLatLng,
          info: "Driver",
        );

        _markers = [
          driverMarker,
          Marker(
            markerId: const MarkerId('drop'),
            position: LatLng(dropLat, dropLng),
            infoWindow: const InfoWindow(title: 'Drop Location'),
          ),
        ];

        setState(() {});

        // Move camera to driver smoothly
        final controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newLatLng(driverLatLng));

        // Check if driver reached the destination
        final distance = Geolocator.distanceBetween(driverLat, driverLng, dropLat, dropLng);
        customPrint('Driver distance to drop: ${distance.toStringAsFixed(2)} m');

        if (distance <= 70) {
          _locationSubscription?.cancel();

          // Ride complete popup
          popUpRideComplete(); // custom popup for ride completion
        }
      });
    } catch (e) {
      customPrint('❌ ERROR: Unable to start ride tracking: $e');
    }
  }

  void popUpRideComplete() {
    Future.delayed(Duration(milliseconds: 100), () {
      showCustomDialogOneButton(
        barrierDismissible: false,
        context: context,
        borderRadius: 18,
        title: AppLocalizations.of(context)!.reachedDropLocationMsgString,
        buttonTitle: AppLocalizations.of(context)!.okString,
        onTap: () async {
          context.pop();
          await driverRideBackCubit.generatePostedRideOtp(bookingId: widget.data?.id ?? 1);
          showOtpDialog(
            context: context,
            borderRadius: 18,
            title:
                "${AppLocalizations.of(context)!.startString} ${AppLocalizations.of(context)!.rideString}",
            onOtpSubmit: (otp) async {
              customPrint("OTP entered: $otp");
              await driverRideBackCubit.verifyEndRideOtpByDriver(
                bookingId: widget.data?.id ?? 1,
                otp: otp,
              );
            },
          );
        },
      );
    });
  }

  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);
    getCurrentLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startCustomerTracking();
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
              top: size.height * 0.058,
              left: size.width * 0.043,
              child: GestureDetector(
                onTap: context.pop,
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: whiteColor,
                  size: 20,
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.05,
              left: size.width * 0.12,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: size.width * 0.1,
                    child: CircleAvatar(
                      radius: size.width * 0.097,
                      backgroundImage: NetworkImage(
                        widget.customerData?.userData?.profilePhotoUrl ?? sampleNetworkImage,
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 15),
                  SizedBox(
                    width: size.width * 0.3,
                    child: Center(
                      child: Text(
                        widget.customerData?.userData?.name ?? '',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                        // textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.09),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          makePhoneCall(
                            fromNumber: authCubit.userDetails?.data?.mobile ?? '',
                            toNumber: widget.customerData?.userData?.mobile ?? '',
                            context: context,
                          );
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
                            'senderId': widget.data?.driverId != null
                                ? widget.data?.driverId.toString()
                                : authCubit.userDetails?.data?.id.toString(),
                            'receiverId': widget.customerData?.userData?.id.toString(),
                            'senderName': authCubit.userDetails?.data?.name,
                            'type': 'driver',
                            'receiverName': widget.customerData?.userData?.name,
                            'receiverImageUrl': widget.customerData?.userData?.profilePhotoUrl,
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
          ],
        ),
      ),
      body: BlocListener(
        bloc: driverRideBackCubit,
        listener: (final context, final state) async {
          if (state is VerifyStartRideOTPLoadingState || state is VerifyEndRideOTPLoadingState) {
            setState(() {
              loading = true;
            });
          } else if (state is VerifyStartRideOTPLoadedState) {
            final data = state.data;
            if (data['status_code'] == 200) {
              // Remove otp box first
              context.pop();
              showToast(
                context: context,
                fToast: fToast!,
                msg:
                    "${AppLocalizations.of(context)!.rideString} ${AppLocalizations.of(context)!.startedString} ",
                duration: 3,
              );
              startRideTracking();
              setState(() {
                rideStarted = true;
                loading = false;
              });
            }
          } else if (state is VerifyEndRideOTPLoadedState) {
            final data = state.data;
            if (data['status_code'] == 200) {
              // remove otp box first
              context.pop();
              await driverRideBackCubit.endRideByDriver(
                bookingId: widget.data?.id ?? 1,
              );
            }
          } else if (state is EndRideLoadedState) {
            showToast(
              context: context,
              fToast: fToast!,
              msg: "${AppLocalizations.of(context)!.rideString} Completed} ",
              duration: 3,
            );
            await driverRideBackCubit.getDriverPostedRides();
            context.pop();
          } else if (state is ErrorState) {
            if (state.errorMessage == 'OTP not match') {
              showToast(
                context: context,
                fToast: fToast!,
                msg: state.errorMessage,
                duration: 3,
              );
              setState(() {
                loading = false;
              });
            } else {
              setState(() {
                rideStarted = false;
                loading = false;
              });
              showToast(
                context: context,
                fToast: fToast!,
                msg: state.errorMessage,
                duration: 3,
              );
            }
          } else if (state is RideOTPNotMatchState) {
            showToast(
              context: context,
              fToast: fToast!,
              msg: state.loadingMessage ?? 'OTP not match',
              duration: 3,
            );
            setState(() {
              loading = false;
            });
          }
        },
        child: Column(
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
              address: widget.data?.pickupAddress,
            ),
            const SizedBox(
              height: 12,
            ),
            CustomText(text: AppLocalizations.of(context)!.destinationLocationString),
            const SizedBox(
              height: 4,
            ),
            ShowLocationWidget(
              address: widget.data?.dropAddress,
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
      ),
    );
  }
}
