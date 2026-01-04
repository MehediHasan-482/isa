import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  // Theme
  ThemeMode themeMode = ThemeMode.light;

  void toggleTheme(bool isDark) {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Language
  Locale locale = const Locale('en');
  void changeLanguage(Locale newLocale) {
    locale = newLocale;
    notifyListeners();
  }

  // Premium
  bool isPremium = false;
  void updatePremiumStatus(bool status) {
    isPremium = status;
    notifyListeners();
  }
}
