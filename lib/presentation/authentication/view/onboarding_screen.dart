import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/svg/shipped.svg',
      'title': 'Welcome!',
      'subtitle': 'Your trusted delivery & logistics partner',
    },
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
      context.pushReplacementNamed(loginScreen);
    } else {
      setState(() => _currentIndex++);
    }
  }

  void onSkip() {
    context.pushReplacementNamed(loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                    height: size.height * 0.385,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(125),
                        bottomRight: Radius.circular(125),
                      ),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: size.height * 0.149),
                            child: SvgPicture.asset('assets/svg/logo_small.svg',
                                width: MediaQuery.sizeOf(context).width * .4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: size.height * 0.246),
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
                                      child: SvgPicture.asset(
                                        'assets/svg/ellipse_shape.svg',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Positioned(
                                        top: 100,
                                        left: 50,
                                        child: SvgPicture.asset(
                                          page['image']!,
                                          height: page['title'] == 'Real-Time Tracking' ? 300 : 200,
                                        )),
                                  ],
                                ),
                                const SizedBox(height: 40),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      page['title']!,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(color: primaryColor),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      page['subtitle']!,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.bodyMedium,
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
                          _currentIndex == 0
                              ? const SizedBox(width: 60)
                              : TextButton(onPressed: onSkip, child: const Text('Skip')),
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
