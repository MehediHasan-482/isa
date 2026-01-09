// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:isa/features/dashboard/ui/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PremiumSubscriptionScreen extends StatefulWidget {
  const PremiumSubscriptionScreen({super.key});

  @override
  State<PremiumSubscriptionScreen> createState() =>
      _PremiumSubscriptionScreenState();
}

class _PremiumSubscriptionScreenState extends State<PremiumSubscriptionScreen> {
  // কোন প্ল্যানটি সিলেক্ট করা আছে তা ট্র্যাক করার জন্য
  String selectedPlan = 'Yearly';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const SizedBox(), // খালি রাখা হয়েছে
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => _goToDashboard(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ১. লোগো
            Center(
              child: Image.network(
                'https://i.imgur.com/your_logo_link.png', // আপনার লোগো লিঙ্ক
                height: 80,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.mosque, size: 80, color: Colors.orange),
              ),
            ),
            const SizedBox(height: 20),

            // ২. শিরোনাম
            const Text(
              'Focus on your Deen with Quran Majeed Premium',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // ৩. ফিচারের তালিকা (Checkmarks)
            _buildFeatureRow('Enjoy an Ad-Free Experience'),
            _buildFeatureRow('Unlock All Hifz & Tajweed Features'),
            _buildFeatureRow('Access Premium Al Quran Search'),

            const SizedBox(height: 30),

            // ৪. সাবস্ক্রিপশন কার্ডগুলো
            _buildSubscriptionCard(
              title: 'Weekly',
              price: 'BDT 290.00',
              value: 'Weekly',
            ),
            _buildSubscriptionCard(
              title: 'Yearly',
              subtitle: 'Most Popular',
              price: 'BDT 4,200.00',
              value: 'Yearly',
              isPopular: true,
            ),
            _buildSubscriptionCard(
              title: 'Lifetime',
              subtitle: 'Pay once, access forever',
              price: 'BDT 7,000.00',
              value: 'Lifetime',
            ),

            const SizedBox(height: 30),

            // ৫. সাবস্ক্রাইব বাটন
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => _goToDashboard(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE67E22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Subscribe now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ৬. কন্টিনিউ উইথ অ্যাডস
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton(
                onPressed: () => _goToDashboard(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Continue With Ads',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ৭. রিস্টোর সাবস্ক্রিপশন
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Or Tap to restore your paid subscription',
                  style: TextStyle(
                    color: Colors.black54,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// ================= HELPER METHODS =================

  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const Icon(Icons.check, color: Colors.green, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard({
    required String title,
    String? subtitle,
    required String price,
    required String value,
    bool isPopular = false,
  }) {
    bool isSelected = selectedPlan == value;

    return GestureDetector(
      onTap: () => setState(() => selectedPlan = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFE67E22) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: selectedPlan,
              activeColor: const Color(0xFFE67E22),
              onChanged: (val) => setState(() => selectedPlan = val!),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isPopular
                            ? const Color(0xFFE67E22)
                            : Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              price,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _goToDashboard() async {
    // Dashboard এ যাওয়ার আগে SharedPreferences এ firstTime false রাখি
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }
}
