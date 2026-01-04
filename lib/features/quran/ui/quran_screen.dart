import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/localization/app_localization.dart';
import '../../../widgets/premium_guard.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final locale = appProvider.locale.languageCode;

    // Placeholder Surah list
    final surahList = List.generate(114, (index) => 'Surah ${index + 1}');

    return Directionality(
      textDirection: locale == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalization.of(context).translate('quran')),
        ),
        body: ListView.builder(
          itemCount: surahList.length,
          itemBuilder: (context, index) {
            final surah = surahList[index];
            // Surah 6+ are premium

            return PremiumGuard(
              premiumChild: ListTile(
                title: Text(surah),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to Surah reading screen
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Opening $surah...')));
                },
              ),
              lockedChild: ListTile(
                title: Text(surah),
                trailing: const Icon(Icons.lock, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('This Surah is Premium')),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
