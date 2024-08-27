import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:official_chatbox_application/core/service/notification_service.dart';
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
  if (remoteMessage.notification != null) {}
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  Gemini.init(apiKey: GeminiFields.geminiApiKey);
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  initializeServiceLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.requestPermission();
  await NotificationService.localNotificationInit();
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
