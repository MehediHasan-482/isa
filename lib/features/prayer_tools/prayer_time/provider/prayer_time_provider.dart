import 'package:flutter/material.dart';
import 'package:isa/services/ai_service/prayer_time_service.dart';

class PrayerTimeProvider extends ChangeNotifier {
  final _service = PrayerTimeService();

  Map<String, DateTime>? prayerTimes;
  bool isLoading = false;
  String? error;

  Future<void> loadPrayerTimes() async {
    try {
      isLoading = true;
      notifyListeners();

      prayerTimes = await _service.getPrayerTimes();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String getFormattedTime(String prayer) {
    final time = prayerTimes![prayer]!;
    return _service.formatTime(time);
  }
}
