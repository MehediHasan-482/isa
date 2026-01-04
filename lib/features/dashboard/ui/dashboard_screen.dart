import 'package:flutter/material.dart';
import 'package:isa/features/ai_assistant/ui/ai_chat_screen.dart';
import 'package:isa/features/hadith/ui/hadith_screen.dart';
import 'package:isa/features/history/ui/history_screen.dart';
import 'package:isa/features/prayer_tools/prayer_tools_screen.dart';
import 'package:isa/features/quran/ui/quran_screen.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../settings/ui/settings_screen.dart';
import '../../../widgets/premium_guard.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ISA - Islamic Assistant'),
        actions: [
          DropdownButton<String>(
            dropdownColor: Theme.of(context).cardColor,
            underline: const SizedBox(),
            icon: Icon(Icons.menu, color: Theme.of(context).iconTheme.color),
            items:
                <String>[
                  'Dashboard',
                  'Quran',
                  'Hadith',
                  'Islamic History',
                  'AI Assistant',
                  'Prayer Tools',
                  'Settings',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
            onChanged: (String? newValue) {
              if (newValue == null) return;

              switch (newValue) {
                case 'Settings':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                  break;
                case 'Quran':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QuranScreen()),
                  );
                  break;
                case 'Hadith':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HadithScreen()),
                  );
                  break;
                case 'Islamic History':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const IslamicHistoryScreen(),
                    ),
                  );
                  break;
                case 'AI Assistant':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AIChatScreen()),
                  );
                  break;
                case 'Prayer Tools':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PrayerToolsScreen(),
                    ),
                  );
                  break;
                default:
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('$newValue clicked')));
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PremiumGuard(
              premiumChild: const Text(
                'Premium User Access Enabled',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              lockedChild: Column(
                children: [
                  const Text(
                    'Free User Mode',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to subscription page
                      appProvider.updatePremiumStatus(true);
                    },
                    child: const Text('Go Premium'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
