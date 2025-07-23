// ignore_for_file: use_build_context_synchronously

import 'package:core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:globeporter/location/cubit/location_cubit.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_keys.dart';
import 'package:globeporter/resources/app_storage.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final locationCubit = sl<LocationCubit>();
  final storage = sl<SecureStorage>();
  final authCubit = sl<AuthCubit>();
  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    final accessToken = await storage.readValue(accessTokenKey);
    final langCode = await storage.readValue(languageCodeKey);
    final detailsFilled = await storage.readValue(detailsFilledKey);
    await Future.delayed(const Duration(seconds: 2), () {
      locationCubit.determinePosition();
    });

    if (accessToken != null) {
      await authCubit.getUserDetails(lang: langCode ?? 'en').then((final response) {
        if (response?.data?.userType != null && response?.data?.userType == 2) {
          if (detailsFilled == '1') {
            context.go(driverDashboard);
          } else {
            context.go(ownerDetailsScreen);
          }
        } else if (response?.data?.userType != null && response?.data?.userType == 1) {
          context.go(customerDashboard);
        } else {
          context.go(loginScreen);
        }
      });
    } else {
      context.pushReplacementNamed(setLanguageScreen);
    }
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
