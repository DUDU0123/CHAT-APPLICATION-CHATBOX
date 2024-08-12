import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/core/service/locator.dart';
import 'package:official_chatbox_application/features/presentation/root_widget_page.dart';
import 'package:official_chatbox_application/firebase_options.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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