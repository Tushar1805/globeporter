import 'package:core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/driver/cubit/driver_cubit.dart';
import 'package:globeporter/presentation/driver/states/driver_states.dart';
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.35),
        child: Stack(
          children: [
            Container(
              height: size.width * 0.35,
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
              top: size.width * 0.123,
              right: 15,
              child: Center(
                child: SvgPicture.asset(
                  appLogoSmall,
                  width: MediaQuery.sizeOf(context).width * .25,
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.05,
              left: size.width * 0.05,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: size.width * 0.1,
                    child: CircleAvatar(
                      radius: size.width * 0.097,
                      backgroundImage: AssetImage(
                        profileImage,
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 15),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.onboarding1Title,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.end,
                        ),
                        Text(
                          'Vinod Kumar',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 15,
              bottom: size.width * 0.08,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                alignment: Alignment.bottomRight,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      coinImage,
                      width: size.width * 0.047,
                      height: size.width * 0.047,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    BlocConsumer(
                      bloc: driverCubit,
                      listener: (final context, final state) {
                        if (state is AmountDeductedState) {
                          setState(() {
                            amount = state.message ;
                          });
                        }
                      },
                      builder: (final context, final state) {
                        return Text(
                          '$amount rs',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontSize: 20, color: primaryColor),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
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
              icon: requestIcon,
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
