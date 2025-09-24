import 'package:flutter/material.dart';
import 'package:core/di/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:globeporter/l10n/app_localizations.dart';
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
  // late AnimationController _animationController;
  // late Animation<double> _scaleAnimation;
  final notificationCubit = sl<NotificationCubit>();
  int notificationUnreadCount = 0;
  late AnimationController _notificationAnimationController;
  late Animation<double> _notificationScaleAnimation;

  void loadData() async {
    await notificationCubit.getNotificatinsUnreadCount();
  }

  @override
  void initState() {
    loadData();

    // _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    // _scaleAnimation =
    //     CurvedAnimation(parent: _animationController, curve: Curves.easeInOutCubicEmphasized);

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
    );
  }
}
