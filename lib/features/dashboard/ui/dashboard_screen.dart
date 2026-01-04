// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/localization/app_localization.dart';
import '../../../widgets/premium_guard.dart';
import '../../quran/ui/quran_screen.dart';
import '../../hadith/ui/hadith_screen.dart';
import '../../history/ui/history_screen.dart';
import '../../ai_assistant/ui/ai_chat_screen.dart';
import '../../prayer_tools/prayer_tools_screen.dart';
import '../../settings/ui/settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final locale = appProvider.locale.languageCode;

    // Main features for dashboard
    final List<_DashboardFeature> features = [
      _DashboardFeature(
        labelKey: 'quran',
        icon: Icons.menu_book,
        color: Colors.green.shade400,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const QuranScreen()),
        ),
      ),
      _DashboardFeature(
        labelKey: 'hadith',
        icon: Icons.book,
        color: Colors.orange.shade400,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HadithScreen()),
        ),
      ),
      _DashboardFeature(
        labelKey: 'islamic_history',
        icon: Icons.history_edu,
        color: Colors.blue.shade400,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const IslamicHistoryScreen()),
        ),
      ),
      _DashboardFeature(
        labelKey: 'ai_assistant',
        icon: Icons.smart_toy,
        color: Colors.purple.shade400,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AIChatScreen()),
        ),
      ),
      _DashboardFeature(
        labelKey: 'prayer_tools',
        icon: Icons.access_time,
        color: Colors.teal.shade400,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PrayerToolsScreen()),
        ),
      ),
      _DashboardFeature(
        labelKey: 'settings',
        icon: Icons.settings,
        color: Colors.grey.shade600,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        ),
      ),
    ];

    return Directionality(
      textDirection: locale == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalization.of(context).translate('dashboard')),
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Premium Banner
              PremiumGuard(
                premiumChild: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    AppLocalization.of(context).translate('premium_active'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                lockedChild: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalization.of(context).translate('free_user'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => appProvider.updatePremiumStatus(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        child: Text(
                          AppLocalization.of(context).translate('go_premium'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Grid Features
              Expanded(
                child: GridView.builder(
                  itemCount: features.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final feature = features[index];
                    return _FeatureCard(feature: feature);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardFeature {
  final String labelKey;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _DashboardFeature({
    required this.labelKey,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _FeatureCard extends StatelessWidget {
  final _DashboardFeature feature;

  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: feature.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: feature.color.withOpacity(0.85),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: feature.color.withOpacity(0.5),
              offset: const Offset(0, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(feature.icon, size: 48, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              AppLocalization.of(context).translate(feature.labelKey),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
