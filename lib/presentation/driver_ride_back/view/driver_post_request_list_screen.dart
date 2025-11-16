// ignore_for_file: use_build_context_synchronously

import 'package:core/app_widgets.dart';
import 'package:datasource/states/data_state.dart';
import 'package:flutter/material.dart';
import 'package:core/di/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  State<PostRequestDriverScreen> createState() =>
      _PostRequestDriverScreenState();
}

class _PostRequestDriverScreenState extends State<PostRequestDriverScreen>
    with TickerProviderStateMixin {
  final notificationCubit = sl<NotificationCubit>();
  final driverRideBackCubit = sl<DriverRideBackCubit>();
  final authCubit = sl<AuthCubit>();

  late final AnimationController _listAnimationController;
  late final AnimationController _notificationAnimCtrl;
  late final Animation<double> _listScaleAnimation;
  late final Animation<double> _notificationScaleAnimation;

  DriverPostedRidesModel? driverPostedRidesModel;
  int notificationUnreadCount = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });

    _listAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _listScaleAnimation = CurvedAnimation(
      parent: _listAnimationController,
      curve: Curves.easeInOutCubicEmphasized,
    );

    _notificationAnimCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _notificationScaleAnimation = CurvedAnimation(
        parent: _notificationAnimCtrl, curve: Curves.easeOutBack);
  }

  Future<void> _loadData() async {
    await Future.wait([
      driverRideBackCubit.getDriverPostedRides(),
      notificationCubit.getNotificatinsUnreadCount(),
    ]);
  }

  @override
  void dispose() {
    _listAnimationController.dispose();
    _notificationAnimCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.all(14),
        ),
        onPressed: () => context.pushNamed(newRideScreen),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, color: whiteColor, size: 24),
            const SizedBox(width: 6),
            Text(locale.postRequestString,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: whiteColor)),
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.35),
        child: Stack(
          children: [
            _HeaderBackground(size: size),
            _HeaderTitle(size: size, title: locale.postRequestString),
            Positioned(
              top: size.height * 0.055,
              right: 15,
              child: SvgPicture.asset(appLogoSmall, width: size.width * 0.25),
            ),
            BlocListener(
              bloc: notificationCubit,
              listener: (context, state) {
                if (state is NotificationUnreadCountLoadedState) {
                  notificationUnreadCount = state.data['noti_unread_count'];
                  _notificationAnimCtrl.forward(from: 0);
                }
              },
              child: Positioned(
                top: size.width * 0.1,
                right: size.width * 0.32,
                child: NotificationIcon(
                  animation: _notificationScaleAnimation,
                  count: notificationUnreadCount,
                  onTap: () => context.pushNamed(notificationScreen),
                ),
              ),
            ),
          ],
        ),
      ),
      body: BlocConsumer(
        bloc: driverRideBackCubit,
        listener: (context, state) {
          if (state is MyPostedRidesLoadedState) {
            driverPostedRidesModel = state.data as DriverPostedRidesModel?;
            _listAnimationController.forward(from: 0);
          }
        },
        builder: (context, state) {
          if (state is MyPostedRidesLoadingState ||
              state is NotificationUnreadCountLoadingState) {
            return const Center(child: LoadingWithoutText());
          }

          return RideList(
            rides: driverPostedRidesModel?.data ?? [],
            scaleAnimation: _listScaleAnimation,
            authCubit: authCubit,
            driverRideBackCubit: driverRideBackCubit,
          );
        },
      ),
    );
  }
}

class _HeaderBackground extends StatelessWidget {
  final Size size;
  const _HeaderBackground({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.width * 0.25,
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(size.width * 0.127),
          bottomRight: Radius.circular(size.width * 0.127),
        ),
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  final Size size;
  final String title;
  const _HeaderTitle({required this.size, required this.title});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: size.width * 0.1,
      left: size.width * 0.043,
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: whiteColor,
              fontSize: 24,
            ),
      ),
    );
  }
}

class NotificationIcon extends StatelessWidget {
  final Animation<double> animation;
  final int count;
  final VoidCallback onTap;

  const NotificationIcon({
    super.key,
    required this.animation,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          const SizedBox(
            height: 40,
            width: 40,
            child: Icon(Icons.notifications_active_outlined,
                color: Colors.white, size: 30),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: ScaleTransition(
              scale: animation,
              child: UnreadBadge(count: count),
            ),
          ),
        ],
      ),
    );
  }
}

class RideList extends StatelessWidget {
  final List<RideData> rides;
  final Animation<double> scaleAnimation;
  final AuthCubit authCubit;
  final DriverRideBackCubit driverRideBackCubit;

  const RideList({
    super.key,
    required this.rides,
    required this.scaleAnimation,
    required this.authCubit,
    required this.driverRideBackCubit,
  });

  @override
  Widget build(BuildContext context) {
    if (rides.isEmpty) {
      return const Center(child: Text('No rides posted yet.'));
    }

    return ListView.builder(
      itemCount: rides.length,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemBuilder: (context, index) {
        return RideTile(
          ride: rides[index],
          animation: scaleAnimation,
          authCubit: authCubit,
          driverRideBackCubit: driverRideBackCubit,
        );
      },
    );
  }
}

