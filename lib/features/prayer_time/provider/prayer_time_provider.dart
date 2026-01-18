// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class PrayerTimeProvider extends ChangeNotifier {
  String currentPrayerName = '';
  String currentPrayerTime = '';
  String remainingTime = '';
  String hijriDate = '';
  String gregorianDate = '';

  Map<String, String> prayerTimes = {};
  Timer? _timer;

  // ================= LOAD PRAYER TIMES =================
  Future<void> loadPrayerTimes() async {
    try {
      final position = await _determinePosition();

      final url = Uri.parse(
        'https://api.aladhan.com/v1/timings'
        '?latitude=${position.latitude}'
        '&longitude=${position.longitude}'
        '&method=2',
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Failed to load prayer times');
      }

      final body = json.decode(response.body);
      final timings = body['data']['timings'];
      final date = body['data']['date'];

      prayerTimes = {
        'Fajr': timings['Fajr'],
        'Sunrise': timings['Sunrise'],
        'Dhuhr': timings['Dhuhr'],
        'Asr': timings['Asr'],
        'Maghrib': timings['Maghrib'],
        'Isha': timings['Isha'],
        'Midnight': timings['Midnight'],
      };

      hijriDate =
          "${date['hijri']['day']} ${date['hijri']['month']['en']} ${date['hijri']['year']}";
      gregorianDate =
          "${date['gregorian']['day']} ${date['gregorian']['month']['en']} ${date['gregorian']['year']}";

      _updateCurrentPrayer();

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _updateCurrentPrayer();
      });

      notifyListeners();
    } catch (e) {
      debugPrint('PrayerTime error: $e');
    }
  }

  // ================= UPDATE CURRENT PRAYER =================
  void _updateCurrentPrayer() {
    if (prayerTimes.isEmpty) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    DateTime parse(String t) {
      final p = t.split(':');
      return DateTime(
        today.year,
        today.month,
        today.day,
        int.parse(p[0]),
        int.parse(p[1]),
      );
    }

    final fajr = parse(prayerTimes['Fajr']!);
    final sunrise = parse(prayerTimes['Sunrise']!);
    final dhuhr = parse(prayerTimes['Dhuhr']!);
    final asr = parse(prayerTimes['Asr']!);
    final maghrib = parse(prayerTimes['Maghrib']!);
    final isha = parse(prayerTimes['Isha']!);

    DateTime midnight = parse(prayerTimes['Midnight']!);
    if (midnight.isBefore(isha)) {
      midnight = midnight.add(const Duration(days: 1));
    }

    final prayerRanges = {
      'Fajr': {'start': fajr, 'end': sunrise},
      'Dhuhr': {'start': dhuhr, 'end': asr},
      'Asr': {'start': asr, 'end': maghrib},
      'Maghrib': {'start': maghrib, 'end': isha},
      'Isha': {'start': isha, 'end': midnight},
    };

    for (final entry in prayerRanges.entries) {
      final start = entry.value['start']!;
      final end = entry.value['end']!;
      if (now.isAfter(start) && now.isBefore(end)) {
        currentPrayerName = entry.key;
        currentPrayerTime = prayerTimes[entry.key]!;
        remainingTime = _formatDuration(end.difference(now));
        notifyListeners();
        return;
      }
    }
  }

  // ================= FORMAT TIME =================
  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    return '${h}h ${m}m ${s}s';
  }

  // ================= LOCATION =================
  Future<Position> _determinePosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Location service disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied forever');
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
