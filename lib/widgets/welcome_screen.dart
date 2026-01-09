// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:isa/widgets/prayer_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required Future<Null> Function() onFinish});

  Future<void> _goNext(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingFlow()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'اَلسَّلَامُ عَلَيْكُمْ',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'serif',
                ),
              ),
              const Text(
                'Welcome',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              Expanded(
                child: Center(
                  child: Image.network(
                    'https://i.imgur.com/your_image_link.png',
                    height: 250,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.mosque,
                      size: 150,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),

              // 3. Language Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('English '),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Change Language',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              const Text(
                'Get accurate prayer times and\nqibla directions',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Skip Button
              TextButton(
                onPressed: () => _goNext(context),
                child: const Text('Skip', style: TextStyle(color: Colors.grey)),
              ),

              // Enable Location Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _goNext(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE0E0E0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'Enable Location',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(radius: 4, backgroundColor: Colors.black),
                  SizedBox(width: 8),
                  CircleAvatar(radius: 4, backgroundColor: Colors.grey),
                ],
              ),
              const SizedBox(height: 10),

              TextButton(
                onPressed: () {},
                child: const Text(
                  'Privacy policy',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
