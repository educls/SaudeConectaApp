import 'dart:convert';

import 'package:flutter_application_1/models/notification_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../utils/constants.dart';
import 'package:http/http.dart' as http;

AppConstants constants = AppConstants();

class NotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );

    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) => null,
    );
  }

  //show a simple notification
  static Future showNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.max,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }
}

class FetchApiSendNotification {
  Future<void> fetchSendNotification(NotificationModel notification) async {
    String url = '${AppConstants.baseUrlApi}/send_notification';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(notification),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
      } else {
        print('Falha na requisição: ${response.statusCode}');
        print(response.body);
      }
    } catch (err) {
      print('Erro na requisição: $err');
    }
  }
}
