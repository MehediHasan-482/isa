import 'package:flutter/material.dart';
import 'history_reader_screen.dart';

class IslamicHistoryScreen extends StatelessWidget {
  const IslamicHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyList = [
      {'title': 'Life of Prophet Muhammad ﷺ', 'premium': false},
      {'title': 'Khulafa-e-Rashideen', 'premium': false},
      {'title': 'Umayyad Caliphate', 'premium': true},
      {'title': 'Abbasid Golden Age', 'premium': true},
      {'title': 'Great Islamic Scholars', 'premium': true},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Islamic History'),
      ),
      body: ListView.builder(
        itemCount: historyList.length,
        itemBuilder: (context, index) {
          final item = historyList[index];

          return ListTile(
            title: Text(item['title'] as String),
            trailing: Icon(
              item['premium'] as bool ? Icons.lock : Icons.arrow_forward_ios,
              size: 16,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HistoryReaderScreen(
                    title: item['title'] as String,
                    isPremium: item['premium'] as bool,
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
