import 'package:core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:globeporter/presentation/customer/cubit/customer_cubit.dart';
import 'package:globeporter/presentation/customer/view/create_request_screen.dart';
import 'package:globeporter/presentation/customer/view/my_request_screen.dart';
import 'package:globeporter/presentation/settings/view/settings_screen.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({
    super.key,
    required this.type,
  });
  final String? type;

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  int pageIndex = 1;
  late PageController pageController;
  final customerCubit = sl<CustomerCubit>();

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
    final screens = [
      MyRequestScreen(
        type: widget.type,
        onCreateRequestTap: () => onNavBarTap(1),
        show: customerCubit.show,
      ),
      CreateRequestScreen(
        onSubmitTap: () => onNavBarTap(0),
      ),
      SettingsScreen(
        role: 'customer',
      ),
    ];
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
