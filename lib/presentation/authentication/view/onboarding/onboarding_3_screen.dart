import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_constants.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen3 extends StatefulWidget {
  const OnboardingScreen3({super.key});

  @override
  State<OnboardingScreen3> createState() => _OnboardingScreen3State();
}

class _OnboardingScreen3State extends State<OnboardingScreen3> {
  void onNext() {
    context.pushNamed(onboardingScreen4);
  }

  void onSkip() {
    context.pushReplacementNamed(loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Row(
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
                    height: size.width * .9,
                    width: size.width,
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(200),
                      ),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: size.width * 0.3),
                            child: SvgPicture.asset('assets/svg/logo_small.svg', width: MediaQuery.sizeOf(context).width * .4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: size.width * 0.5),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(bottom: 20),
                                  width: MediaQuery.sizeOf(context).width * 1,
                                  height: MediaQuery.sizeOf(context).width * .75,
                                  child: SvgPicture.asset(
                                    'assets/svg/ellipse_shape.svg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  bottom: -10,
                                  child: SizedBox(
                                    width: size.width,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        onboardingData[2]['image']!,
                                        fit: BoxFit.contain,
                                        height: size.width * 0.7,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            SizedBox(
                              width: size.width - 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    onboardingData[2]['title']!,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: primaryColor, fontSize: 28),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    onboardingData[2]['subtitle']!,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Bottom Controls

                        const SizedBox(height: 12),
                      ],
                    ),
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
