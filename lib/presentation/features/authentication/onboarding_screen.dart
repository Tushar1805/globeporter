import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/presentation/features/authentication/login_screen.dart';

import '../../../core/theme/colors.dart';

class OnboardingScreen extends StatefulWidget {
  static const String route = '/onboarding';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {'image': 'assets/svg/shipped.svg', 'title': 'Welcome!', 'subtitle': 'Your trusted delivery & logistics partner'},
    {
      'image': 'assets/svg/parcel_arived.svg',
      'title': 'Local Deliveries Made Easy',
      'subtitle': 'Book mini trucks, bikes, or autos\nin minutes for all your delivery needs.',
    },
    {
      'image': 'assets/svg/parcel_waiting.svg',
      'title': 'Real-Time Tracking',
      'subtitle': 'Stay updated with live tracking,\nestimated arrival time, and driver details.',
    },
    {
      'image': 'assets/svg/parcel_arived.svg',
      'title': 'Trusted by Millions',
      'subtitle': 'From single items to house shifting,\nPorter is built to serve you better.',
    },
  ];

  void onNext() {
    if (_currentIndex >= onboardingData.length - 1) {
      Navigator.pushReplacementNamed(context, LoginScreen.route);
    } else {
      setState(() => _currentIndex++);
    }
  }

  void onSkip() {
    Navigator.pushReplacementNamed(context, LoginScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Green curved header

          // Onboarding Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Stack(
                children: [
                  Container(
                    height: 300 + statusBarHeight,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100), bottomRight: Radius.circular(100)),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: statusBarHeight + 80),
                            child: SvgPicture.asset('assets/svg/logo_small.svg', width: MediaQuery.sizeOf(context).width * .4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: 180 + statusBarHeight),
                      Expanded(
                        child: IndexedStack(
                          index: _currentIndex,
                          children: onboardingData.map((page) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width * 1,
                                      height: MediaQuery.sizeOf(context).width * .7,
                                      child: SvgPicture.asset('assets/svg/ellipse_shape.svg', fit: BoxFit.contain),
                                    ),
                                    Positioned(top: 100, left: 50, child: SvgPicture.asset(page['image']!, height: 200)),
                                  ],
                                ),
                                const SizedBox(height: 40),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      page['title']!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: CustomColors.primaryColor),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      page['subtitle']!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: CustomColors.blackColor),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Bottom Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _currentIndex == 0 ? const SizedBox(width: 60) : TextButton(onPressed: onSkip, child: const Text('Skip')),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(14),
                            ),
                            onPressed: onNext,
                            child: const Icon(Icons.arrow_forward, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
