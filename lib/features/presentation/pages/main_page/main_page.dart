import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/splash_screen/splash_screen.dart';
import 'package:official_chatbox_application/features/presentation/pages/web_view/chatbox_web_auth/chatbox_web_authentication_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // web view
      return const ChatboxWebAuthenticationPage();
    }
    // mobile view
    return const SplashScreen();
  }
}
