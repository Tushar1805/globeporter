import 'package:core/app_widgets.dart';
import 'package:core/di/service_locator.dart';
import 'package:datasource/states/data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/customer/cubit/customer_cubit.dart';
import 'package:globeporter/presentation/customer/model/customer_ride_response.dart';
import 'package:globeporter/presentation/customer/states/customer_states.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_utils.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class MyRequestScreen extends StatefulWidget {
  const MyRequestScreen({super.key, this.onCreateRequestTap});
  final VoidCallback? onCreateRequestTap;

  @override
  State<MyRequestScreen> createState() => _MyRequestScreenState();
}

class _MyRequestScreenState extends State<MyRequestScreen> {
  final customerCubit = sl<CustomerCubit>();
  //* signifies to show the no requests widget
  bool show = false;
  CustomerRideBookingResponse? customerRideBookingResponse;

  void loadData() async {
    await customerCubit.getCustomerRideBookings();
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.25),
        child: CustomStatusBarWidget(
          title: AppLocalizations.of(context)!.myRequestString,
          fontSize: 22,
        ),
      ),
      body: BlocConsumer(
        bloc: customerCubit,
        listener: (final context, final state) {
          if (state is CustomerRideBookingsLoadedState) {
            customerRideBookingResponse = state.data as CustomerRideBookingResponse?;
            if (customerRideBookingResponse == null ||
                (customerRideBookingResponse != null &&
                    (customerRideBookingResponse?.data?.isEmpty ?? false))) {
              setState(() {
                show = true;
              });
            }
          } else if (state is ErrorState) {
            Fluttertoast.showToast(msg: state.errorMessage);
            setState(() {
              show = true;
            });
          }
        },
        builder: (final context, final state) {
          if (state is CustomerRideBookingsLoadingState) {
            return Center(child: LoadingWithoutText());
          } else {
            return Column(
              children: [
                (!show)
                    ? Expanded(
                        child: customListView(
                          response: customerRideBookingResponse,
                        ),
                      )
                    : Column(
                        children: [
                          SizedBox(height: size.width * 0.2),
                          SizedBox(
                            height: size.width * 0.6,
                            width: size.width * 0.6,
                            child: Card(
                              elevation: 10,
                              color: Color(0xFFE0FFDD),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(size.width),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: SvgPicture.asset(emptyBoxImage),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            AppLocalizations.of(context)!.noRequestString,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            AppLocalizations.of(context)!.orderHistoryDesc,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF7D7171),
                                ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: size.width * 0.2),
                          CustomElevatedButton(
                            name: AppLocalizations.of(context)!.createRequestString,
                            borderRadius: 8,
                            alignment: Alignment.center,
                            onPressed: widget.onCreateRequestTap ?? () {},
                          )
                        ],
                      )
              ],
            );
          }
        },
      ),
    );
  }

  Widget customListView({required final CustomerRideBookingResponse? response}) => ListView.builder(
        itemCount: response?.data?.length,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        itemBuilder: (final context, final index) {
          final request = response?.data?[index];
          return GestureDetector(
            onTap: () {
              context.pushNamed(myRequestDetailsScreen, extra: {
                'type': request?.rideType?.toLowerCase(),
                'bookingId': request?.id.toString(),
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          locationPinImage,
                          width: 24,
                          height: 32,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: CustomRichText(
                            title: '${AppLocalizations.of(context)!.destinationLocationString}: ',
                            value: request?.dropAddress,
                          ),
                        )
                      ],
                    ),
                    request?.rideType?.toLowerCase() == 'urban'
                        ? const SizedBox(
                            height: 8,
                          )
                        : SizedBox.shrink(),
                    request?.rideType?.toLowerCase() == 'urban' &&
                            (request?.bookingRideItem?.isNotEmpty ?? false)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: request!.bookingRideItem!.map((booking) {
                              return CustomRichText(
                                title: '${AppLocalizations.of(context)!.descriptionString}: ',
                                value: booking.description ?? '',
                              );
                            }).toList(),
                          )
                        : SizedBox.shrink(),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomRichText(
                      title: '${AppLocalizations.of(context)!.statusString}: ',
                      value: request?.bookingStatus ?? AppLocalizations.of(context)!.pendingString,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomRichText(
                          title: '${AppLocalizations.of(context)!.typeString}: ',
                          value: request?.rideType,
                        ),
                        CustomRichText(
                          title: '${AppLocalizations.of(context)!.dateString}: ',
                          value: (request?.createdAt != null)
                              ? formatDate(date: request?.createdAt ?? '')
                              : '',
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
}
