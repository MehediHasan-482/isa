import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../widgets/premium_guard.dart';

class HadithReaderScreen extends StatelessWidget {
  final String topic;
  final bool isPremium;

  const HadithReaderScreen({
    super.key,
    required this.topic,
    this.isPremium = false,
    required String title,
  });

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    // Placeholder hadith list
    final hadithList = List.generate(
      5,
      (index) => 'Hadith ${index + 1}: Authentic narration text...',
    );

    return Scaffold(
      appBar: AppBar(title: Text(topic)),
      body: PremiumGuard(
        premiumChild: ListView.builder(
          itemCount: hadithList.length,
          itemBuilder: (context, index) {
            final hadith = hadithList[index];

            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(hadith),
                trailing: IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Bookmarked Hadith ${index + 1}')),
                    );
                  },
                ),
              ),
            );
          },
        ),
        lockedChild: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'This Hadith collection is Premium',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  // Dummy premium unlock
                  appProvider.updatePremiumStatus(true);
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
