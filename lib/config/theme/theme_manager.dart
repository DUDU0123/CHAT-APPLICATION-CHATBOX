import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends ChangeNotifier {
  bool isDark = false;
  int selectedThemeValue = 1;
  bool isSystemThemeMode = true;
  ThemeMode themeMode = ThemeMode.system;

  late SharedPreferences sharedPrefs;

  changeTheme() {
    isDark = !isDark;
    isSystemThemeMode = false;
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    sharedPrefs.setBool("isDark", isDark);
    sharedPrefs.setBool("isSystemMode", isSystemThemeMode);
    notifyListeners();
  }

  setDarkTheme() {
    isDark = true;
    isSystemThemeMode = false;
    themeMode = ThemeMode.dark;
    sharedPrefs.setBool("isDark", isDark);
    sharedPrefs.setBool("isSystemMode", isSystemThemeMode);
    notifyListeners();
  }

  setLightTheme() {
    isDark = false;
    isSystemThemeMode = false;
    themeMode = ThemeMode.light;
    sharedPrefs.setBool("isDark", isDark);
    sharedPrefs.setBool("isSystemMode", isSystemThemeMode);
    notifyListeners();
  }

  setSystemDefaultTheme() {
    isSystemThemeMode = true;
    themeMode = ThemeMode.system;
    sharedPrefs.setBool("isSystemMode", isSystemThemeMode);
    notifyListeners();
  }

  init() async {
    sharedPrefs = await SharedPreferences.getInstance();
    isSystemThemeMode = sharedPrefs.getBool("isSystemMode") ?? false;
    isDark = sharedPrefs.getBool("isDark") ?? false;
    themeMode = isSystemThemeMode
        ? ThemeMode.system
        : (isDark ? ThemeMode.dark : ThemeMode.light);
        selectedThemeValue = isSystemThemeMode?1:(isDark?3:2);
    notifyListeners();
  }
}
