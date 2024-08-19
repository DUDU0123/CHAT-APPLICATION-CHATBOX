import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:official_chatbox_application/config/notification_service/notification_service.dart';
import 'package:official_chatbox_application/config/service_keys/gemini_api_key.dart';
import 'package:official_chatbox_application/core/service/locator.dart';
import 'package:official_chatbox_application/features/presentation/root_widget_page.dart';
import 'package:official_chatbox_application/firebase_options.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> backgroundMessaging(
  RemoteMessage remoteMessage,
) async {
  if (remoteMessage.notification != null) {
    log("Notfication receive in background");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  Gemini.init(apiKey: GeminiFields.geminiApiKey);
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  initializeServiceLocator();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyA1ICAy3Bl-2_GRxiVp9yMxxwnGxBekgdM",
          authDomain: "new-chat-box-social-app.firebaseapp.com",
          projectId: "new-chat-box-social-app",
          storageBucket: "new-chat-box-social-app.appspot.com",
          messagingSenderId: "641647769517",
          appId: "1:641647769517:web:9295d158eb1662e7705324"),
    );
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.initNotfications();
  await NotificationService.localNotificationInit();
  FirebaseMessaging.onBackgroundMessage(backgroundMessaging);
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
    if (remoteMessage.notification != null) {
      log("Geted notification");
      navigatorKey.currentState?.pushNamed(
        "/chat_home",
        arguments: remoteMessage,
      );
    }
  });
  // FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
  //   String payloadData = jsonEncode(remoteMessage.data);
  //   log("Got message foreground");
  //   if (remoteMessage.notification != null) {
  //     NotificationService.showSimpleNotification(
  //       title: remoteMessage.notification!.title!,
  //       body: remoteMessage.notification!.body!,
  //       payload: payloadData,
  //     );
  //   }
  // });
  final RemoteMessage? remoteMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (remoteMessage != null) {
    log("Launched from terminated state");
    Future.delayed(const Duration(seconds: 1), () {
      navigatorKey.currentState?.pushNamed(
        "/chat_home",
        arguments: remoteMessage,
      );
    });
  }

  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );

    runApp(
      RootWidgetPage(
        navigatorKey: navigatorKey,
      ),
    );
  });
}
