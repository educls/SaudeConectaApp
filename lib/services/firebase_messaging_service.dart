import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/notification_service.dart';

import '../controllers/patient_controller.dart';
import '../utils/routes.dart';

class FirebaseMessagingService {
  final NotificationService _notificationService;

  FirebaseMessagingService(this._notificationService);

  Future<String> initialize() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      badge: true,
      sound: true,
      alert: true,
    );
    String token = await getDeviceFirebaseToken();
    _onMessage();
    _onMessageOpenedApp();
    return token;
  }

  Future<String> getDeviceFirebaseToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('=============================');
    debugPrint('TOKEN: $token');
    debugPrint('=============================');
    return token.toString();
  }

  _onMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        NotificationService.showNotification(
            title: notification.title!,
            body: notification.body!,
            payload: message.data['route'] ?? '');
      }
    });
  }

  _onMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen(_toToPageHome);
  }

  _toToPageHome(message) {
    final String route = message.data['route'] ?? '';
    if (route.isNotEmpty) {
      Routes.navigatorKey?.currentState?.pushNamed(route);
    }
  }
}
