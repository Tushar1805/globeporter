// ignore_for_file: use_build_context_synchronously, avoid_dynamic_calls, avoid_print
import 'dart:io';
import 'package:core/utils/core_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(
  final NotificationResponse notificationResponse,
) {
  customPrint('******** background notifcation');
  print(' ******** relese on tap');
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
        print('relese on tap');
        handleMessage(message);
      },
      // onDidReceiveBackgroundNotificationResponse:
      //     (final NotificationResponse notificationResponse) {
      //   print('relese on tap');
      //   handleMessage(message);
      // },
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
    await FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onBackgroundMessage((final message) {
      final notification = message.notification;
      final android = message.notification!.android;
      if (kDebugMode) {
        print('notifications title:${notification!.title}');
        print('notifications body:${notification.body}');
        print(
          'count:${android?.count == null ? notificationCount : android?.count ?? 0}',
        );
        print('data:${message.data}');
      }
      return showNotification(
        message,
        android?.count == null ? notificationCount : android?.count ?? 0,
      );
    });
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

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
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

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
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
    bool val = false;
    messaging.onTokenRefresh.listen((final event) {
      val = true;
    });
    return val;
  }

  Future foregroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void handleMessage(final RemoteMessage message) async {
    customPrint(message);
  }
}
