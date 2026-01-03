import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class PrayerTimeService {
  Future<Map<String, DateTime>> getPrayerTimes() async {
    final position = await _getLocation();

    final coordinates =
        Coordinates(position.latitude, position.longitude);

    final params = CalculationMethod.karachi.getParameters();
    params.madhab = Madhab.hanafi;

    final prayerTimes =
        PrayerTimes.today(coordinates, params);

    return {
      'Fajr': prayerTimes.fajr,
      'Dhuhr': prayerTimes.dhuhr,
      'Asr': prayerTimes.asr,
      'Maghrib': prayerTimes.maghrib,
      'Isha': prayerTimes.isha,
    };
  }

  Future<Position> _getLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw 'Location service disabled';
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permission permanently denied';
    }

    return await Geolocator.getCurrentPosition();
  }

  String formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }
}
