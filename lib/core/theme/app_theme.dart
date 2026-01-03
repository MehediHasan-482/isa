import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.green.shade700,
    scaffoldBackgroundColor: Colors.white,
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.green.shade400,
    scaffoldBackgroundColor: Colors.black,
    useMaterial3: true,
  );
}
