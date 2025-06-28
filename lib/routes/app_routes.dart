import 'package:flutter/material.dart';
import 'package:mobile/presentation/features/authentication/login_screen.dart';
import 'package:mobile/presentation/features/authentication/onboarding_screen.dart';
import 'package:mobile/presentation/features/authentication/select_lang_screen.dart';
import '../presentation/features/authentication/splash_screen.dart';
import 'error_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    try {
      // Map<String, dynamic> args = {};
      // try {
      //   args = routeSettings.arguments != null ? routeSettings.arguments as Map<String, dynamic> : {};
      // } on Exception catch (e) {
      //   debugPrint('Arguments Error: ${e.toString()}');
      // }

      switch (routeSettings.name) {
        case SplashScreen.route:
          return ResponsivePageRoute(settings: routeSettings, builder: (_) => const SplashScreen());

        case SelectLangScreen.route:
          return ResponsivePageRoute(settings: routeSettings, builder: (_) => const SelectLangScreen());

        case OnboardingScreen.route:
          return ResponsivePageRoute(settings: routeSettings, builder: (_) => const OnboardingScreen());

        case LoginScreen.route:
          return ResponsivePageRoute(settings: routeSettings, builder: (_) => const LoginScreen());

        default:
          return errorRoute(routeSettings);
      }
    } catch (e) {
      debugPrint('Route Error: ${e.toString()}');
      return errorRoute(routeSettings);
    }
  }

  static Route<dynamic> errorRoute(RouteSettings routeSettings) {
    return ResponsivePageRoute(settings: routeSettings, builder: (_) => const ErrorScreen());
  }
}

class ResponsivePageRoute extends PageRouteBuilder {
  ResponsivePageRoute({super.settings, required WidgetBuilder builder, super.transitionDuration = const Duration(milliseconds: 500)})
    : super(
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => builder(context),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
        reverseTransitionDuration: transitionDuration,
      );
}
