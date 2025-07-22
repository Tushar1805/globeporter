import 'package:core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/chats/view/chat_list_screen.dart';
import 'package:globeporter/presentation/driver/cubit/driver_cubit.dart';
import 'package:globeporter/presentation/driver/view/Home_screen.dart';
import 'package:globeporter/presentation/driver/view/my_trips_screen.dart';
import 'package:globeporter/presentation/settings/view/settings_screen.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_keys.dart';
import 'package:globeporter/resources/app_storage.dart';
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
  final authCubit = sl<AuthCubit>();
  final storage = sl<SecureStorage>();
  String amount = '500';

  final screens = [
    MyTripsScreen(),
    DriverHomeScreen(),
    ChatListScreen(
      role: 'driver',
    ),
    SettingsScreen(
      role: 'driver',
    ),
  ];

  void getUserDetails() async {
    final lang = await storage.readValue(languageCodeKey);
    await authCubit.getUserDetails(lang: lang ?? 'en');
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
    pageController = PageController(initialPage: pageIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onNavBarTap(int targetIndex) {
    if (targetIndex == pageIndex) return;

    // final duration = const Duration(milliseconds: 300);
    // final curve = Curves.easeInOut;

    setState(() {
      pageIndex = targetIndex;
    });

    // pageController.animateToPage(
    //   targetIndex,
    //   duration: duration,
    //   curve: curve,
    // );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: whiteColor,
        body: screens[pageIndex],
        // PageView(
        //   physics: NeverScrollableScrollPhysics(),
        //   controller: pageController,
        //   children: screens,
        //   onPageChanged: (index) {
        //     setState(() {
        //       pageIndex = index;
        //     });
        //   },
        // ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(bottom: 5),
          height: size.width * 0.18,
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
                title: AppLocalizations.of(context)!.myTripsString,
                icon: myRequestIcon,
                onTap: () => onNavBarTap(0),
                pageIndex: pageIndex,
                itemIndex: 0,
              ),
              BottomNavBarIcon(
                title: AppLocalizations.of(context)!.homeString,
                icon: homeIcon,
                onTap: () => onNavBarTap(1),
                pageIndex: pageIndex,
                itemIndex: 1,
              ),
              BottomNavBarIcon(
                title: AppLocalizations.of(context)!.chatsString,
                icon: chatIcon,
                onTap: () => onNavBarTap(2),
                pageIndex: pageIndex,
                itemIndex: 2,
              ),
              BottomNavBarIcon(
                title: AppLocalizations.of(context)!.profileString,
                icon: profileIcon,
                onTap: () => onNavBarTap(3),
                pageIndex: pageIndex,
                itemIndex: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
