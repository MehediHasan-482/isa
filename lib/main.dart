import 'package:flutter/material.dart';
import 'package:isa/core/providers/feature_provider.dart';
import 'package:isa/features/prayer_time/provider/prayer_time_provider.dart';
import 'package:isa/features/qibla/provider/qibla_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/providers/app_provider.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  // SharedPreferences initialization safe
  bool isTest = false;
  assert(isTest = true); // test mode only

  final prefs = isTest
      ? await SharedPreferences.getInstance() // in test this can be mocked
      : await SharedPreferences.getInstance();

  final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => PrayerTimeProvider()),
        ChangeNotifierProvider(create: (_) => FeaturesProvider()),
        ChangeNotifierProvider(create: (_) => QiblaProvider()),
      ],
      child: ISAApp(isFirstTime: isFirstTime),
    ),
  );
}
