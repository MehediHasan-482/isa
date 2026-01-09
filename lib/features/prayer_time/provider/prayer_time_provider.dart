// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // GPS location
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class PrayerTimeProvider extends ChangeNotifier {
  String currentPrayerName = '';
  String currentPrayerTime = '';
  String hijriDate = '';
  String gregorianDate = '';
  String nextPrayerName = '';
  String remainingTime = '';

  Map<String, String> prayerTimes = {};

  Timer? _timer;

  /// Load prayer times using current location
  Future<void> loadPrayerTimes() async {
    try {
      // Get current location
      Position position = await _determinePosition();
      double lat = position.latitude;
      double lon = position.longitude;

      final url = Uri.parse(
        'https://api.aladhan.com/v1/timings?latitude=$lat&longitude=$lon&method=2',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = Map<String, dynamic>.from(data['data']['timings']);
        final date = data['data']['date'];

        // Store all prayer times (only the 5 obligatory prayers)
        prayerTimes = {
          'Fajr': timings['Fajr'],
          'Dhuhr': timings['Dhuhr'],
          'Asr': timings['Asr'],
          'Maghrib': timings['Maghrib'],
          'Isha': timings['Isha'],
        };

        hijriDate =
            "${date['hijri']['day']}-${date['hijri']['month']['en']}-${date['hijri']['year']}";
        gregorianDate =
            "${date['gregorian']['day']}-${date['gregorian']['month']['en']}-${date['gregorian']['year']}";
        // Update current prayer immediately
        _updateCurrentPrayer();

        // Start countdown timer
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          _updateCurrentPrayer();
        });

        notifyListeners();
      } else {
        throw Exception('Failed to fetch prayer times');
      }
    } catch (e) {
      print('Error loading prayer times: $e');
    }
  }

  void _updateCurrentPrayer() {
    if (prayerTimes.isEmpty) return;

    final now = DateTime.now();

    // Convert prayerTimes to DateTime objects
    Map<String, DateTime> prayersDateTime = {};
    prayerTimes.forEach((key, value) {
      final parts = value.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      prayersDateTime[key] = DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );
    });

    // The ordered list of prayers
    List<String> order = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    String? currPrayer;
    String? nextPrayer;
    DateTime? nextPrayerTime;

    for (int i = 0; i < order.length; i++) {
      String prayer = order[i];
      DateTime prayerTime = prayersDateTime[prayer]!;

      if (i < order.length - 1) {
        DateTime nextTime = prayersDateTime[order[i + 1]]!;
        if (now.isAfter(prayerTime) && now.isBefore(nextTime)) {
          currPrayer = prayer;
          nextPrayer = order[i + 1];
          nextPrayerTime = nextTime;
          break;
        }
      } else {
        // For Isha, next prayer is tomorrow Fajr
        DateTime nextTime = prayersDateTime['Fajr']!.add(
          const Duration(days: 1),
        );
        if (now.isAfter(prayerTime)) {
          currPrayer = 'Isha';
          nextPrayer = 'Fajr';
          nextPrayerTime = nextTime;
          break;
        } else if (now.isBefore(prayerTime)) {
          // before Isha
          currPrayer = 'Maghrib';
          nextPrayer = 'Isha';
          nextPrayerTime = prayerTime;
          break;
        }
      }
    }

    // Update values
    if (currPrayer != null && nextPrayerTime != null) {
      currentPrayerName = currPrayer;
      currentPrayerTime = prayerTimes[currPrayer]!;
      nextPrayerName = nextPrayer!;
      remainingTime = _formatDuration(nextPrayerTime.difference(now));
      notifyListeners();
    }
  }

  String _formatDuration(Duration duration) {
    int h = duration.inHours;
    int m = duration.inMinutes % 60;
    int s = duration.inSeconds % 60;
    return '${h}h ${m}m ${s}s';
  }

  // Request location permission and get current position
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
