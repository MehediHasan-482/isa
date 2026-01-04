import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/app_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/ui/dashboard_screen.dart';

class ISAApp extends StatelessWidget {
  const ISAApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ISA – Islamic Assistant',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appProvider.themeMode,
      home: const DashboardScreen(),
    );
  }
}
