import 'dart:developer';

import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../core/common/logs.dart';
import 'local_notification_handler.dart';

class NotificationHandler {
  // Lazily access FirebaseMessaging instance to avoid requiring initialization at import time
  static FirebaseMessaging get _messaging => FirebaseMessaging.instance;
  static String? fcmToken = '';

  static Future init() async {
    try {
      // If Firebase isn't initialized by the app, skip silently
      if (firebase_core.Firebase.apps.isEmpty) return;

      await _messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );

      fcmToken = await _messaging.getToken();
      Print.success('FCM Token: $fcmToken');

      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        LocalNotificationService.showBasicNotification(message);
        Print.success('Notification onMessage: ${message.notification?.title}');
      });
    } catch (e) {
      // Ignore initialization errors in flows where Firebase isn't configured
      Print.error('Firebase Messaging init error: $e');
    }
  }

  static Future<String?> getToken() async {
    try {
      if (firebase_core.Firebase.apps.isEmpty) return null;
      String? token = await _messaging.getToken();
      fcmToken = token;
      log('FCM Token: $token');
      return token;
    } catch (e) {
      Print.error('Firebase Messaging token error: $e');
      return null;
    }
  }

  //! Handle background message
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    try {
      if (firebase_core.Firebase.apps.isEmpty) return;
      LocalNotificationService.showBasicNotification(message);
      Print.success('Notification: ${message.notification?.title}');
    } catch (e) {
      // swallow background errors
    }
  }
}
