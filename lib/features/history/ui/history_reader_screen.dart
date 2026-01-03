import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../widgets/premium_guard.dart';

class HistoryReaderScreen extends StatelessWidget {
  final String title;
  final bool isPremium;

  const HistoryReaderScreen({
    super.key,
    required this.title,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: PremiumGuard(
        premiumChild: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Text(
              '''
$title

This is a detailed Islamic historical article.
Here you can include:
• Timeline
• Events
• Key figures
• Lessons from history

(Placeholder content – will be replaced by real data / PDF / API)
''',
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
          ),
        ),
        lockedChild: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 60, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'This detailed history is Premium',
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
