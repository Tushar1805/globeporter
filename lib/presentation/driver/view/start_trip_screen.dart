// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:datasource/states/data_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/location/cubit/location_cubit.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/driver/cubit/driver_cubit.dart';
import 'package:globeporter/presentation/driver/states/driver_booking_states.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_extension_functions.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_utils.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:globeporter/presentation/driver/model/pending_bookings_response.dart' as pending;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

class StartTripScreen extends StatefulWidget {
  const StartTripScreen({super.key, required this.type, required this.data});
  final String? type;
  final pending.Data? data;

  @override
  State<StartTripScreen> createState() => _StartTripScreenState();
}

class _StartTripScreenState extends State<StartTripScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final locationCubit = sl<LocationCubit>();
  final driverCubit = sl<DriverCubit>();
  final authCubit = sl<AuthCubit>();
  Position? position;
  final loc.Location _location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  FToast? fToast;
  Marker? driverMarker;
  bool rideStarted = false;
  bool loading = false;

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
        widget.data?.dropLat ?? 20.5574253,
        widget.data?.dropLng ?? 78.838695,
      );
      await locationCubit
          .routeDirection(
        pickupLat: widget.data?.pickupLat ?? 20.5574253,
        pickupLng: widget.data?.pickupLng ?? 78.838695,
        dropLat: widget.data?.dropLat ?? 20.5574253,
        dropLng: widget.data?.dropLng ?? 78.838695,
      )
          .then((final response) {
        final points = response?.routes?[0].overviewPolyline?.points ?? '';
        polylineCoordinates = decodePolyline(points);

        polylines.add(
          Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
            color: Colors.black,
            width: 5,
          ),
        );
        _markers?.add(
          Marker(
            markerId: MarkerId('drop'),
            position: latLng,
            infoWindow: InfoWindow(title: 'Destination'),
          ),
        );

        setState(() {});
      });

      final GoogleMapController mapController = await _controller.future;
      mapController.animateCamera(CameraUpdate.newLatLng(latLng));
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
    final permissionGranted = await _location.requestPermission();
    final serviceEnabled = await _location.serviceEnabled() || await _location.requestService();

    if (permissionGranted != loc.PermissionStatus.granted || !serviceEnabled) {
      return;
    }

    _locationSubscription?.cancel(); // cancel previous listener if any

    _locationSubscription = _location.onLocationChanged
        .throttleTime(const Duration(seconds: 5))
        .listen((locationData) async {
      if (locationData.latitude == null || locationData.longitude == null) return;

      final currentLat = locationData.latitude!;
      final currentLng = locationData.longitude!;
      final dropLat = widget.data?.dropLat ?? 0.0;
      final dropLng = widget.data?.dropLng ?? 0.0;

      // Update backend
      locationCubit.updateMyLocation(
        lat: currentLat,
        lng: currentLng,
        role: 'customer',
        userId: widget.data?.userId.toString(),
      );

      // Update route polyline
      await locationCubit
          .routeDirection(
        pickupLat: currentLat,
        pickupLng: currentLng,
        dropLat: dropLat,
        dropLng: dropLng,
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
          vehicleType: widget.data?.vehicleTypeData?.nameEn ?? '',
          markerId: const MarkerId('driver'),
          position: currentLatLng,
          info: "You");

      // Update marker list
      _markers = [
        driverMarker!,
        Marker(
          markerId: const MarkerId('drop'),
          position: LatLng(dropLat, dropLng),
          infoWindow: const InfoWindow(title: 'Destination'),
        ),
      ];

      setState(() {});

      // Move camera
      final controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(currentLatLng));

      // Check if driver reached destination
      final distance = Geolocator.distanceBetween(currentLat, currentLng, dropLat, dropLng);
      if (distance <= 50 && rideStarted) {
        _locationSubscription?.cancel();
        popUp();
      }
    });
  }

  void popUp() {
    Future.delayed(Duration(seconds: 2), () {
      showCustomDialogOneButton(
        context: context,
        borderRadius: 18,
        title: AppLocalizations.of(context)!.reachedDropLocationMsgString,
        buttonTitle: AppLocalizations.of(context)!.okString,
        onTap: () async {
          context.pop();
          await driverCubit.generateOtp(bookingId: widget.data?.id ?? 1);
          showOtpDialog(
            context: context,
            borderRadius: 18,
            title:
                "${AppLocalizations.of(context)!.startString} ${AppLocalizations.of(context)!.rideString}",
            onOtpSubmit: (otp) async {
              customPrint("OTP entered: $otp");
              await driverCubit.verifyEndRideOtpByDriver(
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
    rideStarted = RideStatus.rideStarted.value == widget.data?.bookingStatus;
    getCurrentLocation();
    startTracking();
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
                        widget.data?.userData?.profilePhotoUrl ?? sampleNetworkImage,
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Center(
                    child: Text(
                      widget.data?.userData?.name ?? '',
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
                          makePhoneCall(widget.data?.receiverContactNo ?? '');
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
                            'senderId': widget.data?.driverId.toString(),
                            'receiverId': widget.data?.userId.toString(),
                            'senderName': authCubit.userDetails?.data?.name,
                            'type': 'customer',
                            'receiverName': widget.data?.userData?.name,
                            'receiverImageUrl': widget.data?.userData?.profilePhotoUrl,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: rideStarted
          ? null
          : loading
              ? Container(
                  alignment: Alignment.bottomCenter,
                  width: 56,
                  height: 56,
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      strokeWidth: 5,
                    ),
                  ),
                )
              // show a wide button when not loading and ride not started
              : CustomElevatedButton(
                  name: AppLocalizations.of(context)!.startTripString,
                  borderRadius: 25,
                  alignment: Alignment.bottomCenter,
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    await driverCubit.generateOtp(bookingId: widget.data?.id ?? 1);
                    showOtpDialog(
                      context: context,
                      borderRadius: 18,
                      title:
                          "${AppLocalizations.of(context)!.startString} ${AppLocalizations.of(context)!.rideString}",
                      onOtpSubmit: (otp) async {
                        customPrint("OTP entered: $otp");
                        await driverCubit.verifyRideOtpByDriver(
                          bookingId: widget.data?.id ?? 1,
                          otp: otp,
                        );
                      },
                    );
                  },
                  nameSize: 20,
                ),
      body: BlocListener(
        bloc: driverCubit,
        listener: (final context, final state) async {
          if (state is VerifyRideOTPLoadingState || state is VerifyEndRideOTPLoadingState) {
            setState(() {
              loading = true;
            });
          } else if (state is VerifyRideOTPLoadedState) {
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
              await driverCubit.changeRideStatus(
                bookingId: widget.data?.id ?? 1,
                status: RideStatus.rideStarted.value,
              );
              await driverCubit.getDriverBookings();
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
              await driverCubit.endRideByDriver(
                bookingId: widget.data?.id ?? 1,
              );
            }
          } else if (state is EndRideLoadedState) {
            await driverCubit.getDriverBookings();
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
            // const SizedBox(
            //   height: 24,
            // ),
            // rideStarted
            //     ? SizedBox.shrink()
            //     : loading
            //         ? SizedBox.shrink()
            //         : CustomElevatedButton(
            //             name: AppLocalizations.of(context)!.startTripString,
            //             borderRadius: 25,
            //             alignment: Alignment.center,
            //             onPressed: () async {
            //               await driverCubit.generateOtp(bookingId: widget.data?.id ?? 1);
            //               showOtpDialog(
            //                 context: context,
            //                 borderRadius: 18,
            //                 title:
            //                     "${AppLocalizations.of(context)!.startString} ${AppLocalizations.of(context)!.rideString}",
            //                 onOtpSubmit: (otp) async {
            //                   customPrint("OTP entered: $otp");
            //                   await driverCubit.verifyRideOtpByDriver(
            //                     bookingId: widget.data?.id ?? 1,
            //                     otp: otp,
            //                   );
            //                 },
            //               );
            //             },
            //             nameSize: 20,
            //           ),
            // loading ? LoadingWithoutText() : SizedBox.shrink(),
            // const SizedBox(
            //   height: 20,
            // ),
          ],
        ),
      ),
    );
  }
}
