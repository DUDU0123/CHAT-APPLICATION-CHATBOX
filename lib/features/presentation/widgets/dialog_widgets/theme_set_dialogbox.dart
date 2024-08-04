
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/config/theme/theme_manager.dart';
import 'package:official_chatbox_application/features/presentation/widgets/dialog_widgets/radio_button_dialogbox_widget.dart';
import 'package:provider/provider.dart';

class ThemeSetDialogBox extends StatelessWidget {
  const ThemeSetDialogBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return RadioButtonDialogBox(
          radioOneTitle: "System default",
          radioTwoTitle: "Light",
          radioThreeTitle: "Dark",
          dialogBoxTitle: "Change Theme",
          groupValue: themeManager.selectedThemeValue,
          radioOneOnChanged: (value) {
            themeManager.selectedThemeValue = value!;
            themeManager.setSystemDefaultTheme();
          },
          radioTwoOnChanged: (value) {
            themeManager.selectedThemeValue = value!;
            themeManager.setLightTheme();
          },
          radioThreeOnChanged: (value) {
            themeManager.selectedThemeValue = value!;
            themeManager.setDarkTheme();
          },
        );
      },
    );
  }
}