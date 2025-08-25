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
import 'package:globeporter/presentation/notification/cubit/notification_cubit.dart';
import 'package:globeporter/presentation/notification/states/notification_states.dart';
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

class _MyRequestScreenState extends State<MyRequestScreen> with TickerProviderStateMixin {
  final customerCubit = sl<CustomerCubit>();
  //* signifies to show the no requests widget
  bool show = false;
  CustomerRideBookingResponse? customerRideBookingResponse;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final notificationCubit = sl<NotificationCubit>();
  int notificationUnreadCount = 0;
  late AnimationController _notificationAnimationController;
  late Animation<double> _notificationScaleAnimation;

  void loadData() async {
    await customerCubit.getCustomerRideBookings();
    await notificationCubit.getNotificatinsUnreadCount();
  }

  @override
  void initState() {
    loadData();

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _scaleAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOutCubicEmphasized);

    _notificationAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _notificationScaleAnimation =
        CurvedAnimation(parent: _notificationAnimationController, curve: Curves.easeOutBack);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _notificationAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.35),
        child: Stack(
          children: [
            Container(
              height: size.width * 0.25,
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
              top: size.height * 0.055,
              right: 15,
              child: Center(
                child: SvgPicture.asset(
                  appLogoSmall,
                  width: MediaQuery.sizeOf(context).width * .25,
                ),
              ),
            ),
            Positioned(
              top: size.width * 0.1,
              left: size.width * 0.043,
              child: Text(
                locale.myRequestString,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: whiteColor,
                      fontSize: 24,
                    ),
              ),
            ),
            BlocListener(
              bloc: notificationCubit,
              listener: (final context, final state) {
                if (state is NotificationUnreadCountLoadedState) {
                  setState(() {
                    notificationUnreadCount = state.data['noti_unread_count'];
                  });
                  _notificationAnimationController.forward(from: 0);
                }
              },
              child: Positioned(
                top: size.width * 0.1,
                right: size.width * 0.32,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      context.pushNamed(notificationScreen);
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Icon(
                            Icons.notifications_active_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: ScaleTransition(
                            scale: _notificationScaleAnimation,
                            child: UnreadBadge(
                              count: notificationUnreadCount,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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
            _animationController.forward(from: 0);
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
                          scale: _scaleAnimation,
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

  Widget customListView(
          {required final CustomerRideBookingResponse? response,
          required final Animation<double> scale}) =>
      ListView.builder(
        itemCount: response?.data?.length,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        itemBuilder: (final context, final index) {
          final request = response?.data?[index];
          return ScaleTransition(
            scale: scale,
            child: GestureDetector(
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
                              title: '${AppLocalizations.of(context)!.pickupLocationString}: ',
                              value: request?.pickupAddress,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
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
                        value:
                            request?.bookingStatus ?? AppLocalizations.of(context)!.pendingString,
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
            ),
          );
        },
      );
}
