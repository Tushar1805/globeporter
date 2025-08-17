// ignore_for_file: use_build_context_synchronously, avoid_dynamic_calls, avoid_print
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:globeporter/presentation/customer/cubit/customer_cubit.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/routes/app_router.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:permission_handler/permission_handler.dart';

// Top-level background tap handler for flutter_local_notifications (runs in background isolate)
@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(
  final NotificationResponse notificationResponse,
) {
  final NotificationServices notificationService = NotificationServices();
  customPrint('******** background notification tapped (background isolate)');
  if (kDebugMode) {
    customPrint('background tap payload: ${notificationResponse.payload}');
  }
  // Keep minimal - navigation should be handled when app resumes (getInitialMessage / onMessageOpenedApp)
  if (notificationResponse.payload != null) {
    try {
      final decoded = jsonDecode(notificationResponse.payload!);
      if (decoded is Map<String, dynamic>) {
        notificationService.handleMessageFromData(Map<String, dynamic>.from(decoded));
      } else {
        customPrint('Notification payload is not a Map: $decoded');
      }
    } catch (e) {
      customPrint('Failed to decode notification payload: $e');
    }
    return;
  }
}

// Top-level Firebase background message handler (must be top-level and annotated)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized in this isolate
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // If already initialized, ignore
    if (kDebugMode) print('Firebase init in background handler: $e');
  }

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const androidInit = AndroidInitializationSettings('mipmap/ic_launcher');
  const iosInit = DarwinInitializationSettings();
  final initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
  );

  final channelId = message.notification?.android?.channelId?.toString() ?? 'default_channel';
  final channelName = channelId;

  final channel = AndroidNotificationChannel(
    channelId,
    channelName,
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  final androidNotificationDetails = AndroidNotificationDetails(
    channel.id,
    channel.name,
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.max,
    ticker: 'ticker',
    sound: channel.sound,
    number: message.notification?.android?.count ?? 0,
    icon: '@drawable/ic_icon',
    color: primaryColor,
  );

  const darwinNotificationDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  final notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: darwinNotificationDetails,
  );

  final title = message.notification?.title ?? message.data['title'] ?? '';
  final body = message.notification?.body ?? message.data['body'] ?? '';
  final payload = jsonEncode(message.data);

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    notificationDetails,
    payload: payload,
  );

  if (kDebugMode) {
    print('Background handler: displayed notification: $title / $body, data: ${message.data}');
  }
}

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static int notificationCount = 0;

  //* Function to initialise flutter local notification plugin to show notifications for android when app is active
  Future<void> initLocalNotifications(
    final BuildContext context,
    final RemoteMessage message,
  ) async {
    const androidInitializationSettings = AndroidInitializationSettings('mipmap/ic_launcher');
    const iosInitializationSettings = DarwinInitializationSettings();

    final initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (final NotificationResponse notificationResponse) {
        // App in foreground/background (non-terminated)
        if (kDebugMode) print('release on tap -> Foreground');

        // Prefer payload (set when we showed the local notification). If not present, fall back to the
        // RemoteMessage that was used to create this notification (the `message` param) as a last resort.
        if (notificationResponse.payload != null) {
          try {
            final decoded = jsonDecode(notificationResponse.payload!);
            if (decoded is Map<String, dynamic>) {
              handleMessageFromData(Map<String, dynamic>.from(decoded));
            } else {
              customPrint('Notification payload is not a Map: $decoded');
            }
          } catch (e) {
            customPrint('Failed to decode notification payload: $e');
          }
          return;
        }

        // FALLBACK: existing logic - call handleMessage with the RemoteMessage passed to initLocalNotifications
        try {
          handleMessage(message);
        } catch (e) {
          customPrint('Error handling notification tap fallback: $e');
        }
      },
      onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
    );
  }

  void requestNotificationPermission() async {
    //  await  AppSettings.openAppSettings(type: App
    final status = await Permission.notification.status;
    if ((Platform.isAndroid && status.isDenied) || (Platform.isIOS && status.isDenied)) {
      await Permission.notification.request();
    }

    final status2 = await Permission.manageExternalStorage.status;
    if ((Platform.isAndroid && status2.isDenied) || (Platform.isIOS && status2.isDenied)) {
      await Permission.manageExternalStorage.request();
    }

    final NotificationSettings settings = await messaging.requestPermission(
      announcement: true,
      criticalAlert: true,
      provisional: true,
      carPlay: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      customPrint('User given permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      customPrint('provisional access');
    } else {
      customPrint('Denied notification permission');
    }
  }

  void firebaseInit(final BuildContext context) async {
    // getInitialMessage will be handled below
    await FirebaseMessaging.instance.getInitialMessage();

    // Register the top-level background handler. It's important this is a top-level function.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((final RemoteMessage message) {
      final notification = message.notification;
      final android = message.notification!.android;
      notificationCount++;
      if (kDebugMode) {
        print('onMessage notifications title:${notification!.title}');
        print('onMessage notifications body:${notification.body}');
        print(
          'count:${android?.count == null ? notificationCount : android?.count ?? 0}',
        );
        print('data:${message.data}');
      }

      if (Platform.isIOS) {
        foregroundMessage();
        //initLocalNotifications(context, message);
        showIOSNotification(message);
      }

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(
          message,
          android?.count == null ? notificationCount : android?.count ?? 0,
        );
      }
    });
    if (Platform.isIOS) {
      FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    }
  }

  //* function to show visible notification when app is active
  Future<void> showNotification(
    final RemoteMessage message,
    final int? count,
  ) async {
    final channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
    );
    customPrint(channel.id);

    final androidNotificationDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.max,
      ticker: 'ticker',
      sound: channel.sound,
      number: count,
      icon: '@drawable/ic_icon',
      color: primaryColor,
    );

    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    final payload = jsonEncode(message.data);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
        payload: payload,
      );
    });
  }

  void showIOSNotification(final RemoteMessage message) {
    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    final notificationDetails = NotificationDetails(
      iOS: darwinNotificationDetails,
    );

    final payload = jsonEncode(message.data);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
        payload: payload,
      );
    });
  }

  Future<String?> getDeviceToken() async {
    final token = await messaging.getToken();
    customPrint('FCM TOKEN: $token');
    return token;
  }

  //* To check whether the existing token is expired or not
  Future<bool> isTokenRefresh() async {
    final completer = Completer<bool>();
    StreamSubscription<String>? sub;

    sub = messaging.onTokenRefresh.listen((_) {
      sub?.cancel();
      if (!completer.isCompleted) {
        completer.complete(true);
      }
    });

    // If no refresh within 10s, assume false
    return completer.future.timeout(const Duration(seconds: 10), onTimeout: () => false);
  }

  Future foregroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // Keep existing signature but delegate to _handleData so we can reuse logic
  void handleMessage(final RemoteMessage message) async {
    await _handleData(message.data);
  }

  // Called when we have payload/data (from local notification tap payload)
  Future<void> handleMessageFromData(final Map<String, dynamic> data) async {
    await _handleData(data);
  }

  // Centralized data handling logic
  Future<void> _handleData(final Map<String, dynamic> data) async {
    customPrint(data);
    try {
      final customerCubit = sl<CustomerCubit>();
      if (data['type'] == '0') {
        await router.pushNamed(driverRideNotificationScreen, extra: {
          'bookingId': data['booking_id'].toString(),
        });
      } else if (data['type'].toString() == '1') {
        if (data['user_type'].toString() == '1') {
          final response =
              await customerCubit.getBookingDetails(bookingId: data['booking_id'].toString());

          //* Route to customer -> request details
          await router.pushNamed(myRequestDetailsScreen, extra: {
            'type': response?.data?.rideType?.toLowerCase(),
            'bookingId': data['booking_id'].toString(),
          });
        }
      } else if (data['type'] == 'notify' && data['receiver_id'] != null) {
        //* when chat notification receives sender becomes receiver
        // TODO: Receiver Image logic not yet done
        await router.pushNamed(chatScreen, extra: {
          'senderId': data['receiver_id'],
          'receiverId': data['sender_id'],
          'senderName': data['receiverName'],
          'type': data['user_type'],
          'receiverName': data['senderName'],
          'receiverImageUrl': data['receiverImageUrl'],
        });
      } else if (data['type'] == "5" && data['user_type'].toString() == "1") {
        //* Status on the way -> Track driver
        final response =
            await customerCubit.getBookingDetails(bookingId: data['booking_id'].toString());
        await router.pushNamed(trackDriverScreen, extra: {
          'type': response?.data?.rideType?.toLowerCase(),
          'data': response?.data,
        });
      } else if (data['type'] == '6' && data['user_type'].toString() == "1") {
        //* Status Arrived at pickup
        final response =
            await customerCubit.getBookingDetails(bookingId: data['booking_id'].toString());

        //* Route to customer -> request details
        await router.pushNamed(myRequestDetailsScreen, extra: {
          'type': response?.data?.rideType?.toLowerCase(),
          'bookingId': data['booking_id'].toString(),
        });
      } else if (data['type'] == '7' && data['user_type'].toString() == "1") {
        //* Status Ride started
        final response =
            await customerCubit.getBookingDetails(bookingId: data['booking_id'].toString());

        //* Route to customer -> request details
        await router.pushNamed(myRequestDetailsScreen, extra: {
          'type': response?.data?.rideType?.toLowerCase(),
          'bookingId': data['booking_id'].toString(),
        });
      } else if (data['type'] == '8' && data['user_type'].toString() == "1") {
        //* Status Arrived at destination
        final response =
            await customerCubit.getBookingDetails(bookingId: data['booking_id'].toString());

        //* Route to customer -> request details
        await router.pushNamed(myRequestDetailsScreen, extra: {
          'type': response?.data?.rideType?.toLowerCase(),
          'bookingId': data['booking_id'].toString(),
        });
      }
    } catch (e) {
      customPrint('Error: Redirecting to the screen: $e');
    }
  }
}
