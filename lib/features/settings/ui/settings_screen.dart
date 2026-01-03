import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Theme Switch
            const Text(
              'Theme',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text(appProvider.themeMode == ThemeMode.dark ? 'Dark' : 'Light'),
              value: appProvider.themeMode == ThemeMode.dark,
              onChanged: (val) {
                appProvider.toggleTheme(val);
              },
            ),
            const Divider(),

            /// Language Switch
            const Text(
              'Language',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                _languageButton(context, 'English', 'en'),
                const SizedBox(width: 10),
                _languageButton(context, 'বাংলা', 'bn'),
                const SizedBox(width: 10),
                _languageButton(context, 'عربى', 'ar'),
              ],
            ),
            const Divider(),

            /// Premium Status
            const Text(
              'Premium Status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(
                appProvider.isPremium ? Icons.workspace_premium : Icons.lock,
                color: appProvider.isPremium ? Colors.amber : Colors.grey,
              ),
              title: Text(appProvider.isPremium ? 'Premium Active' : 'Free User'),
              trailing: !appProvider.isPremium
                  ? ElevatedButton(
                      onPressed: () {
                        // Navigate to subscription page
                      },
                      child: const Text('Go Premium'),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  /// Language Button Widget
  Widget _languageButton(BuildContext context, String label, String code) {
    final appProvider = context.read<AppProvider>();
    final bool selected = appProvider.locale.languageCode == code;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Colors.green : Colors.grey.shade300,
        foregroundColor: selected ? Colors.white : Colors.black,
      ),
      onPressed: () {
        appProvider.changeLanguage(Locale(code));
      },
      child: Text(label),
    );
  }
}
