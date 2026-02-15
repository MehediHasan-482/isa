import 'package:flutter/material.dart';
import 'package:isa/core/providers/feature_provider.dart';
import 'package:isa/features/allah_name/provider/allah_name_provider.dart';
import 'package:isa/features/blog/provider/blog_provider.dart';
import 'package:isa/features/hifz/provider/hifz_provider.dart';
import 'package:isa/features/prayer_time/provider/prayer_time_provider.dart';
import 'package:isa/features/qibla/provider/qibla_provider.dart';
import 'package:isa/features/quran/provider/quran_provider.dart';
import 'package:isa/features/tasbeeh/provider/tasbeeh_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/providers/app_provider.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  bool isTest = false;
  assert(isTest = true);

  final prefs = isTest
      ? await SharedPreferences.getInstance()
      : await SharedPreferences.getInstance();

  final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => PrayerTimeProvider()),
        ChangeNotifierProvider(create: (_) => FeaturesProvider()),
        ChangeNotifierProvider(create: (_) => QiblaProvider()),
        ChangeNotifierProvider(create: (_) => TasbeehProvider()),
        ChangeNotifierProvider(create: (_) => AllahNameProvider()),
        ChangeNotifierProvider(create: (_) => QuranProvider()),
        ChangeNotifierProvider(create: (_) => BlogProvider()),
        ChangeNotifierProvider(create: (_) => HifzProvider()),
      ],
      child: ISAApp(isFirstTime: isFirstTime),
    ),
  );
}
