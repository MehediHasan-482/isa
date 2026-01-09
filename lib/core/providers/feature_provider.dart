import 'package:flutter/material.dart';

class DashboardFeature {
  final String label;
  final IconData icon;
  final Color color;

  DashboardFeature(this.label, this.icon, this.color);
}

class FeaturesProvider extends ChangeNotifier {
  List<DashboardFeature> _features = [];
  List<DashboardFeature> get features => _features;

  // Example API fetch (replace with real API)
  Future<void> loadFeatures() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network delay

    _features = [
      DashboardFeature('Quran', Icons.menu_book, Colors.green),
      DashboardFeature('Qibla', Icons.explore, Colors.teal),
      DashboardFeature('Hifz', Icons.check_circle, Colors.redAccent),
      DashboardFeature('Tasbeeh', Icons.fingerprint, Colors.blue),
      DashboardFeature('Learn Tajweed', Icons.record_voice_over, Colors.purple),
      DashboardFeature('Allah Names', Icons.star, Colors.amber),
      DashboardFeature('Blog', Icons.article, Colors.orange),
      DashboardFeature('Visual Quran', Icons.visibility, Colors.greenAccent),
      DashboardFeature('Makkah', Icons.location_city, Colors.brown),
      DashboardFeature('Masjid Finder', Icons.mosque, Colors.green),
      DashboardFeature('Islamic Tips', Icons.lightbulb, Colors.yellow),
      DashboardFeature('Prayer Times', Icons.access_time, Colors.cyan),
      DashboardFeature('In-Flight Prayer', Icons.flight, Colors.indigo),
      DashboardFeature('Quran Academy', Icons.school, Colors.deepPurple),
      DashboardFeature('Dua', Icons.volunteer_activism, Colors.pink),
      DashboardFeature(
        'Hijri Calendar',
        Icons.calendar_today,
        Colors.tealAccent,
      ),
      DashboardFeature('E-Card', Icons.card_giftcard, Colors.red),
      DashboardFeature(
        'Advertise With Us',
        Icons.campaign,
        Colors.orangeAccent,
      ),
      DashboardFeature('Quran TV', Icons.tv, Colors.deepOrange),
      DashboardFeature('Share', Icons.share, Colors.blueGrey),
      DashboardFeature('Madinah', Icons.location_on, Colors.green.shade700),
      DashboardFeature('Halal Places', Icons.restaurant, Colors.lime),
      DashboardFeature('Language', Icons.language, Colors.lightBlue),
      DashboardFeature(
        'AI Assistant',
        Icons.smart_toy,
        Colors.deepPurpleAccent,
      ),
      DashboardFeature(
        'Meeting with Scholar',
        Icons.people,
        Colors.indigoAccent,
      ),
    ];

    notifyListeners();
  }
}
