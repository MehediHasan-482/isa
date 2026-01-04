import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/localization/app_localization.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).translate('settings')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Switch
            Text(
              AppLocalization.of(context).translate('theme'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text(
                appProvider.themeMode == ThemeMode.dark
                    ? AppLocalization.of(context).translate('dark')
                    : AppLocalization.of(context).translate('light'),
              ),
              value: appProvider.themeMode == ThemeMode.dark,
              onChanged: (val) => appProvider.toggleTheme(val),
            ),
            const Divider(),

            // Language Switch
            Text(
              AppLocalization.of(context).translate('language'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          ],
        ),
      ),
    );
  }

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
