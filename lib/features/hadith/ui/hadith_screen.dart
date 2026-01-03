import 'package:flutter/material.dart';
import 'hadith_reader_screen.dart';

class HadithScreen extends StatelessWidget {
  const HadithScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder topics
    final topics = [
      'Iman',
      'Salah',
      'Sawm',
      'Zakah',
      'Hajj',
      'Akhlaq (Premium)',
      'Family Life (Premium)',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hadith'),
      ),
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          final isPremiumTopic = index >= 5; // example

          return ListTile(
            title: Text(topic),
            trailing: Icon(
              isPremiumTopic ? Icons.lock : Icons.arrow_forward_ios,
              size: 16,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HadithReaderScreen(
                    topic: topic,
                    isPremium: isPremiumTopic,
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
