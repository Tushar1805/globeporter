import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_constants.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class GreenDiagonalShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // 1. start (top left)
    path.moveTo(0, 0);
    // 2. Left top to bottom
    path.lineTo(0, size.height - 50);
    // 4. left to right
    path.quadraticBezierTo(
      size.width * 0.6, // 3 - 50 % width
      size.height - 150, // 3 - depth inwards from 50%
      size.width, // 4
      size.height, // 4
    );

    //5. right bottom to top
    path.lineTo(size.width, 0);

    // creating straight line from right to left
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class OnboardingScreen4 extends StatefulWidget {
  const OnboardingScreen4({super.key});

  @override
  State<OnboardingScreen4> createState() => _OnboardingScreen4State();
}

class _OnboardingScreen4State extends State<OnboardingScreen4> {
  void onNext() {
    // context.pushNamed(name)
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
                  ClipPath(
                    clipper: GreenDiagonalShapeClipper(),
                    child: Container(
                      height: size.height * 0.385, // Adjust height based on your design
                      color: primaryColor,
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
                  ),
                  // Container(
                  //   height: size.height * 0.385,
                  //   width: double.infinity,
                  //   decoration: const BoxDecoration(
                  //     color: Colors.green,
                  //     borderRadius: BorderRadius.only(
                  //       bottomLeft: Radius.elliptical(100, 200),
                  //       bottomRight: Radius.elliptical(100, 200),
                  //     ),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       Center(
                  //         child: Padding(
                  //           padding: EdgeInsets.only(top: size.height * 0.149),
                  //           child: SvgPicture.asset('assets/svg/logo_small.svg',
                  //               width: MediaQuery.sizeOf(context).width * .4),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
                                    top: 100,
                                    left: 50,
                                    child: SvgPicture.asset(
                                      onboardingData[3]['image']!,
                                      height: 200,
                                    )),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  onboardingData[3]['title']!,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: primaryColor),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  onboardingData[3]['subtitle']!,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: onSkip,
                            child: const Text('Skip'),
                          ),
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
