import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/config/common_provider/common_provider.dart';
import 'package:official_chatbox_application/config/theme/theme_constants.dart';
import 'package:official_chatbox_application/config/theme/theme_manager.dart';
import 'package:official_chatbox_application/core/utils/network_status_methods.dart';
import 'package:official_chatbox_application/features/presentation/pages/main_page/main_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/chat/chat_home_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/chatbox_welcome/chatbox_welcome_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/create_account/create_account_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/navigator_bottomnav_page/navigator_bottomnav_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/number_verify/number_verify_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/search_page/search_page.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/settings_page.dart';
import 'package:provider/provider.dart';

class RootWidgetPage extends StatelessWidget {
  const RootWidgetPage({
    super.key,
    required this.navigatorKey,
  });
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeManager()..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => CommonProvider(),
        ),
      ],
      
      child: ScreenUtilInit(builder: (context, child) {
        final themeManager = Provider.of<ThemeManager>(context);
        return MultiBlocProvider(
          providers: AppBlocProvider.allBlocProviders,
          child: GetMaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            themeMode: themeManager.themeMode,
            theme: ThemeConstants.lightTheme,
            darkTheme: ThemeConstants.darkTheme,
            initialRoute: "/",
            routes: routes(context: context),
          ),
        );
      }),
    );
  }

  // routes provider method start
  Map<String, Widget Function(BuildContext)> routes(
      {required BuildContext context}) {
    return {
      "/": (context) => const MainPage(),
      'welcome_page': (context) => const ChatboxWelcomePage(),
      "create_account": (context) => CreateAccountPage(),
      "verify_number": (context) => NumberVerifyPage(),
      "bottomNav_Navigator": (context) => const NavigatorBottomnavPage(),
      "/search_page": (context) => SearchPage(),
      "/settings_page": (context) => const SettingsPage(),
      "/chat_home": (context) => ChatHomePage(),
    };
  } //routes provider method end
}
