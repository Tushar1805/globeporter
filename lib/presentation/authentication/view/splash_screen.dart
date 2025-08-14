// ignore_for_file: use_build_context_synchronously

import 'dart:async'; // ⬅️ for Timer
import 'package:core/di/service_locator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/location/cubit/location_cubit.dart';
import 'package:globeporter/notifications/notification_service.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_keys.dart';
import 'package:globeporter/resources/app_storage.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// ⬇️ Observe lifecycle to know when user returns from Settings
class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver {
  final locationCubit = sl<LocationCubit>();
  final storage = sl<SecureStorage>();
  final authCubit = sl<AuthCubit>();
  final NotificationServices notificationServices = NotificationServices();

  bool _permissionDialogOpen = false;
  bool waitingFromSettings = false;
  Timer? _permPoll; // optional polling while dialog open

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // ⬅️ start observing lifecycle
    init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _permPoll?.cancel();
    super.dispose();
  }

  // ⬇️ When app returns from Settings, re-check and close dialog if granted
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && _permissionDialogOpen) {
      await _verifyAndClosePermissionDialogIfGranted();
    }
  }

  Future<bool> _hasBackgroundLocation() async {
    // On Android/iOS this maps to ACCESS_BACKGROUND_LOCATION / Always
    return await Permission.locationAlways.isGranted;
  }

  Future<void> _verifyAndClosePermissionDialogIfGranted() async {
    final granted = await _hasBackgroundLocation();
    if (!mounted) return;
    if (granted && _permissionDialogOpen) {
      _permPoll?.cancel();
      _permissionDialogOpen = false;
      // Use rootNavigator to ensure the AlertDialog route is popped
      await Navigator.of(context, rootNavigator: true).maybePop();
    }
  }

  Future<void> _requireBackgroundLocationOrBlock() async {
    if (await _hasBackgroundLocation()) return;

    _permissionDialogOpen = true;

    // ⬇️ Start a lightweight poll as a fallback (every 1s)
    _permPoll?.cancel();
    _permPoll = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (!_permissionDialogOpen) return;
      await _verifyAndClosePermissionDialogIfGranted();
    });

    await showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true, // ⬅️ important when popping later
      builder: (dialogCtx) {
        return PopScope(
          onPopInvokedWithResult: (didPop, result) async => false, // block back button
          child: AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.backgroundLocationRequiredString,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
            ),
            content: Text(
              AppLocalizations.of(context)!.backgroundLocationDescriptionString,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  waitingFromSettings = true;
                  // Launch Settings (returns immediately)
                  await openAppSettings();
                  // Do NOT immediately check here — wait for lifecycle resume
                  // Poller & didChangeAppLifecycleState will handle dismissal.
                },
                child: Text(
                  AppLocalizations.of(context)!.openSettingString,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 18, color: primaryColor),
                ),
              ),
            ],
          ),
        );
      },
    );

    // dialog closed (either granted or programmatically)
    _permPoll?.cancel();
    _permissionDialogOpen = false;
  }

  Future<void> init() async {
    final accessToken = await storage.readValue(accessTokenKey);
    final detailsFilled = await storage.readValue(detailsFilledKey);
    final isDetailsVerified = await storage.readValue(isDetailsVerifiedKey);
    final ownerDetailsFilled = await storage.readValue(ownerDetailsFilledKey);
    final vehiclDetailsFilled = await storage.readValue(vehicleDetailsFilledKey);
    final driverDetailsFilled = await storage.readValue(driverDetailsFilledKey);

    await locationCubit.determinePosition();

    FirebaseMessaging.instance.getToken();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);

    // ⬇️ Block until background permission is granted
    await _requireBackgroundLocationOrBlock();

    // If still not granted (user backed out), you can choose to return/loop:
    if (!await _hasBackgroundLocation()) {
      // Keep user on splash or show a dedicated screen if you prefer.
      return;
    }

    // 🔹 Continue your navigation logic
    if (accessToken != null) {
      await authCubit.getUserDetails(force: true).then((final response) async {
        if (response?.data?.status == 0) {
          await authCubit.logout();
          context.go(loginScreen, extra: {
            'status': response?.data?.status,
          });
        } else if (response?.data?.userType != null && response?.data?.userType == 2) {
          if (isDetailsVerified == '1') {
            context.go(driverDashboard);
          } else if (detailsFilled == '1') {
            context.go(documentVerificationScreen);
          } else {
            if (ownerDetailsFilled == '1' &&
                vehiclDetailsFilled == '1' &&
                driverDetailsFilled == '1') {
              context.go(documentVerificationScreen);
            } else if (ownerDetailsFilled == '1' && vehiclDetailsFilled == '1') {
              context.go(ownerDetailsScreen, extra: {'currentIndex': 2});
            } else if (ownerDetailsFilled == '1') {
              context.go(ownerDetailsScreen, extra: {'currentIndex': 1});
            } else {
              context.go(ownerDetailsScreen);
            }
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
