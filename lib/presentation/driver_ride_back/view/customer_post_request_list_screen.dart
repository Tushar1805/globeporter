import 'package:core/app_widgets.dart';
import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/driver/widgets/address_row_widget.dart';
import 'package:globeporter/presentation/driver_ride_back/cubit/driver_ride_back_cubit.dart';
import 'package:globeporter/presentation/driver_ride_back/model/customer_posted_ride_list_model.dart';
import 'package:globeporter/presentation/driver_ride_back/states/driver_ride_back_state.dart';
import 'package:globeporter/presentation/notification/cubit/notification_cubit.dart';
import 'package:globeporter/presentation/notification/states/notification_states.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class PostRequestCustomerScreen extends StatefulWidget {
  const PostRequestCustomerScreen({super.key});

  @override
  State<PostRequestCustomerScreen> createState() => _PostRequestCustomerScreenState();
}

class _PostRequestCustomerScreenState extends State<PostRequestCustomerScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final notificationCubit = sl<NotificationCubit>();
  final driverRideBackCubit = sl<DriverRideBackCubit>();
  int notificationUnreadCount = 0;
  late AnimationController _notificationAnimationController;
  late Animation<double> _notificationScaleAnimation;
  CustomerPostedRidesListModel? customerPostedRidesListModel;
  FToast? fToast;

  void loadData() async {
    await driverRideBackCubit.getCustomerPostedRides();
    await notificationCubit.getNotificatinsUnreadCount();
  }

  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
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
                locale.postedRidesString,
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
        bloc: driverRideBackCubit,
        listener: (final context, final state) {
          if (state is CustomerPostedRidesLoadedState) {
            customerPostedRidesListModel = state.data as CustomerPostedRidesListModel?;
            _animationController.forward(from: 0);
          } else if (state is CustomerAcceptRejectLoadedState) {
            final data = state.data;
            showToast(
              context: context,
              fToast: fToast!,
              msg: data['message'],
              duration: 5,
            );
            if (data['status_code'] == 200) {
              driverRideBackCubit.getCustomerPostedRides();
            }
          }
        },
        builder: (final context, final state) {
          if (state is CustomerPostedRidesLoadingState) {
            return Center(
              child: LoadingWithoutText(),
            );
          }
          return (customerPostedRidesListModel?.data?.length ?? 0) == 0
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.hourglass_empty_outlined,
                        color: primaryColor,
                        size: 40,
                      ),
                      Text(
                        locale.noPostedRides,
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: customerPostedRidesListModel?.data?.length ?? 0,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        itemBuilder: (final context, final index) {
                          final ride = customerPostedRidesListModel?.data?[index];
                          return ScaleTransition(
                            scale: _scaleAnimation,
                            child: Padding(
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
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //   crossAxisAlignment: CrossAxisAlignment.start,
                                    //   children: [
                                    //     Expanded(
                                    //       child: Text(
                                    //         'Jon Doe',
                                    //         style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    //               fontSize: 20,
                                    //             ),
                                    //       ),
                                    //     ),
                                    //     Text(
                                    //       // formatDate(date: trip?.bookingDate ?? ''),
                                    //       '1234',
                                    //       style: Theme.of(context)
                                    //           .textTheme
                                    //           .bodyMedium
                                    //           ?.copyWith(fontSize: 15, color: greyTextColor),
                                    //     )
                                    //   ],
                                    // ),
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
                                    AddressRowWidget(address: ride?.pickupAddress),
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
                                    AddressRowWidget(address: ride?.dropAddress),
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
                                              title: locale.areYouSureYouWantToAcceptRideString,
                                              onTapYes: () async {
                                                driverRideBackCubit.customerAcceptRejectRide(
                                                  bookingId: ride?.id.toString() ?? '1',
                                                  status: 'Accept',
                                                );
                                                context.pop();
                                              },
                                              onTapNo: () {
                                                context.pop();
                                              },
                                            );
                                          },
                                          textPadding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
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
                                            showCustomDialog(
                                              context: context,
                                              borderRadius: 18,
                                              title: locale.areYouSureYouWantToRejectRideString,
                                              onTapYes: () async {
                                                driverRideBackCubit.customerAcceptRejectRide(
                                                  bookingId: ride?.id.toString() ?? '1',
                                                  status: 'Reject',
                                                );
                                                context.pop();
                                              },
                                              onTapNo: () {
                                                context.pop();
                                              },
                                            );
                                          },
                                          textPadding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                        )
                                      ],
                                    )
                                  ],
                                ),
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
}
