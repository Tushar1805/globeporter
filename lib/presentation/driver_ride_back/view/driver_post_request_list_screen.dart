// ignore_for_file: use_build_context_synchronously

import 'package:core/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:core/di/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/driver/widgets/address_row_widget.dart';
import 'package:globeporter/presentation/driver_ride_back/cubit/driver_ride_back_cubit.dart';
import 'package:globeporter/presentation/driver_ride_back/model/driver_posted_ride_model.dart';
import 'package:globeporter/presentation/driver_ride_back/states/driver_ride_back_state.dart';
import 'package:globeporter/presentation/notification/cubit/notification_cubit.dart';
import 'package:globeporter/presentation/notification/states/notification_states.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_utils.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class PostRequestDriverScreen extends StatefulWidget {
  const PostRequestDriverScreen({super.key});

  @override
  State<PostRequestDriverScreen> createState() => _PostRequestDriverScreenState();
}

class _PostRequestDriverScreenState extends State<PostRequestDriverScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final notificationCubit = sl<NotificationCubit>();
  final driverRideBackCubit = sl<DriverRideBackCubit>();
  final authCubit = sl<AuthCubit>();
  int notificationUnreadCount = 0;
  late AnimationController _notificationAnimationController;
  late Animation<double> _notificationScaleAnimation;
  DriverPostedRidesModel? driverPostedRidesModel;
  RideData? rideData;

  void loadData() async {
    await driverRideBackCubit.getDriverPostedRides();
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locale = AppLocalizations.of(context)!;
    final theme = Theme.of(context).textTheme;
    return Scaffold(
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
              locale.postRequestString,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: whiteColor),
            ),
          ],
        ),
      ),
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
                locale.postRequestString,
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
          if (state is MyPostedRidesLoadedState) {
            driverPostedRidesModel = state.data as DriverPostedRidesModel?;
            _animationController.forward(from: 0);
          } else if (state is DriverAcceptRejectLoadedState) {
            // final data = state.data as Map<String, dynamic>;
            driverRideBackCubit.getDriverPostedRides();
          }
        },
        builder: (final context, final state) {
          if (state is MyPostedRidesLoadingState || state is NotificationUnreadCountLoadingState) {
            return Center(
              child: LoadingWithoutText(),
            );
          }
          return ListView.builder(
              itemCount: driverPostedRidesModel?.data?.length,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemBuilder: (context, index) {
                final ride = driverPostedRidesModel?.data?[index];
                final acceptedUsers = ride?.acceptedDriverBookingRideStatus;
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
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                            ],
                          ),
                          children: [
                            if (acceptedUsers?.isEmpty ?? false)
                              Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  locale.noUsersAcceptedYetString,
                                  style: theme.bodyMedium,
                                ),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: acceptedUsers?.length,
                                itemBuilder: (context, i) {
                                  final user = acceptedUsers?[i];
                                  final profileUrl = user?.userData?.profilePhotoUrl;
                                  final isUserAccepted = ((user?.userData?.id ?? false) ==
                                      (ride?.userData?.id ?? false));
                                  return Card(
                                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    color: isUserAccepted
                                        ? Colors.grey.shade100
                                        : Colors.grey.shade300,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 24,
                                            backgroundColor: primaryColor,
                                            backgroundImage:
                                                profileUrl != null && profileUrl.isNotEmpty
                                                    ? NetworkImage(profileUrl)
                                                    : null,
                                            child: (profileUrl == null || profileUrl.isEmpty)
                                                ? const Icon(Icons.person, color: Colors.white)
                                                : null,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  user?.userName ?? 'Unknown User',
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold, fontSize: 15),
                                                ),
                                                Text(
                                                  user?.userData?.email ?? '',
                                                  style: const TextStyle(
                                                      fontSize: 13, color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.call, color: primaryColor),
                                            onPressed: () {
                                              if (isUserAccepted || ride?.isBookingActive == 0) {
                                                makePhoneCall(
                                                  fromNumber:
                                                      authCubit.userDetails?.data?.mobile ?? '',
                                                  toNumber: user?.userData?.mobile ?? '',
                                                  context: context,
                                                );
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.message, color: primaryColor),
                                            onPressed: () {
                                              if (isUserAccepted || ride?.isBookingActive == 0) {
                                                context.pushNamed(chatScreen, extra: {
                                                  'senderId': ride?.driverId != null
                                                      ? ride?.driverId.toString()
                                                      : authCubit.userDetails?.data?.id.toString(),
                                                  'receiverId': user?.userId.toString(),
                                                  'senderName': authCubit.userDetails?.data?.name,
                                                  'type': 'driver',
                                                  'receiverName': user?.userData?.name,
                                                  'receiverImageUrl':
                                                      user?.userData?.profilePhotoUrl,
                                                });
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.arrow_forward_ios,
                                                color: primaryColor),
                                            onPressed: () {
                                              if (ride?.isBookingActive == 0) {
                                                // Navigate to next step screen
                                                showCustomDialog(
                                                  context: context,
                                                  borderRadius: 18,
                                                  title:
                                                      '₹100 ${AppLocalizations.of(context)!.deductionMessageString}',
                                                  onTapYes: () async {
                                                    setState(() {
                                                      rideData = ride;
                                                    });
                                                    context.pop();
                                                    await driverRideBackCubit
                                                        .driverAcceptRejectRide(
                                                      bookingId: user?.bookingId.toString() ?? '1',
                                                      userId: user?.userId.toString() ?? '1',
                                                      status: 'Accept',
                                                    )
                                                        .then((_) {
                                                      context
                                                          .pushNamed(driverTrackingScreen, extra: {
                                                        'rideData': ride,
                                                        'customerData': user,
                                                      });
                                                    });
                                                  },
                                                  onTapNo: () {
                                                    context.pop();
                                                  },
                                                );
                                              } else {
                                                // Navigate to track screen
                                                context.pushNamed(driverTrackingScreen, extra: {
                                                  'rideData': ride,
                                                  'customerData': user,
                                                });
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
