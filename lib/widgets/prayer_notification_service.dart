// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:isa/widgets/premium_guard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _hasNavigated = false;

  // Name of prayers and their selected state
  final Map<String, bool> _prayerNotifications = {
    'Fajr': true,
    'Zohr': true,
    'Asr': true,
    'Maghrib': true,
    'Isha': true,
  };

  void _nextPage() async {
    if (_hasNavigated) return;

    if (_currentPage < 0) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _hasNavigated = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isFirstTime', false);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PremiumSubscriptionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentPage = index),
        physics: const NeverScrollableScrollPhysics(),
        children: [_buildNotificationPage()],
      ),
    );
  }

  Widget _buildNotificationPage() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Adjust notifications for\neach prayer time',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.transparent,
            child: Icon(Icons.access_time, size: 60, color: Colors.green),
          ),
          const SizedBox(height: 20),

          // Switch for each prayer
          ..._prayerNotifications.keys.map((prayer) {
            return SwitchListTile(
              title: Text(prayer),
              value: _prayerNotifications[prayer]!,
              onChanged: (val) {
                setState(() {
                  _prayerNotifications[prayer] = val;
                });
              },
              activeColor: Colors.green,
            );
          }),

          const Spacer(),
          const Text(
            'You can select different adhan\nvoices and options later',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildActionButton('Enable Notifications', _nextPage),
          _buildPageIndicator(),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE0E0E0),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    final int totalPages = 2;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          totalPages,
          (i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: CircleAvatar(
              radius: 4,
              backgroundColor: i == _currentPage ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
