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
      debugPrint(">>> loadPrayerTimes CALLED");

      final position = await _determinePosition();

      final url = Uri.parse(
        'https://api.aladhan.com/v1/timings'
        '?latitude=${position.latitude}'
        '&longitude=${position.longitude}'
        '&method=2',
      );

      final response = await http.get(url);
      debugPrint("API STATUS: ${response.statusCode}");

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

      debugPrint("PRAYER TIMES FROM API: $prayerTimes");

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
      debugPrint('❌ PrayerTime error: $e');
    }
  }

  // ================= UPDATE CURRENT PRAYER =================
  void _updateCurrentPrayer() {
    debugPrint(">>> _updateCurrentPrayer CALLED");
    if (prayerTimes.isEmpty) {
      // debugPrint("❌ prayerTimes EMPTY");
      return;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    DateTime parse(String t) {
      // debugPrint("RAW TIME FROM API: $t");

      final cleanTime = t.split(' ').first; // removes (+06)
      final p = cleanTime.split(':');

      int hour = int.parse(p[0]);
      int minute = int.parse(p[1]);

      DateTime dt = DateTime(today.year, today.month, today.day, hour, minute);

      // Midnight / after-midnight → next day
      if (hour < 3) dt = dt.add(const Duration(days: 1));

      // debugPrint("PARSED DATETIME: $dt");
      return dt;
    }

    final fajr = parse(prayerTimes['Fajr']!);
    final sunrise = parse(prayerTimes['Sunrise']!);
    final dhuhr = parse(prayerTimes['Dhuhr']!);
    final asr = parse(prayerTimes['Asr']!);
    final maghrib = parse(prayerTimes['Maghrib']!);
    final isha = parse(prayerTimes['Isha']!);
    final midnight = parse(prayerTimes['Midnight']!);

    final prayerRanges = {
      'Fajr': {'start': fajr, 'end': sunrise},
      'Dhuhr': {'start': dhuhr, 'end': asr},
      'Asr': {'start': asr, 'end': maghrib},
      'Maghrib': {'start': maghrib, 'end': isha},
      'Isha': {'start': isha, 'end': midnight},
    };

    bool matched = false;

    // 1️⃣ Check if current prayer is active
    for (final entry in prayerRanges.entries) {
      final start = entry.value['start']!;
      final end = entry.value['end']!;

      // debugPrint("CHECK ${entry.key} | now=$now | start=$start | end=$end");

      if (now.isAfter(start) && now.isBefore(end)) {
        currentPrayerName = '${entry.key} ends in';
        currentPrayerTime = prayerTimes[entry.key]!;
        remainingTime = _formatDuration(end.difference(now));

        // debugPrint(
        //   "✅ CURRENT PRAYER: $currentPrayerName | Remaining: $remainingTime",
        // );

        matched = true;
        break;
      }
    }

    // 2️⃣ If no current prayer → show next prayer countdown
    if (!matched) {
      for (final entry in prayerRanges.entries) {
        final start = entry.value['start']!;
        if (now.isBefore(start)) {
          currentPrayerName = '${entry.key} start in';
          currentPrayerTime = prayerTimes[entry.key]!;
          remainingTime = _formatDuration(start.difference(now));

          // debugPrint("⏭ NEXT PRAYER: $currentPrayerName | Remaining: $remainingTime",);
          matched = true;
          break;
        }
      }
    }

    // 3️⃣ If still no match (late night after Isha) → show Fajr next
    if (!matched) {
      final nextFajr = prayerRanges['Fajr']!['start']!.add(
        const Duration(days: 1),
      );
      currentPrayerName = 'Fajr start in';
      currentPrayerTime = prayerTimes['Fajr']!;
      remainingTime = _formatDuration(nextFajr.difference(now));

      // debugPrint("🌙 NIGHT → NEXT PRAYER: $currentPrayerName | Remaining: $remainingTime",);
    }

    notifyListeners();
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
