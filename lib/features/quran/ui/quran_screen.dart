import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../widgets/premium_guard.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<AppProvider>();

    // Placeholder Surah List
    final surahList = List.generate(114, (index) => 'Surah ${index + 1}');

    return Scaffold(
      appBar: AppBar(title: const Text('Quran')),
      body: ListView.builder(
        itemCount: surahList.length,
        itemBuilder: (context, index) {
          final surah = surahList[index];

          return ListTile(
            title: Text(surah),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AyahReaderScreen(
                    surahName: surah,
                    isPremium: index >= 5, // Example: Surah 6+ are premium
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// =============================
/// Ayah Reading Screen
/// =============================
class AyahReaderScreen extends StatelessWidget {
  final String surahName;
  final bool isPremium;

  const AyahReaderScreen({
    super.key,
    required this.surahName,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    // Placeholder Ayah List
    final ayahList = List.generate(
      114,
      (index) => 'Ayah ${index + 1} text here',
    );

    return Scaffold(
      appBar: AppBar(title: Text(surahName)),
      body: PremiumGuard(
        premiumChild: ListView.builder(
          itemCount: ayahList.length,
          itemBuilder: (context, index) {
            final ayah = ayahList[index];
            return ListTile(
              title: Text(ayah),
              trailing: IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {
                  // Bookmark logic
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Bookmarked $ayah')));
                },
              ),
            );
          },
        ),
        lockedChild: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'This Surah is Premium',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Go Premium / Subscription
                  appProvider.updatePremiumStatus(true); // Dummy for now
                },
                child: const Text('Unlock Premium'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
