import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/main.dart';

class NotificationService {
  static final firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
//  request permission for notifications
  static initNotfications() async {
    await firebaseMessaging.requestPermission(
      alert: true,
      provisional: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      sound: true,
      announcement: true,
    );
  }

// call this page inside navbottom nav page
  static Future getDeviceToken() async{
    final currentUser = firebaseAuth.currentUser;
    // get fcm Token
    final fcmToken = await firebaseMessaging.getToken();
    log(name: "Token", fcmToken.toString());
    // check if logged in user or not and according to that save it to firebase firestore
    firebaseMessaging.onTokenRefresh.listen((event)async{
      if (currentUser!=null) {
        // save token to firebase

      }
    });
  }

  // local notification init
  static localNotificationInit() {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    final DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings linuxInitializationSettings =
        LinuxInitializationSettings(defaultActionName: "Open notification");
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
      linux: linuxInitializationSettings,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
      onDidReceiveNotificationResponse: onNotificationTap,
    );
  }

  static void onNotificationTap(NotificationResponse notificationResponse) {
    navigatorKey.currentState?.pushNamed("/chat_home", arguments: notificationResponse,);
  }
  // inapp
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: '',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
// call init, local init inside main