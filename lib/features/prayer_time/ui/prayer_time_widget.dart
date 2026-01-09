import 'package:flutter/material.dart';

class PrayerTimeProvider extends ChangeNotifier {
  String currentPrayerName = "Asr";
  String currentPrayerTime = "3:07 PM";
  String hijriDate = "18 Rajab 1447 AH";
  String gregorianDate = "Jan 07, 2026";
  String nextPrayerName = "Zohr";
  String remainingTime = "1h 21m 14s";

  // API call placeholder
  Future<void> loadPrayerTimes({
    required double lat,
    required double lon,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    // replace this with real API call
    currentPrayerName = "Asr";
    currentPrayerTime = "3:10 PM";
    hijriDate = "19 Rajab 1447 AH";
    gregorianDate = "Jan 08, 2026";
    nextPrayerName = "Maghrib";
    remainingTime = "2h 10m 5s";
    notifyListeners();
  }
}
