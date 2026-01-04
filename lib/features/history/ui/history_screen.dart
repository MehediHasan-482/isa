import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/localization/app_localization.dart';
import '../../../widgets/premium_guard.dart';
import '../../hadith/ui/hadith_reader_screen.dart';

class IslamicHistoryScreen extends StatelessWidget {
  const IslamicHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final locale = appProvider.locale.languageCode;

    // Placeholder history list
    final historyList = [
      {'title': 'Life of Prophet Muhammad ﷺ', 'premium': false},
      {'title': 'Khulafa-e-Rashideen', 'premium': false},
      {'title': 'Umayyad Caliphate', 'premium': true},
      {'title': 'Abbasid Golden Age', 'premium': true},
      {'title': 'Great Islamic Scholars', 'premium': true},
    ];

    return Directionality(
      textDirection: locale == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalization.of(context).translate('islamic_history')),
        ),
        body: ListView.builder(
          itemCount: historyList.length,
          itemBuilder: (context, index) {
            final item = historyList[index];

            return PremiumGuard(
              premiumChild: ListTile(
                title: Text(item['title'] as String),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HadithReaderScreen(
                        topic: item['title'] as String,
                        isPremium: false, // already unlocked
                        title: item['title'] as String,
                      ),
                    ),
                  );
                },
              ),
              lockedChild: ListTile(
                title: Text(item['title'] as String),
                trailing: const Icon(Icons.lock, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalization.of(
                          context,
                        ).translate('premium_content'),
                      ),
                    ),
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
