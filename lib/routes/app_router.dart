import 'package:flutter/material.dart';
import 'package:globeporter/presentation/authentication/view/driver_details_screen.dart';
import 'package:globeporter/presentation/authentication/view/login_screen.dart';
import 'package:globeporter/presentation/authentication/view/onboarding/onboarding_1_screen.dart';
import 'package:globeporter/presentation/authentication/view/onboarding/onboarding_2_screen.dart';
import 'package:globeporter/presentation/authentication/view/onboarding/onboarding_3_screen.dart';
import 'package:globeporter/presentation/authentication/view/onboarding/onboarding_4_screen.dart';
import 'package:globeporter/presentation/authentication/view/otp_screen.dart';
import 'package:globeporter/presentation/authentication/view/select_lang_screen.dart';
import 'package:globeporter/presentation/authentication/view/sign_up_screen.dart';
import 'package:globeporter/presentation/customer/view/create_request_screen.dart';
import 'package:globeporter/presentation/customer/view/my_request_details_screen.dart';
import 'package:globeporter/presentation/customer/view/my_request_screen.dart';
import 'package:globeporter/presentation/customer/view/rural_request_screen.dart';
import 'package:globeporter/presentation/customer/view/urban_request_screen.dart';
import 'package:globeporter/routes/app_routes.dart';
import '../presentation/authentication/view/splash_screen.dart';
import 'error_screen.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage<T> slideTransitionPage<T>({
  required Widget child,
  required LocalKey key,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeInOut)).animate(animation);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

final GoRouter router = GoRouter(
  initialLocation: splashScreen,
  errorBuilder: (context, state) => const ErrorScreen(),
  routes: [
    GoRoute(
      name: splashScreen,
      path: splashScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const SplashScreen(),
      ),
    ),
    GoRoute(
      name: setLanguageScreen,
      path: setLanguageScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const SelectLangScreen(),
      ),
    ),
    GoRoute(
      name: onboardingScreen1,
      path: onboardingScreen1,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const OnboardingScreen1(),
      ),
    ),
    GoRoute(
      name: onboardingScreen2,
      path: onboardingScreen2,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const OnboardingScreen2(),
      ),
    ),
    GoRoute(
      name: onboardingScreen3,
      path: onboardingScreen3,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const OnboardingScreen3(),
      ),
    ),
    GoRoute(
      name: onboardingScreen4,
      path: onboardingScreen4,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const OnboardingScreen4(),
      ),
    ),
    GoRoute(
      name: loginScreen,
      path: loginScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      name: signUpScreen,
      path: signUpScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const SignUpScreen(),
      ),
    ),
    GoRoute(
      name: otpScreen,
      path: otpScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const OtpScreen(),
      ),
    ),
    GoRoute(
      name: driverDetailsScreen,
      path: driverDetailsScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const DriverDetailsScreen(),
      ),
    ),
    GoRoute(
      name: createRequestScreen,
      path: createRequestScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const CreateRequestScreen(),
      ),
    ),
    GoRoute(
      name: urbanRequestScreen,
      path: urbanRequestScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const UrbanRequestScreen(),
      ),
    ),
    GoRoute(
      name: ruralRequestScreen,
      path: ruralRequestScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const RuralRequestScreen(),
      ),
    ),
    GoRoute(
      name: myRequestScreen,
      path: myRequestScreen,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        return slideTransitionPage(
          key: state.pageKey,
          child: MyRequestScreen(
            type: params?['type'] as String?,
          ),
        );
      },
    ),
    GoRoute(
      name: myRequestDetailsScreen,
      path: myRequestDetailsScreen,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        return slideTransitionPage(
          key: state.pageKey,
          child: MyRequestDetailsScreen(
            type: params?['type'] as String?,
          ),
        );
      },
    ),
  ],
);
