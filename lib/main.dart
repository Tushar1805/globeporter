// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:core/localization/language_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:core/utils/core_utils.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:globeporter/firebase_options.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/location/background_location_service.dart';
import 'package:globeporter/notifications/notification_service.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_strings.dart';
import 'package:core/di/service_locator.dart';
import 'package:core/theme/theme_cubit.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'routes/app_router.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

final NotificationServices notificationServices = NotificationServices();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(
  final RemoteMessage message,
) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    setupServiceLocator();

    await FirebaseMessaging.instance.getInitialMessage().then((final RemoteMessage? message) {
      customPrint("********************* From Background: ${message?.data}");
      if (message?.data != null) {
        WidgetsBinding.instance.addPostFrameCallback((final _) {
          router.go(splashScreen, extra: {'route': message});
        });
      }
    });

    await ensurePermissions();
    // Initialize Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // ⚡ Run your app inside the same zone
    runApp(
      DevicePreview(
        enabled: false,
        tools: const [
          ...DevicePreview.defaultTools,
        ],
        builder: (context) => const GlobePorter(),
      ),
    );

    // Optional: set system UI overlays here
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}

Future<void> ensurePermissions() async {
  if (await Permission.locationAlways.isDenied || await Permission.locationAlways.isRestricted) {
    // First ask WhenInUse, then Always
    await Permission.locationWhenInUse.request();
    await Permission.locationAlways.request();
  }

  // Android 13+ notifications permission or your FG service notif may not show
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

class GlobePorter extends StatefulWidget {
  const GlobePorter({super.key});

  @override
  State<GlobePorter> createState() => _GlobePorterState();
}

class _GlobePorterState extends State<GlobePorter> {
  late final ThemeCubit themeCubit;
  late final LanguageCubit languageCubit;
  final NotificationServices _notificationService = NotificationServices();
  final FlutterLocalNotificationsPlugin _mainFlutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    themeCubit = sl<ThemeCubit>();
    languageCubit = sl<LanguageCubit>();
    languageCubit.getLanguage();
    _configureNotifications();
    _initBackgroundService();
    super.initState();
  }

  Future<void> _initBackgroundService() async {
    try {
      await initializeBackgroundService();
      await FlutterBackgroundService().startService();
      customPrint("✅ Background service started successfully");
    } catch (e, st) {
      customPrint("❌ Failed to start background service: $e");
      FirebaseCrashlytics.instance.recordError(e, st);
    }
  }

  Future<void> _configureNotifications() async {
    // 1. Ask for permissions
    _notificationService.requestNotificationPermission();

    // 2. Initialize flutter_local_notifications in the MAIN isolate so taps are handled reliably
    const androidInit = AndroidInitializationSettings('mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    final initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _mainFlutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // When user taps a *local* notification shown by the plugin,
        // the payload is the JSON we set when showing the notification.
        if (response.payload != null && response.payload!.isNotEmpty) {
          try {
            final Map<String, dynamic> data =
                Map<String, dynamic>.from(jsonDecode(response.payload!));
            _notificationService.handleMessageFromData(data);
          } catch (e) {
            customPrint('Failed to parse notification payload: $e');
          }
        }
      },
      // Provide the same background tap handler you have in the service (top-level).
      onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
    );

    // 3. Create an Android channel up-front so any background isolate notification uses it
    const channel = AndroidNotificationChannel(
      'default_channel', // id
      'Default Channel', // name
      importance: Importance.max,
    );
    await _mainFlutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 4. Handle the case where the app was launched by tapping a notification (terminated -> open)
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      // forward to your existing handler (keeps your original routing logic)
      _notificationService.handleMessage(initialMessage);
    }

    // 5. Let your NotificationServices register its listeners which require a BuildContext
    //    (your firebaseInit registers onMessage, onBackgroundMessage, etc.)
    _notificationService.firebaseInit(context);

    // 6. Also handle app-open-from-background taps globally (cover Android + iOS)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _notificationService.handleMessage(message);
    });

    // 7. For iOS foreground presentation
    if (Platform.isIOS) {
      await _notificationService.foregroundMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => sl<ThemeCubit>(),
        ),
        BlocProvider<LanguageCubit>(
          create: (_) => sl<LanguageCubit>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(440, 956),
        child: BlocBuilder<ThemeCubit, ThemeData>(
          bloc: themeCubit,
          builder: (final context, final themeState) {
            return BlocBuilder<LanguageCubit, Locale>(
              bloc: languageCubit,
              builder: (final context, final localeState) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: appNameString,
                  locale: localeState,
                  localizationsDelegates: [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: [Locale('en'), Locale('hi'), Locale('mr')],
                  theme: themeState,
                  themeMode: ThemeMode.light,
                  routerConfig: router,
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(.8)),
                      child: child!,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
