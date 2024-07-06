import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  checkPermission() async {
    if (await Permission.notification.isGranted) {
      log('Permission granted');
    } else {
      log('Permission not granted');
      await Permission.notification.request();
    }
  }

  Future<void> initNotifications() async {
    checkPermission();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    await notificationsPlugin.initialize(
      const InitializationSettings(android: initializationSettingsAndroid),
    );
  }

  Future<void> showNotificationMessage(String message) async {
    try {
      log('Showing notification: $message');
      await notificationsPlugin.show(
        0,
        'Planteo',
        message,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            icon: '@mipmap/ic_launcher',
            'com.codenust.blind_assist',
            'Geofence Notification',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    } catch (e) {
      log('Error showing notification: $e');
    }
  }

  Future<void> handleNotification(RemoteMessage message) async {
    // Handle notification message
    log('Notification received: ${message.notification!.title}');

    // Show a notification using the `flutter_local_notifications` package
    await _showNotification();

    // Open the app when notification is clicked
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Notification clicked: ${message.notification!.title}');
      // Add your code to open the app here
    });
  }

  Future<void> _showNotification() async {
    log('Showing notification');
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.notification!.title}');

      // Show a notification using the `flutter_local_notifications` package
      showNotificationMessage(message.notification!.title!);
      return;
    });
  }

  Future<void> startBackgroundService() async {
    final service = FlutterBackgroundService();
    await service.startService();
  }

  Future<String?> getFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    log('FCM Token: $token');
    return '$token';
  }
}
