import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');

  // 🔐 premium flag (from backend later)
  bool _isPremium = false;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get isPremium => _isPremium;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void changeLanguage(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  // backend response will control this
  void updatePremiumStatus(bool status) {
    _isPremium = status;
    notifyListeners();
  }
}
