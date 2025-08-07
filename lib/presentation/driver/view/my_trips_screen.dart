import 'package:core/app_widgets.dart';
import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:datasource/states/data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/driver/cubit/driver_cubit.dart';
import 'package:globeporter/presentation/driver/model/pending_bookings_response.dart';
import 'package:globeporter/presentation/driver/states/driver_booking_states.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  final driverCubit = sl<DriverCubit>();
  bool loading = false;
  PendingBookingsResponse? driverBookingsResponse;
  FToast? fToast;

  void loadDriverBookings() async {
    await driverCubit.getDriverBookings();
  }

  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);

    loadDriverBookings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.35),
        child: CustomStatusBarWidget(
          title: AppLocalizations.of(context)!.myTripsString,
        ),
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Large enough for pill shape
          ),
          padding: const EdgeInsets.all(14),
        ),
        onPressed: () {
          context.pushNamed(newRideScreen);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add,
              color: whiteColor,
              size: 24,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              AppLocalizations.of(context)!.newRideString,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: whiteColor),
            ),
          ],
        ),
      ),
      body: BlocConsumer(
        bloc: driverCubit,
        listener: (final context, final state) {
          if (state is DriverBookingsLoadingState) {
            setState(() {
              loading = true;
            });
          } else if (state is DriverBookingsLoadedState) {
            driverBookingsResponse = state.data as PendingBookingsResponse?;
            setState(() {
              loading = false;
            });
          } else if (state is ErrorState) {
            setState(() {
              loading = false;
            });
            showToast(
              gravity: ToastGravity.CENTER,
              context: context,
              fToast: fToast!,
              msg: state.errorMessage,
              duration: 5,
            );
          }
        },
        builder: (final context, final state) {
          if (state is DriverBookingsLoadingState) {
            return Center(
              child: LoadingWithoutText(),
            );
          }
          return driverBookingsResponse == null
              ? SizedBox.shrink()
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: driverBookingsResponse?.data?.length,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        itemBuilder: (final context, final index) {
                          final trip = driverBookingsResponse?.data?[index];
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
                                  CustomRichText(
                                      title: '${AppLocalizations.of(context)!.statusString}: ',
                                      value: trip?.bookingStatus),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  trip?.isBookingActive == 1
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CustomElevatedButton(
                                              name: AppLocalizations.of(context)!.goString,
                                              borderRadius: 5,
                                              alignment: Alignment.centerLeft,
                                              onPressed: () {
                                                context.pushNamed(
                                                  itemDetailsScreen,
                                                  extra: {
                                                    'type': trip?.rideType?.toLowerCase(),
                                                    'data': trip,
                                                  },
                                                );
                                              },
                                              textPadding: const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 4),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.06,
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),
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
