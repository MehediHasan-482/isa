import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'app.dart';
import 'core/providers/app_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1️⃣ Initialize timezone database
  tz.initializeTimeZones();

  // 2️⃣ Set local timezone
  final String localTimeZone = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(localTimeZone));

  // 3️⃣ Run the app with Provider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        // Add more providers later (PrayerTimeProvider, etc.)
      ],
      child: const ISAApp(),
    ),
  );
}
