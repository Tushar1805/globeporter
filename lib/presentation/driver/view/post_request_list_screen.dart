import 'package:core/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:core/di/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/driver_ride_back/cubit/driver_ride_back_cubit.dart';
import 'package:globeporter/presentation/driver_ride_back/model/my_posted_ride_model.dart';
import 'package:globeporter/presentation/driver_ride_back/states/driver_ride_back_state.dart';
import 'package:globeporter/presentation/notification/cubit/notification_cubit.dart';
import 'package:globeporter/presentation/notification/states/notification_states.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
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
  int notificationUnreadCount = 0;
  late AnimationController _notificationAnimationController;
  late Animation<double> _notificationScaleAnimation;
  MyPostedRidesModel? myPostedRidesModel;

  void loadData() async {
    await driverRideBackCubit.getMyPostedRides();
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
            myPostedRidesModel = state.data as MyPostedRidesModel?;
            _animationController.forward(from: 0);
          }
        },
        builder: (final context, final state) {
          if (state is MyPostedRidesLoadingState || state is NotificationUnreadCountLoadingState) {
            return Center(
              child: LoadingWithoutText(),
            );
          }
          return ListView.builder(
              itemCount: myPostedRidesModel?.data?.length,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemBuilder: (context, index) {
                final ride = myPostedRidesModel?.data?[index];
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
                          addressRow(address: ride?.pickupAddress),
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
                          addressRow(address: ride?.dropAddress),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
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