class RideTile extends StatelessWidget {
  final RideData ride;
  final Animation<double> animation;
  final AuthCubit authCubit;
  final DriverRideBackCubit driverRideBackCubit;

  const RideTile({
    super.key,
    required this.ride,
    required this.animation,
    required this.authCubit,
    required this.driverRideBackCubit,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final theme = Theme.of(context).textTheme;

    final acceptedUsers = ride.acceptedDriverBookingRideStatus ?? [];

    return ScaleTransition(
      scale: animation,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(locale.pickupLocationString,
                      style: theme.bodyMedium?.copyWith(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  AddressRowWidget(address: ride.pickupAddress),
                  const SizedBox(height: 8),
                  Text(locale.destinationLocationString,
                      style: theme.bodyMedium?.copyWith(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  AddressRowWidget(address: ride.dropAddress),
                  const SizedBox(height: 8),
                ],
              ),
              children: acceptedUsers.isEmpty
                  ? [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(locale.noUsersAcceptedYetString,
                            style: theme.bodyMedium),
                      ),
                    ]
                  : acceptedUsers
                      .map((user) => AcceptedUserCard(
                            ride: ride,
                            user: user,
                            authCubit: authCubit,
                            driverRideBackCubit: driverRideBackCubit,
                          ))
                      .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class AcceptedUserCard extends StatelessWidget {
  final RideData ride;
  final AcceptedDriverBookingRideStatus user;
  final AuthCubit authCubit;
  final DriverRideBackCubit driverRideBackCubit;

  const AcceptedUserCard({
    super.key,
    required this.ride,
    required this.user,
    required this.authCubit,
    required this.driverRideBackCubit,
  });

  @override
  Widget build(BuildContext context) {
    final profileUrl = user.userData?.profilePhotoUrl ?? '';
    // final isUserAccepted = (user.userData?.id == ride.userData?.id);
    final isUserAccepted = user.status?.toLowerCase() == 'accept';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: isUserAccepted ? Colors.grey.shade100 : Colors.grey.shade300,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: primaryColor,
              backgroundImage:
                  profileUrl.isNotEmpty ? NetworkImage(profileUrl) : null,
              child: profileUrl.isEmpty
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.userName ?? 'Unknown User',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(user.userData?.email ?? '',
                      style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
            _ActionButtons(
              ride: ride,
              user: user,
              authCubit: authCubit,
              driverRideBackCubit: driverRideBackCubit,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final RideData ride;
  final AcceptedDriverBookingRideStatus user;
  final AuthCubit authCubit;
  final DriverRideBackCubit driverRideBackCubit;

  const _ActionButtons({
    required this.ride,
    required this.user,
    required this.authCubit,
    required this.driverRideBackCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      IconButton(
        icon: const Icon(Icons.call, color: primaryColor),
        onPressed: () {
          makePhoneCall(
            fromNumber: authCubit.userDetails?.data?.mobile ?? '',
            toNumber: user.userData?.mobile ?? '',
            context: context,
          );
        },
      ),
      IconButton(
        icon: const Icon(Icons.message, color: primaryColor),
        onPressed: () {
          context.pushNamed(chatScreen, extra: {
            'senderId': ride.driverId?.toString() ??
                authCubit.userDetails?.data?.id.toString(),
            'receiverId': user.userId.toString(),
            'senderName': authCubit.userDetails?.data?.name,
            'type': 'driver',
            'receiverName': user.userData?.name,
            'receiverImageUrl': user.userData?.profilePhotoUrl,
          });
        },
      ),
      BlocListener(
        bloc: driverRideBackCubit,
        listener: (final context, final state) {
          if (state is DriverAcceptRejectLoadedState) {
            final data = state.data as Map<String, dynamic>;
            if (data['status_code'] == 200) {
              context.pushNamed(driverTrackingScreen, extra: {
                'rideData': ride,
                'customerData': user,
              });
              driverRideBackCubit.getDriverPostedRides();
            } else {
              Fluttertoast.showToast(msg: 'Something went wrong');
            }
          } else if (state is ErrorState) {
            Fluttertoast.showToast(msg: state.errorMessage);
          }
        },
        child: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, color: primaryColor),
          onPressed: () async {
            ride.isBookingActive == 1
                ? context.pushNamed(driverTrackingScreen, extra: {
                    'rideData': ride,
                    'customerData': user,
                  })
                : showCustomDialog(
                    context: context,
                    borderRadius: 18,
                    title:
                        '₹100 ${AppLocalizations.of(context)!.deductionMessageString}',
                    onTapYes: () async {
                      context.pop();
                      await driverRideBackCubit.driverAcceptRejectRide(
                        bookingId: ride.id.toString(),
                        status: 'Accept',
                        userId: user.userId.toString(),
                      );
                    },
                    onTapNo: () {
                      context.pop();
                    },
                  );
          },
        ),
      ),
    ]);
  }
}
