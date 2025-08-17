import 'package:core/app_widgets.dart';
import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:datasource/states/data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/customer/model/booking_details_response.dart';
import 'package:globeporter/presentation/driver/cubit/driver_cubit.dart';
import 'package:globeporter/presentation/driver/model/ride_cancellation_reason_response.dart';
import 'package:globeporter/presentation/driver/states/driver_booking_states.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class DriverRideNotificationScreen extends StatefulWidget {
  const DriverRideNotificationScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  State<DriverRideNotificationScreen> createState() => _DriverRideNotificationScreenState();
}

class _DriverRideNotificationScreenState extends State<DriverRideNotificationScreen> {
  final driverCubit = sl<DriverCubit>();
  BookingDetailsResponse? bookingDetailsResponse;
  RideCancellationReasonResponse? rideCancellationReasonsResponse;
  final dialogLoadingNotifier = ValueNotifier(false);
  int? currentBookingId;
  int? currentReasonId;

  void loadBookingDetails() async {
    await driverCubit.getBookingDetails(bookingId: widget.bookingId);
  }

  void loadCancellationReasons() async {
    await driverCubit.getCancellationReasons(userType: '2');
  }

  void loadPendingBookings() async {
    await driverCubit.getPendingBookings();
  }

  @override
  void initState() {
    loadBookingDetails();
    loadCancellationReasons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.25),
        child: CustomStatusBarWidget(
          title: AppLocalizations.of(context)!.homeString,
        ),
      ),
      body: BlocConsumer(
        bloc: driverCubit,
        listener: (final context, final state) {
          if (state is BookingDetailsLoadedState) {
            bookingDetailsResponse = state.data as BookingDetailsResponse?;
          } else if (state is RideCancellationReasonsLoadedState) {
            rideCancellationReasonsResponse = state.data as RideCancellationReasonResponse?;
          } else if (state is DeclineRideByDriverLoadedState) {
            final data = state.data;
            context.pop();
            loadPendingBookings();
            Fluttertoast.showToast(msg: data['message']);
            setState(() {
              dialogLoadingNotifier.value = false;
            });
          } else if (state is AcceptRideLoadedState) {
            final data = state.data as Map<String, dynamic>;
            if (data['status_code'] == 200) {
              context.pushNamed(
                itemDetailsScreen,
                extra: {
                  'type': bookingDetailsResponse?.data?.rideType?.toLowerCase(),
                  'bookingId': bookingDetailsResponse?.data?.id.toString(),
                },
              );
              loadPendingBookings();
            } else {
              Fluttertoast.showToast(msg: data['message']);
            }
          } else if (state is ErrorState) {
            Fluttertoast.showToast(
              msg: state.errorMessage,
            );
          }
        },
        builder: (final context, final state) {
          if (state is BookingDetailsLoadingState) {
            return Center(
              child: LoadingWithoutText(),
            );
          } else {
            final trip = bookingDetailsResponse?.data;
            return Container(
              padding: EdgeInsets.all(20),
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
                  mainAxisSize: MainAxisSize.min,
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
                              title: '₹100 ${AppLocalizations.of(context)!.deductionMessageString}',
                              onTapYes: () async {
                                context.pop();
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
                          textPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                          textPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }
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
