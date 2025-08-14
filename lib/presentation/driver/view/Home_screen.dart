// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:core/app_widgets.dart';
import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:datasource/states/data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/location/cubit/location_cubit.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/driver/cubit/driver_cubit.dart';
import 'package:globeporter/presentation/driver/model/pending_bookings_response.dart' as pending;
import 'package:globeporter/presentation/driver/model/ride_cancellation_reason_response.dart';
import 'package:globeporter/presentation/driver/states/driver_booking_states.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final driverCubit = sl<DriverCubit>();
  final authCubit = sl<AuthCubit>();
  final locationCubit = sl<LocationCubit>();
  String amount = '500';
  bool loading = false;
  final dialogLoadingNotifier = ValueNotifier(false);
  int? currentBookingId;
  int? currentReasonId;
  pending.Data? currentData;

  // LatLng? _currentPosition;
  final Location _location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  pending.PendingBookingsResponse? pendingBookingsResponse;
  RideCancellationReasonResponse? rideCancellationReasonsResponse;
  FToast? fToast;

  Future<void> startTracking() async {
    final permissionGranted = await _location.requestPermission();
    final serviceEnabled = await _location.serviceEnabled() || await _location.requestService();

    if (permissionGranted != PermissionStatus.granted || !serviceEnabled) {
      return;
    }

    // Configure frequency & power
    await _location.changeSettings(
      accuracy: LocationAccuracy.high, // or .high if you truly need it
      interval: 10000, // 10s
      distanceFilter: 20, // only push when moved ~20m
      pausesLocationUpdatesAutomatically: false,
    );

    // final service = FlutterBackgroundService();
    // service.invoke('updateConfig', {
    //   'userId': authCubit.userDetails?.data?.id.toString(),
    //   'role': 'driver',
    //   'type': authCubit.userDetails?.data?.vehicleDetailData?.vehicleTypeName,
    //   'active': false, // set to true when a trip starts to increase frequency
    // });

    // Run in background (keeps Android Foreground Service + iOS background updates)
    await _location.enableBackgroundMode(enable: true);

    _locationSubscription?.cancel(); // cancel previous listener if any

    _locationSubscription = _location.onLocationChanged
        .throttleTime(const Duration(seconds: 20))
        .listen((locationData) {
      if (locationData.latitude == null || locationData.longitude == null) return;

      final lat = locationData.latitude!;
      final lng = locationData.longitude!;

      locationCubit.updateMyLocation(
        lat: lat,
        lng: lng,
        role: 'driver',
        userId: authCubit.userDetails?.data?.id.toString(),
        type: authCubit.userDetails?.data?.vehicleDetailData?.vehicleTypeName,
      );
    });
  }

  void loadPendingBookings() async {
    await driverCubit.getPendingBookings();
  }

  void loadCancellationReasons() async {
    await driverCubit.getCancellationReasons(userType: '2');
  }

  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);

    startTracking();
    loadPendingBookings();
    loadCancellationReasons();
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
              top: size.width * 0.123,
              right: 15,
              child: Center(
                child: SvgPicture.asset(
                  appLogoSmall,
                  width: MediaQuery.sizeOf(context).width * .25,
                ),
              ),
            ),
            Positioned(
              top: size.width * 0.15,
              right: size.width * 0.32,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    context.pushNamed(notificationScreen);
                  },
                  child: Icon(
                    Icons.notifications_active_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.05,
              left: size.width * 0.05,
              child: BlocBuilder(
                bloc: authCubit,
                builder: (final context, final state) {
                  final name = authCubit.userDetails?.data?.name ?? 'User Name';
                  final profileUrl =
                      authCubit.userDetails?.data?.profilePhotoUrl ?? sampleNetworkImage;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.pushNamed(driverProfileScreen);
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: size.width * 0.1,
                          child: CircleAvatar(
                            radius: size.width * 0.097,
                            backgroundImage: NetworkImage(
                              profileUrl,
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.onboarding1Title,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.end,
                            ),
                            SizedBox(
                              width: size.width * 0.35,
                              child: Text(
                                name,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Positioned(
              right: 15,
              bottom: size.width * 0.08,
              child: GestureDetector(
                onTap: () => context.pushNamed(walletScreen),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  alignment: Alignment.bottomRight,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        coinImage,
                        width: size.width * 0.047,
                        height: size.width * 0.047,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      BlocConsumer(
                        bloc: driverCubit,
                        listener: (final context, final state) {
                          if (state is AmountDeductedState) {
                            setState(() {
                              amount = state.message;
                            });
                          }
                        },
                        builder: (final context, final state) {
                          return Text(
                            '$amount ${AppLocalizations.of(context)!.rsString}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontSize: 20, color: primaryColor),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: BlocConsumer(
        bloc: driverCubit,
        listener: (final context, final state) async {
          if (state is PendingBookingsLoadingState) {
            setState(() {
              loading = true;
            });
          } else if (state is CheckCancleRideByDriverLoadingState ||
              state is CancleRideByDriverLoadingState ||
              state is DeclineRideByDriverLoadingState) {
            setState(() {
              dialogLoadingNotifier.value = true;
            });
          } else if (state is DeclineRideByDriverLoadedState) {
            final data = state.data;
            context.pop();
            loadPendingBookings();
            showToast(
              context: context,
              fToast: fToast!,
              msg: data['message'],
              duration: 5,
            );
            setState(() {
              dialogLoadingNotifier.value = false;
            });
          } else if (state is PendingBookingsLoadedState) {
            final data = state.data as pending.PendingBookingsResponse?;
            if (data?.data == null) {
              pendingBookingsResponse = null;
            } else {
              pendingBookingsResponse = data;
            }
            setState(() {
              loading = false;
            });
          } else if (state is RideCancellationReasonsLoadedState) {
            rideCancellationReasonsResponse = state.data as RideCancellationReasonResponse?;
            setState(() {
              loading = false;
            });
          } else if (state is AcceptRideLoadedState) {
            final data = state.data as Map<String, dynamic>;
            if (data['status_code'] == 200) {
              context.pushNamed(
                itemDetailsScreen,
                extra: {
                  'type': currentData?.rideType?.toLowerCase(),
                  'data': currentData,
                },
              );
              loadPendingBookings();
            } else {
              showToast(
                context: context,
                fToast: fToast!,
                msg: data['message'],
                duration: 5,
              );
            }
          } else if (state is ErrorState) {
            setState(() {
              loading = false;
            });
            Fluttertoast.showToast(
              msg: state.errorMessage,
            );
          }
        },
        builder: (final context, final state) {
          if (state is PendingBookingsLoadingState ||
              state is RideCancellationReasonsLoadingState) {
            return Center(
              child: LoadingWithoutText(),
            );
          }
          return pendingBookingsResponse == null
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.hourglass_empty_outlined,
                      color: primaryColor,
                      size: 40,
                    ),
                    Text('No Bookings')
                  ],
                ))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: pendingBookingsResponse?.data?.length ?? 0,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        itemBuilder: (final context, final index) {
                          final trip = pendingBookingsResponse?.data?[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(9),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          trip?.receiverName ?? '',
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                fontSize: 20,
                                              ),
                                        ),
                                      ),
                                      Text(
                                        // formatDate(date: trip?.bookingDate ?? ''),
                                        trip?.bookingDate ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(fontSize: 15, color: greyTextColor),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.pickupLocationString,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  addressRow(address: trip?.pickupAddress),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.destinationLocationString,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  addressRow(address: trip?.dropAddress),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomElevatedButton(
                                        name: AppLocalizations.of(context)!.acceptString,
                                        borderRadius: 5,
                                        alignment: Alignment.centerLeft,
                                        onPressed: () {
                                          showCustomDialog(
                                            context: context,
                                            borderRadius: 18,
                                            title:
                                                '₹100 ${AppLocalizations.of(context)!.deductionMessageString}',
                                            onTapYes: () async {
                                              setState(() {
                                                currentData = trip;
                                              });
                                              context.pop();
                                              driverCubit.deductAmount();
                                              await driverCubit.acceptRide(
                                                bookingId: trip?.id ?? 1,
                                                status: 'Accept',
                                              );
                                            },
                                            onTapNo: () {
                                              context.pop();
                                            },
                                          );
                                        },
                                        textPadding:
                                            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.06,
                                      ),
                                      CustomElevatedButton(
                                        name: AppLocalizations.of(context)!.declineString,
                                        borderRadius: 5,
                                        alignment: Alignment.centerLeft,
                                        backgroundColor: Colors.red,
                                        onPressed: () {
                                          showReasonDialog(
                                            context: context,
                                            reasons: rideCancellationReasonsResponse,
                                            loadingNotifier: dialogLoadingNotifier,
                                            onTap: (final reasonId) async {
                                              setState(() {
                                                currentReasonId = int.parse(reasonId);
                                                currentBookingId = trip?.id ?? 1;
                                              });
                                              customPrint(
                                                  "Booking Id: $currentBookingId \n ReasonId: $currentReasonId");
                                              await driverCubit.declineRideByDriver(
                                                bookingId: currentBookingId ?? 1,
                                                reasonId: currentReasonId ?? 1,
                                              );
                                            },
                                          );
                                        },
                                        textPadding:
                                            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }

  Widget addressRow({required final String? address}) => Row(
        children: [
          Image.asset(
            locationPinImage,
            width: 24,
            height: 32,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              address ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
            ),
          )
        ],
      );
}
