// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:isa/core/providers/feature_provider.dart';
import 'package:isa/features/prayer_time/provider/prayer_time_provider.dart';
import 'package:isa/features/qibla/ui/qibla_screen.dart';
import 'package:isa/features/tasbeeh/ui/tasbeeh_screen.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      // Load prayer times using current device location
      context.read<PrayerTimeProvider>().loadPrayerTimes();

      // Load features from provider
      context.read<FeaturesProvider>().loadFeatures();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final features = context.watch<FeaturesProvider>().features;
    final prayerProvider = context.watch<PrayerTimeProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, appProvider, prayerProvider),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 240,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(children: _buildFeatureColumns(features)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildJourneyCard(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppProvider appProvider,
    PrayerTimeProvider prayerProvider,
  ) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2E7D32), Color(0xFF141414)],
        ),
      ),
      padding: const EdgeInsets.only(top: 40, bottom: 20, left: 16, right: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!appProvider.isPremium)
                GestureDetector(
                  onTap: () => appProvider.updatePremiumStatus(true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: const Text(
                      'Go Premium',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              else
                const Icon(Icons.verified, color: Colors.amber, size: 20),
              const SizedBox(width: 12),
              const Icon(Icons.search, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              const Icon(
                Icons.notifications_none,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              const CircleAvatar(
                radius: 14,
                backgroundColor: Colors.orange,
                child: Icon(Icons.person, size: 18, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            prayerProvider.currentPrayerName.substring(
              0,
              prayerProvider.currentPrayerName.length > 8
                  ? prayerProvider.currentPrayerName.length - 8
                  : 0,
            ),
            style: const TextStyle(color: Colors.white70, fontSize: 18),
          ),
          Text(
            prayerProvider.currentPrayerTime,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 44,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prayerProvider.hijriDate,
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                  Text(
                    prayerProvider.gregorianDate,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${prayerProvider.currentPrayerName} ",
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                  Text(
                    prayerProvider.remainingTime,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFeatureColumns(List<DashboardFeature> features) {
    List<Widget> columns = [];
    for (int i = 0; i < features.length; i += 2) {
      columns.add(
        Column(
          children: [
            _FeatureItem(feature: features[i]),
            const SizedBox(height: 10),
            if (i + 1 < features.length) _FeatureItem(feature: features[i + 1]),
          ],
        ),
      );
      columns.add(const SizedBox(width: 10));
    }
    return columns;
  }

  Widget _buildJourneyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: const [
          Icon(Icons.auto_stories, color: Colors.green, size: 40),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Daily Quran Journey",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Continue your streak",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 18),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final DashboardFeature feature;
  const _FeatureItem({required this.feature});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (feature.label) {
          case 'Qibla':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QiblaScreen()),
            );
            break;
          // case 'Quran':
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (_) => const QuranScreen()),
          //   );
          //   break;
          // case 'Hifz':
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (_) => const HifzScreen()),
          //   );
          //   break;
          case 'Tasbeeh':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TasbeehScreen()),
            );
            break;
          // case 'Learn Tajweed':
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (_) => const LearnTajweedScreen()),
          //   );
          //   break;
          // case 'Allah Names':
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (_) => const AllahNamesScreen()),
          //   );
          //   break;
          // case 'Blog':
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (_) => const BlogScreen()),
          //   );
          //   break;
          // case 'Visual Quran':
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (_) => const VisualQuranScreen()),
          //   );
          //   break;
          // case 'Makkah':
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (_) => const MakkahScreen()),
          //   );
          //   break;
          // case 'Masjid Finder':
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (_) => const MasjidFinderScreen()),
          //   );
          //   break;
          // case 'Halal Places':
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (_) => const HalalPlacesScreen()),
          //   );
          //   break;
          // case 'Prayer Times':
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (_) => const PrayerTimesScreen()),
          //   );
          //   break;
          // case 'AI Assistant':
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (_) => const AIAssistantScreen()),
          //   );
          //break;
          // Add more features here
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${feature.label} page not ready yet!')),
            );
        }
      },
      child: SizedBox(
        width: 85,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: feature.color.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFF1E1E1E),
                child: Icon(feature.icon, color: feature.color, size: 28),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              feature.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
