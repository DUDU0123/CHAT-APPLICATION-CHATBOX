import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as google_apis_auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/config/service_keys/firebase_keys.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/main.dart';
import 'package:path_provider/path_provider.dart';

class NotificationService {
  static final firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
//  request permission for notifications
  static requestPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      provisional: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      sound: true,
      announcement: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log("User granted provisional permission");
    } else {
      log("User declined permission");
    }
  }

  // get server access token
  static Future<String> getAccessToken() async {
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];
    http.Client client = await google_apis_auth.clientViaServiceAccount(
      google_apis_auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );
    // get access token
    google_apis_auth.AccessCredentials credentials =
        await google_apis_auth.obtainAccessCredentialsViaServiceAccount(
      google_apis_auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );
    client.close();
    return credentials.accessToken.data;
  }

// call this page inside navbottom nav page
  static Future<void> getDeviceToken() async {
    final currentUser = firebaseAuth.currentUser;
    // get fcm Token
    final fcmToken = await firebaseMessaging.getToken();
    log(name: "Token", fcmToken.toString());
    await fireStore.collection(usersCollection).doc(currentUser?.uid).update({
      userDbFcmToken: fcmToken,
    });
  }

  // send notification
  static Future<void> sendNotification({
    required String receiverDeviceToken,
    required String senderName,
    required String messageToSend,
    required String id,
  }) async {
    try {
      final String serverAccessTokenKey = await getAccessToken();
      String endpointFirebaseCloudMessaging =
          'https://fcm.googleapis.com/v1/projects/new-chat-box-social-app/messages:send';
      final Map<String, dynamic> message = {
        'message': {
          'token': receiverDeviceToken,
          'notification': {
            'title': senderName,
            'body': messageToSend,
          },
          'data': {
            'id': id,
          },
        }
      };
      final http.Response response = await http.post(
        Uri.parse(endpointFirebaseCloudMessaging),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverAccessTokenKey',
        },
        body: jsonEncode(message),
      );
      if (response.statusCode == 200) {
        log("notification sended successfully");
      } else {
        log("notification send failed ${response.statusCode}");
      }
    } catch (e) {
      log("Exception occured $e");
    }
  }

  static Future<void> sendGroupTopicNotification({
    required String groupName,
    required String messageToSend,
    required String groupid,
  }) async {
    try {
      final String serverAccessTokenKey = await getAccessToken();
      String endpointFirebaseCloudMessaging =
          'https://fcm.googleapis.com/v1/projects/new-chat-box-social-app/messages:send';
      final Map<String, dynamic> message = {
        'message': {
          'topic': 'group_$groupid',
          'notification': {
            'title': groupName,
            'body': messageToSend,
          },
          'data': {
            'groupid': groupid,
          },
        }
      };
      final http.Response response = await http.post(
        Uri.parse(endpointFirebaseCloudMessaging),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverAccessTokenKey',
        },
        body: jsonEncode(message),
      );
      if (response.statusCode == 200) {
        log("notification sended successfully");
      } else {
        log("notification send failed ${response.statusCode}");
      }
    } catch (e) {
      log("Exception occured $e");
    }
  }


  // local notification init
  static localNotificationInit() {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    final DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );
    LinuxInitializationSettings linuxInitializationSettings =
        const LinuxInitializationSettings(
            defaultActionName: "Open notification");
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
    // firebase foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
      log("onMessage: ${remoteMessage.notification?.title} and ${remoteMessage.notification?.body}");
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        remoteMessage.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: remoteMessage.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'chatboxapp',
        'chatboxapp',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
        ticker: 'ticker',
      );
      NotificationDetails platformChannelsSpecific = NotificationDetails(
        android: androidNotificationDetails,
      );
      await flutterLocalNotificationsPlugin.show(
          0,
          remoteMessage.notification?.title,
          remoteMessage.notification?.body,
          platformChannelsSpecific,
          payload: remoteMessage.data['body']);
    });
  }

  static void onNotificationTap(NotificationResponse notificationResponse) {
    navigatorKey.currentState?.pushNamed(
      "/chat_home",
      arguments: notificationResponse,
    );
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
  // terminated
  // FirebaseMessaging.onBackgroundMessage(backgroundMessaging);
  // background
  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
  //   if (remoteMessage.notification != null) {
  //     log("Geted notification");
  //     navigatorKey.currentState?.pushNamed(
  //       "/chat_home",
  //       arguments: remoteMessage,
  //     );
  //   }
  // });