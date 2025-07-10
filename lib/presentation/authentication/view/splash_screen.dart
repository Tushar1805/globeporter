// ignore_for_file: use_build_context_synchronously

import 'package:core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:globeporter/location/cubit/location_cubit.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final locationCubit = sl<LocationCubit>();
  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    context.pushReplacementNamed(setLanguageScreen);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: primaryColor,
        child: Center(
          child: SizedBox(
            width: size.width * 0.6,
            child: SvgPicture.asset(
              'assets/svg/logo_large.svg',
              height: size.width * 0.6,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
