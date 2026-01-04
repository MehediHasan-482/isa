// ignore_for_file: use_build_context_synchronously, unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/prayer_time_provider.dart';

class PrayerTimeScreen extends StatefulWidget {
  const PrayerTimeScreen({super.key});

  @override
  State<PrayerTimeScreen> createState() => _PrayerTimeScreenState();
}

class _PrayerTimeScreenState extends State<PrayerTimeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PrayerTimeProvider>().loadPrayerTimes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Time')),
      body: Consumer<PrayerTimeProvider>(
        builder: (_, provider, __) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          if (provider.prayerTimes == null) {
            return const Center(child: Text('No data'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: provider.prayerTimes!.keys.map((prayer) {
              return Card(
                child: ListTile(
                  title: Text(prayer),
                  trailing: Text(provider.getFormattedTime(prayer)),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
