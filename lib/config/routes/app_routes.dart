  // routes provider method start
  import 'package:flutter/material.dart';
import 'package:official_chatbox_application/features/presentation/pages/main_page/main_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/chat/chat_home_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/chatbox_welcome/chatbox_welcome_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/create_account/create_account_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/navigator_bottomnav_page/navigator_bottomnav_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/search_page/search_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/settings_page.dart';

class AppRoutes{
  static Map<String, Widget Function(BuildContext)> routes(
      {required BuildContext context}) {
    return {
      "/": (context) => const MainPage(),
      'welcome_page': (context) => const ChatboxWelcomePage(),
      "create_account": (context) => CreateAccountPage(),
      "bottomNav_Navigator": (context) => const NavigatorBottomnavPage(),
      "/search_page": (context) => const SearchPage(),
      "/settings_page": (context) => const SettingsPage(),
      "/chat_home": (context) =>const ChatHomePage(),
    };
  } //routes provider method end
}