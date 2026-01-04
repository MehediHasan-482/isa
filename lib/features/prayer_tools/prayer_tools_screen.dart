import 'package:flutter/material.dart';
import 'package:isa/features/prayer_tools/prayer_time/ui/prayer_time_screen.dart';
import 'package:isa/features/prayer_tools/qibla/ui/qibla_screen.dart';
import 'package:isa/features/prayer_tools/tasbeeh/ui/tasbeeh_screen.dart';
import 'package:isa/features/prayer_tools/prayer_time/provider/prayer_time_provider.dart';
import 'package:provider/provider.dart';

class PrayerToolsScreen extends StatelessWidget {
  const PrayerToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Tools')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _ToolCard(
              title: 'Prayer Time',
              icon: Icons.access_time,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider(
                      create: (_) => PrayerTimeProvider(),
                      child: const PrayerTimeScreen(),
                    ),
                  ),
                );
              },
            ),
            _ToolCard(
              title: 'Qibla',
              icon: Icons.explore,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QiblaScreen()),
                );
              },
            ),
            _ToolCard(
              title: 'Tasbeeh',
              icon: Icons.touch_app,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TasbeehScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ToolCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.shade100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
