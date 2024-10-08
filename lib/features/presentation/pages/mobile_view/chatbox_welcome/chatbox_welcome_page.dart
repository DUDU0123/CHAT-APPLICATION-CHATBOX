import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/config/theme/theme_constants.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/features/presentation/bloc/bottom_nav_bloc/bottom_nav_bloc.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/help/inner_pages/terms_and_privacy_policy_page.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/app_icon_hold_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/common_button_container.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';

class ChatboxWelcomePage extends StatefulWidget {
  const ChatboxWelcomePage({super.key});

  @override
  State<ChatboxWelcomePage> createState() => _ChatboxWelcomePageState();
}

class _ChatboxWelcomePageState extends State<ChatboxWelcomePage> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      if(mounted){
        context
          .read<BottomNavBloc>()
          .add(MainContentShowEvent(showMainContent: true));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeConstants.theme(context: context);
    return  Scaffold(
      body: Center(
        child:context.watch<BottomNavBloc>().state.showWelcomWidget? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppIconHoldWidget(),
            kHeight15,
            TextWidgetCommon(
              text: "Add an account",
              fontSize: theme.textTheme.titleMedium?.fontSize,
              textColor: theme.textTheme.titleMedium?.color,
              fontWeight: theme.textTheme.titleMedium?.fontWeight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidgetCommon(
                  text: "Read our ",
                  fontSize: theme.textTheme.titleSmall?.fontSize,
                  textColor: theme.textTheme.titleSmall?.color,
                  fontWeight: theme.textTheme.titleSmall?.fontWeight,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const TermsAndPrivacyPolicyPage(),
                        ));
                  },
                  child: Text(
                    "Privacy Policy ",
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: darkSmallTextColor,
                    ),
                  ),
                ),
                TextWidgetCommon(
                  text: "and Get start the journey",
                  fontSize: theme.textTheme.titleSmall?.fontSize,
                  textColor: theme.textTheme.titleSmall?.color,
                  fontWeight: theme.textTheme.titleSmall?.fontWeight,
                ),
              ],
            ),
            kHeight20,
            CommonButtonContainer(
              onTap: () {
                Navigator.pushNamed(context, "create_account");
              },
              horizontalMarginOfButton: 30,
              text: "Get Started",
            ),
          ],
        ): const AppIconHoldWidget(),
      ),
    );
  }
}
