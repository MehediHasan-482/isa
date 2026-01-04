import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/app_provider.dart';
import 'core/localization/app_localization.dart';
import 'features/dashboard/ui/dashboard_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';

class ISAApp extends StatelessWidget {
  const ISAApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ISA – Islamic Assistant',

      // 🌐 Localization
      locale: appProvider.locale,
      supportedLocales: const [Locale('en'), Locale('bn'), Locale('ar')],
      localizationsDelegates: const [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // 🌙 Theme
      themeMode: appProvider.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      // 🔹 Home
      home: const DashboardScreen(),
    );
  }
}
