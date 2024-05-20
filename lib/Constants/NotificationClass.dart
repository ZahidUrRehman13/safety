import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rabbit/TabScreen.dart';
import 'package:rabbit/main.dart';
import 'package:rxdart/subjects.dart';

class NotificationService {
  NotificationService();

  final _localNotifications = FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String> behaviorSubject = BehaviorSubject();

  Future<void> initializePlatformNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(initializationSettings, onDidReceiveNotificationResponse: onSelectNotification);
  }

  void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    debugPrint('id $id');
  }

  Future<dynamic> onSelectNotification(payload) async {
    navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) =>  TabScreen()),
          (Route<dynamic> route) => false,
        );
  }

  Future<NotificationDetails> _notificationDetails() async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel id',
      'channel name',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      ticker: 'ticker',
      color: Colors.green,
    );

    DarwinNotificationDetails  iosNotificationDetails = const DarwinNotificationDetails(
      threadIdentifier: "thread1",
    );

    final details = await _localNotifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      behaviorSubject.add(details.notificationResponse!.payload!);
    }
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

    return platformChannelSpecifics;
  }

  Future<void> showLocalNotification({required RemoteMessage message}) async {
    final platformChannelSpecifics = await _notificationDetails();
    await _localNotifications.show(message.notification.hashCode, message.notification?.title, message.notification?.body, platformChannelSpecifics,
        payload: message.data['payload']);
  }



}
