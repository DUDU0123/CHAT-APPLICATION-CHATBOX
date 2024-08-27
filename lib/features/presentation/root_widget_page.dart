import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:official_chatbox_application/config/bloc_providers/all_bloc_providers.dart';
import 'package:official_chatbox_application/config/common_provider/common_provider.dart';
import 'package:official_chatbox_application/config/routes/app_routes.dart';
import 'package:official_chatbox_application/config/theme/theme_constants.dart';
import 'package:official_chatbox_application/config/theme/theme_manager.dart';
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
            routes: AppRoutes.routes(context: context),
          ),
        );
      }),
    );
  }
}
