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
import 'package:globeporter/presentation/customer/view/customer_dashboard.dart';
import 'package:globeporter/presentation/customer/view/customer_profile_screen.dart';
import 'package:globeporter/presentation/customer/view/my_request_details_screen.dart';
import 'package:globeporter/presentation/customer/view/my_request_screen.dart';
import 'package:globeporter/presentation/customer/view/rural_request_screen.dart';
import 'package:globeporter/presentation/customer/view/urban_request_screen.dart';
import 'package:globeporter/presentation/driver/view/driver_dashboard.dart';
import 'package:globeporter/presentation/driver/view/driver_profile_screen.dart';
import 'package:globeporter/presentation/driver/view/item_details_screen.dart';
import 'package:globeporter/presentation/driver/view/start_trip_screen.dart';
import 'package:globeporter/presentation/driver/view/trip_info_screen.dart';
import 'package:globeporter/presentation/driver/view/wallet_screen.dart';
import 'package:globeporter/presentation/notification/view/notification_screen.dart';
import 'package:globeporter/presentation/settings/view/refer_screen.dart';
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
       pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        return slideTransitionPage(
          key: state.pageKey,
          child: SelectLangScreen(
            onPop: params?['onPop'] as bool?,
          ),
        );
      },
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
      name: customerDashboard,
      path: customerDashboard,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        return slideTransitionPage(
          key: state.pageKey,
          child: CustomerDashboard(
            type: params?['type'] as String?,
          ),
        );
      },
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
    GoRoute(
      name: driverDashboard,
      path: driverDashboard,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const DriverDashboard(),
      ),
    ),
    GoRoute(
      name: itemDetailsScreen,
      path: itemDetailsScreen,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        return slideTransitionPage(
          key: state.pageKey,
          child: ItemDetailsScreen(
            type: params?['type'] as String?,
          ),
        );
      },
    ),
    GoRoute(
      name: tripInfoScreen,
      path: tripInfoScreen,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        return slideTransitionPage(
          key: state.pageKey,
          child: TripInfoScreen(
            type: params?['type'] as String?,
          ),
        );
      },
    ),
    GoRoute(
      name: startTripScreen,
      path: startTripScreen,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        return slideTransitionPage(
          key: state.pageKey,
          child: StartTripScreen(
            type: params?['type'] as String?,
          ),
        );
      },
    ),
    GoRoute(
      name: walletScreen,
      path: walletScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const WalletScreen(),
      ),
    ),
    GoRoute(
      name: notificationScreen,
      path: notificationScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const NotificationScreen(),
      ),
    ),
    GoRoute(
      name: customerProfileScreen,
      path: customerProfileScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const CustomerProfileScreen(),
      ),
    ),
    GoRoute(
      name: driverProfileScreen,
      path: driverProfileScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const DriverProfileScreen(),
      ),
    ),
    GoRoute(
      name: referAndEarnScreen,
      path: referAndEarnScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const ReferAndEarnScreen(),
      ),
    ),
  ],
);
