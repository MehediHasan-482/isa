import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/localization/app_localization.dart';
import 'hadith_reader_screen.dart';

class HadithScreen extends StatelessWidget {
  const HadithScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final locale = appProvider.locale.languageCode;

    final topics = [
      'Iman',
      'Salah',
      'Sawm',
      'Zakah',
      'Hajj',
      'Akhlaq (Premium)',
      'Family Life (Premium)',
    ];

    return Directionality(
      textDirection: locale == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalization.of(context).translate('hadith')),
        ),
        body: ListView.builder(
          itemCount: topics.length,
          itemBuilder: (context, index) {
            final topic = topics[index];
            final isPremium = index >= 5;

            return ListTile(
              title: Text(topic),
              trailing: Icon(
                isPremium ? Icons.lock : Icons.arrow_forward_ios,
                size: 16,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HadithReaderScreen(
                      topic: topic,
                      isPremium: isPremium,
                      title: '',
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
