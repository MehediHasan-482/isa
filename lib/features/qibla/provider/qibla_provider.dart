// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'dart:math';

class QiblaProvider extends ChangeNotifier {
  double qiblaAngle = 0.0; // angle to Kaaba
  Position? currentPosition;
  String? address; // <-- address added

  /// Update current location and calculate Qibla angle
  Future<void> updateLocation() async {
    try {
      currentPosition = await _determinePosition();

      if (currentPosition != null) {
        // Qibla angle
        qiblaAngle = _calculateQibla(
          currentPosition!.latitude,
          currentPosition!.longitude,
        );

        // Reverse Geocoding for address
        try {
          List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
            currentPosition!.latitude,
            currentPosition!.longitude,
          );

          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            address =
                '${place.name ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}';
          } else {
            address =
                'Lat: ${currentPosition!.latitude.toStringAsFixed(4)}, Lng: ${currentPosition!.longitude.toStringAsFixed(4)}';
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error getting address: $e');
          }
          address =
              'Lat: ${currentPosition!.latitude.toStringAsFixed(4)}, Lng: ${currentPosition!.longitude.toStringAsFixed(4)}';
        }

        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching location: $e');
      }
    }
  }

  double _calculateQibla(double lat, double lon) {
    const kaabaLat = 21.4225;
    const kaabaLon = 39.8262;

    double latRad = _degreesToRadians(lat);
    double lonRad = _degreesToRadians(lon);
    double kaabaLatRad = _degreesToRadians(kaabaLat);
    double kaabaLonRad = _degreesToRadians(kaabaLon);

    double deltaLon = kaabaLonRad - lonRad;

    double x = sin(deltaLon);
    double y = cos(latRad) * tan(kaabaLatRad) - sin(latRad) * cos(deltaLon);

    double angleRad = atan2(x, y);
    double angleDeg = (_radiansToDegrees(angleRad) + 360) % 360;

    return angleDeg;
  }

  double _degreesToRadians(double deg) => deg * pi / 180;
  double _radiansToDegrees(double rad) => rad * 180 / pi;

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
}
