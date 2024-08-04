import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
const androidTransitionBuilder = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
  },
);

const  iosTransitionBuilder = PageTransitionsTheme(
  builders: {
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  },
);
class ThemeConstants {
  static ThemeData lightTheme = ThemeData(
     switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.all(darkSwitchColor)
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(buttonSmallTextColor)
    ),
    pageTransitionsTheme: androidTransitionBuilder,
    appBarTheme: AppBarTheme(
      backgroundColor: kWhite,
      surfaceTintColor: kTransparent,
    ),
    brightness: Brightness.light,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: kTransparent,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedIconTheme: IconThemeData(color: kWhite),
      unselectedItemColor: kBlack,
      selectedItemColor: kBlack,
      selectedLabelStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: kBlack,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
      ),
    ),
    scaffoldBackgroundColor: kWhite,
    splashColor: kTransparent,
    highlightColor: kTransparent,
    shadowColor: const Color.fromARGB(255, 84, 84, 84),
    radioTheme:
        RadioThemeData(fillColor: WidgetStateProperty.all(darkScaffoldColor)),
    dialogTheme: DialogTheme(
      titleTextStyle: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.bold,
        color: kBlack,
      ),
    ),
    textTheme: TextTheme(
      labelSmall: TextStyle(
        fontSize: 20.sp,
        color: kWhite,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
        fontSize: 10.sp,
        color: kGrey,
        fontWeight: FontWeight.normal,
      ),
      titleMedium: TextStyle(
        fontSize: 25.sp,
        color: kBlack,
        fontWeight: FontWeight.w500,
      ),
    ),
    primaryColor: kBlack,
    iconTheme: IconThemeData(
      color: buttonSmallTextColor,
    ),
    colorScheme: const ColorScheme.light().copyWith(
      onPrimary: kBlack,
      onSecondary: onSecondaryColorLight,
      onTertiary: kWhite,
    ),
    popupMenuTheme: PopupMenuThemeData(
      surfaceTintColor: kTransparent,
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
      color: boxColorWhite,
      iconColor: kBlack,
      iconSize: 26.sp,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.all(darkSwitchColor)
    ),
    checkboxTheme: CheckboxThemeData(
      overlayColor: WidgetStateProperty.all(kTransparent),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.sp)),
      fillColor: WidgetStateProperty.all(buttonSmallTextColor)
    ),
    pageTransitionsTheme: androidTransitionBuilder,
    appBarTheme: AppBarTheme(
      surfaceTintColor: kTransparent,
      backgroundColor: darkScaffoldColor,
    ),
    brightness: Brightness.dark,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedIconTheme: IconThemeData(color: kWhite),
      unselectedItemColor: kWhite,
      selectedItemColor: kWhite,
      selectedLabelStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: kWhite,
      ),
      backgroundColor: kTransparent,
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
      ),
    ),
    scaffoldBackgroundColor: darkScaffoldColor,
    splashColor: kTransparent,
    highlightColor: kTransparent,
    shadowColor: const Color.fromARGB(255, 5, 4, 11),
    radioTheme: RadioThemeData(fillColor: WidgetStateProperty.all(kWhite)),
    textTheme: TextTheme(
      labelSmall: TextStyle(
        fontSize: 20.sp,
        color: kWhite,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
        fontSize: 10.sp,
        color: kGrey,
        fontWeight: FontWeight.normal,
      ),
      titleMedium: TextStyle(
        fontSize: 25.sp,
        color: kWhite,
        fontWeight: FontWeight.w500,
      ),
    ),
    dialogTheme: DialogTheme(
      titleTextStyle: TextStyle(
        color: kWhite,
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
      ),
    ),
    colorScheme: const ColorScheme.dark().copyWith(
      onPrimary: kWhite,
      onSecondary: onSecondaryColorDark,
      onTertiary: greyBlackColor,
    ),
    primaryColor: buttonSmallTextColor,
    iconTheme: IconThemeData(
      color: kWhite,
    ),
    popupMenuTheme: PopupMenuThemeData(
      surfaceTintColor: kTransparent,
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
      color: boxColorDark,
      iconColor: kWhite,
      iconSize: 26.sp,
    )
  );

  static ThemeData theme({required BuildContext context}) {
    return Theme.of(context);
  }
}
