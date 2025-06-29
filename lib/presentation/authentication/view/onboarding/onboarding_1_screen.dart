import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_constants.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen1 extends StatefulWidget {
  const OnboardingScreen1({super.key});

  @override
  State<OnboardingScreen1> createState() => _OnboardingScreen1State();
}

class _OnboardingScreen1State extends State<OnboardingScreen1> {
  void onNext() {
    context.pushNamed(onboardingScreen2);
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
                      color: primaryColor,
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
                        child: Column(
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
                                  top: size.height * 0.088,
                                  left: size.width * 0.097,
                                  child: SvgPicture.asset(
                                    onboardingData[0]['image']!,
                                    height: size.height * 0.18,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  onboardingData[0]['title']!,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: primaryColor),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  onboardingData[0]['subtitle']!,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Bottom Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
