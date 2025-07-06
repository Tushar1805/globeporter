import 'package:core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:globeporter/presentation/driver/cubit/driver_cubit.dart';
import 'package:globeporter/presentation/driver/view/Home_screen.dart';
import 'package:globeporter/presentation/driver/view/driver_profile_screen.dart';
import 'package:globeporter/presentation/driver/view/my_trips_screen.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  int pageIndex = 1;
  late PageController pageController;
  final driverCubit = sl<DriverCubit>();
  String amount = '500';

  final screens = [
    MyTripsScreen(),
    DriverHomeScreen(),
    DriverProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: pageIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onNavBarTap(int targetIndex) {
    if (targetIndex == pageIndex) return;

    final duration = const Duration(milliseconds: 300);
    final curve = Curves.easeInOut;

    setState(() {
      pageIndex = targetIndex;
    });

    pageController.animateToPage(
      targetIndex,
      duration: duration,
      curve: curve,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      body: PageView(
        controller: pageController,
        children: screens,
        onPageChanged: (index) {
          setState(() {
            pageIndex = index;
          });
        },
      ),
      bottomNavigationBar: Container(
        height: size.width * 0.12,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          border: Border.all(
            color: const Color(
              0xFFCDCDCD,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomNavBarIcon(
              icon: myRequestIcon,
              onTap: () => onNavBarTap(0),
              pageIndex: pageIndex,
              itemIndex: 0,
            ),
            BottomNavBarIcon(
              icon: homeIcon,
              onTap: () => onNavBarTap(1),
              pageIndex: pageIndex,
              itemIndex: 1,
            ),
            BottomNavBarIcon(
              icon: profileIcon,
              onTap: () => onNavBarTap(2),
              pageIndex: pageIndex,
              itemIndex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
