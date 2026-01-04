import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/prayer_time_provider.dart';

class PrayerTimeScreen extends StatelessWidget {
  const PrayerTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PrayerTimeProvider(),
      child: Consumer<PrayerTimeProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (provider.error != null) {
            return Scaffold(
              body: Center(child: Text(provider.error!)),
            );
          }

          return Scaffold(
            appBar: AppBar(title: const Text('Prayer Times')),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: provider.prayerTimes!.entries.map((entry) {
                return Card(
                  child: ListTile(
                    title: Text(entry.key),
                    trailing: Text(
                      entry.value,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
