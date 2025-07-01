import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:globeporter/l10n/app_localizations.dart';

import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_constants.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class GreenDiagonalShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // 1. start (top left)
    path.moveTo(0, 0);
    // 2. Left top to bottom
    path.lineTo(0, size.height - 10);
    // 4. left to right
    path.quadraticBezierTo(
      size.width * 0.5, // 3 - 50 % width
      size.height - size.height * 0.347, // 3 - depth inwards from 50%
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
    context.pushReplacementNamed(loginScreen);
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
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Large enough for pill shape
              ),
              padding: const EdgeInsets.all(14),
            ),
            onPressed: onNext,
            child: Image.asset(
              arrowForward,
              width: size.width * 0.136,
              height: size.height * 0.017,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Stack(
                children: [
                  ClipPath(
                    clipper: GreenDiagonalShapeClipper(),
                    child: Container(
                      height: size.width * .9,
                      width: size.width,
                      color: primaryColor,
                      child: Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: size.width * 0.3),
                              child: SvgPicture.asset(
                                appLogoSmall,
                                width: MediaQuery.sizeOf(context).width * .4,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * 1,
                                  height: MediaQuery.sizeOf(context).width * .75,
                                  child: SvgPicture.asset(
                                    ellipseShapeSvg,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Positioned(
                                  top: -45,
                                  left: 0,
                                  child: SizedBox(
                                    width: size.width,
                                    child: Center(
                                      child: Image.asset(
                                        onboardingData[3]['image']!,
                                        width: size.width * 0.9,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.onboarding4Title,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: primaryColor, fontSize: 28),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  AppLocalizations.of(context)!.onboarding4Desc,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: TextButton(
              onPressed: onSkip,
              child: Text(
                AppLocalizations.of(context)!.skipString,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 22),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.03),
        ],
      ),
    );
  }
}
