import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as google_apis_auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/config/service_keys/firebase_keys.dart';
import 'package:official_chatbox_application/core/constants/database_name_constants.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/chat/chat_room_page.dart';
import 'package:official_chatbox_application/main.dart';

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
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
    } else {}
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
    await fireStore.collection(usersCollection).doc(currentUser?.uid).update({
      userDbFcmToken: fcmToken,
    });
  }

  // send notification for one to one chat
  static Future<void> sendNotification({
    required String receiverDeviceToken,
    required String senderName,
    required String messageToSend,
    required String id,
    required ChatModel? chatModel, // Add ChatModel parameter
    required String messageNotificationReceiverID,
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
            'userName': senderName,
            'chatModel': jsonEncode(chatModel?.toJson()),
            'isGroup': 'false',
            'receiverID': chatModel?.receiverID,
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
      } else {}
    } catch (e) {}
  }

  // send notification for group
  static Future<void> sendGroupTopicNotification({
    required String groupName,
    required String messageToSend,
    required String groupid,
    required GroupModel groupModel,
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
            'userName': groupName,
            'groupid': groupid,
            'groupModel': jsonEncode(
                groupModel.toJson()), // Convert GroupModel to JSON string
            'isGroup': 'true',
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
      } else {}
    } catch (e) {}
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
      // Accessing custom data from the remote message
      String userName = remoteMessage.data['userName'] ?? 'Unknown';
      bool isGroup =
          remoteMessage.data['isGroup'] == 'true'; // Convert string to boolean
      String chatModelJson = remoteMessage.data['chatModel'] ?? '{}';
      String groupModelJson = remoteMessage.data['groupModel'] ?? '{}';
      String receiverID = remoteMessage.data['receiverID'] ?? 'unknown';

      // Deserialize chatModel and groupModel from JSON if needed
      ChatModel? chatModel;
      GroupModel? groupModel;

      if (chatModelJson.isNotEmpty) {
        chatModel = ChatModel.fromJson(jsonDecode(chatModelJson));
      }

      if (groupModelJson.isNotEmpty && groupModelJson != 'null') {
        groupModel = GroupModel.fromJson(map: jsonDecode(groupModelJson));
      }

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
        payload: jsonEncode({
          'userName': userName,
          'isGroup': isGroup,
          'chatModel': chatModel?.toJson(),
          'groupModel':
              groupModel?.toJson(), // or groupModel.toJson() if it's a group
          'receiverID': receiverID,
        }),
      );
    });
  }

  static void onNotificationTap(NotificationResponse notificationResponse) {
    // Ensure that the payload contains the required data
    if (notificationResponse.payload != null) {
      try {
        // Assuming the payload contains a JSON string with all required data
        final Map<String, dynamic> payloadData =
            jsonDecode(notificationResponse.payload!);

        String userName = payloadData['userName'] ?? 'Unknown';
        bool isGroup = payloadData['isGroup'] == true;
        String receiverID = payloadData['receiverID'] ?? '';

        ChatModel? chatModel;
        GroupModel? groupModel;

        if (payloadData['chatModel'] != null) {
          chatModel = ChatModel.fromJson(payloadData['chatModel']);
        }

        if (isGroup && payloadData['groupModel'] != null) {
          groupModel = GroupModel.fromJson(map: payloadData['groupModel']);
        }

        // Navigate to ChatRoomPage with extracted data
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => ChatRoomPage(
              userName: userName,
              isGroup: isGroup,
              chatModel: chatModel,
              groupModel: groupModel,
              receiverID: receiverID,
            ),
          ),
        );
      } catch (e) {}
    } else {}
  }
}
