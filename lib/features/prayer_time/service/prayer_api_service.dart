import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../model/prayer_time_model.dart';

class PrayerApiService {
  Future<PrayerTimeModel> fetchPrayerTimes({
    required double lat,
    required double lon,
  }) async {
    final url =
        'https://api.aladhan.com/v1/timings?latitude=$lat&longitude=$lon&method=2';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PrayerTimeModel.fromJson(data['data']['timings']);
    } else {
      throw Exception('Failed to load prayer times');
    }
  }
}
