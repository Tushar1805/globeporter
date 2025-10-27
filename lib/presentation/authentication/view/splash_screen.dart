// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
  const SplashScreen({super.key, this.data});
  final RemoteMessage? data;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver {
  final locationCubit = sl<LocationCubit>();
  final storage = sl<SecureStorage>();
  final authCubit = sl<AuthCubit>();
  final NotificationServices notificationServices = NotificationServices();

  bool _permissionDialogOpen = false;
  Timer? _permPoll;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Delay heavy init until after first frame (safer for release)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _safeInit();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _permPoll?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && _permissionDialogOpen) {
      await _verifyAndClosePermissionDialogIfGranted();
    }
  }

  Future<void> _safeInit() async {
    try {
      await Future.microtask(() => init());
    } catch (e, st) {
      // Catch any release-only silent crashes
      await FirebaseCrashlytics.instance.recordError(e, st, reason: 'Splash init failed');
      if (mounted) {
        // fallback to login
        context.go(loginScreen);
      }
    }
  }

  Future<bool> _hasBackgroundLocation() async {
    return await Permission.locationAlways.isGranted;
  }

  Future<void> _verifyAndClosePermissionDialogIfGranted() async {
    final granted = await _hasBackgroundLocation();
    if (!mounted) return;
    if (granted && _permissionDialogOpen) {
      _permPoll?.cancel();
      _permissionDialogOpen = false;
      await Navigator.of(context, rootNavigator: true).maybePop();
    }
  }

  Future<void> _requireBackgroundLocationOrBlock() async {
    if (await _hasBackgroundLocation()) return;

    _permissionDialogOpen = true;

    _permPoll?.cancel();
    _permPoll = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (!_permissionDialogOpen) return;
      await _verifyAndClosePermissionDialogIfGranted();
    });

    await showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (dialogCtx) {
        return PopScope(
          onPopInvokedWithResult: (didPop, result) async => false,
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
                  await openAppSettings();
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

    try {
      await locationCubit.determinePosition();
    } catch (e, st) {
      await FirebaseCrashlytics.instance.recordError(e, st, reason: 'Location error in Splash');
    }

    try {
      await FirebaseMessaging.instance.getToken();
      await notificationServices.requestNotificationPermission();
      await notificationServices.firebaseInit(context);
    } catch (e, st) {
      await FirebaseCrashlytics.instance.recordError(e, st, reason: 'Notification init failed');
    }

    // Require location permission
    await _requireBackgroundLocationOrBlock();

    if (!await _hasBackgroundLocation()) {
      // Still denied — just show fallback
      await FirebaseCrashlytics.instance.log('Location permission denied');
      return;
    }

    if (!mounted) return;

    // Continue navigation flow
    if (widget.data != null) {
      customPrint('TESTING Background notifications');
      notificationServices.handleBackgroundMessage(widget.data!.data);
      return;
    }

    if (accessToken != null) {
      final response = await authCubit.getUserDetails(force: true);
      if (!mounted) return;

      if (response?.data?.status == 0) {
        await authCubit.logout();
        context.go(loginScreen, extra: {
          'status': response?.data?.status,
        });
      } else if (response?.data?.userType == 2) {
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
      } else if (response?.data?.userType == 1) {
        context.go(customerDashboard);
      } else {
        context.go(loginScreen);
      }
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
