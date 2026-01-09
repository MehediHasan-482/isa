import 'package:flutter/material.dart';
import 'package:isa/widgets/premium_guard.dart';
import 'package:provider/provider.dart';
import 'core/providers/app_provider.dart';
import 'core/localization/app_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'widgets/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ISAApp extends StatelessWidget {
  final bool isFirstTime;
  const ISAApp({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ISA – Islamic Assistant',
      locale: appProvider.locale,
      supportedLocales: const [Locale('en'), Locale('bn'), Locale('ar')],
      localizationsDelegates: const [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: appProvider.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: isFirstTime
          ? WelcomeScreen(
              onFinish: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isFirstTime', false);
              },
            )
          : PremiumSubscriptionScreen(),
    );
  }
}
