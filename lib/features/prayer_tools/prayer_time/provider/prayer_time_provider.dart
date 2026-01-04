import 'package:flutter/material.dart';

class PrayerTimeProvider extends ChangeNotifier {
  Map<String, String>? prayerTimes;
  bool isLoading = true;
  String? error;

  PrayerTimeProvider() {
    loadPrayerTimes();
  }

  Future<void> loadPrayerTimes() async {
    try {
      isLoading = true;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 0));
      prayerTimes = {
        'Fajr': '05:00 AM',
        'Dhuhr': '12:30 PM',
        'Asr': '04:15 PM',
        'Maghrib': '06:45 PM',
        'Isha': '08:00 PM',
      };

      error = null;
    } catch (e) {
      error = 'Failed to load prayer times';
      prayerTimes = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String getFormattedTime(String prayer) {
    return prayerTimes?[prayer] ?? '--:--';
  }
}
