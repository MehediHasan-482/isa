import 'package:flutter/material.dart';

class TasbeehProvider extends ChangeNotifier {
  /// Tasbeeh + Dua lines (LONG CONTENT for scroll test)
  final Map<String, List<String>> duaLines = {
    'SubhanAllah': [
      'سُبْحَانَ ٱللَّٰهِ',
      'SubhanAllah',
      'অর্থ: আল্লাহ পবিত্র',

      'سُبْحَانَ ٱللَّٰهِ وَبِحَمْدِهِ',
      'SubhanAllahi wa bihamdihi',
      'অর্থ: আমি আল্লাহর পবিত্রতা ও প্রশংসা ঘোষণা করছি',

      'سُبْحَانَ ٱللَّٰهِ ٱلْعَظِيمِ',
      'SubhanAllahil Azim',
      'অর্থ: মহান আল্লাহ পবিত্র',

      'হাদিস:',
      'যে ব্যক্তি দিনে ১০০ বার SubhanAllah পড়ে',
      'তার গুনাহ মাফ করে দেওয়া হয়',

      'ফজিলত:',
      'এই যিকির আল্লাহর কাছে খুব প্রিয়',
      'এতে অন্তর শান্ত হয়',
      'রিজিক বৃদ্ধি পায়',
    ],

    'Alhamdulillah': [
      'ٱلْحَمْدُ لِلَّٰهِ رَبِّ ٱلْعَٰلَمِينَ',
      'Alhamdulillahi Rabbil Alamin',
      'অর্থ: সমস্ত প্রশংসা আল্লাহর',

      'ٱلْحَمْدُ لِلَّٰهِ حَمْدًا كَثِيرًا',
      'অর্থ: অনেক বেশি প্রশংসা আল্লাহর',

      'হাদিস:',
      'আলহামদুলিল্লাহ মিজানের পাল্লা ভারী করে',

      'ফজিলত:',
      'নিয়ামতের শুকরিয়া আদায় হয়',
      'অন্তরে তৃপ্তি আসে',
      'আল্লাহ সন্তুষ্ট হন',

      'এই যিকির সকাল ও সন্ধ্যায় পড়া উত্তম',
      'নামাজের পরে পড়া সুন্নত',
    ],

    'Allahu Akbar': [
      'ٱللَّٰهُ أَكْبَرُ',
      'Allahu Akbar',
      'অর্থ: আল্লাহ মহান',

      'ٱللَّٰهُ أَكْبَرُ كَبِيرًا',
      'Allahu Akbaru Kabira',
      'অর্থ: আল্লাহ অত্যন্ত মহান',

      'ফজিলত:',
      'আল্লাহর মহত্ব স্মরণ হয়',
      'ভয় দূর হয়',
      'ইমান মজবুত হয়',

      'হাদিস:',
      'এই যিকির জান্নাতের দরজা খুলে দেয়',

      'নামাজের পরে ৩৪ বার পড়া সুন্নত',
    ],

    'La ilaha illallah': [
      'لَا إِلٰهَ إِلَّا ٱللَّٰهُ',
      'La ilaha illallah',
      'অর্থ: আল্লাহ ছাড়া কোনো উপাস্য নেই',

      'لَا إِلٰهَ إِلَّا ٱللَّٰهُ وَحْدَهُ',
      'অর্থ: আল্লাহ এক, তাঁর কোনো শরিক নেই',

      'ফজিলত:',
      'এই কালেমা জান্নাতের চাবি',
      'সবচেয়ে উত্তম যিকির',

      'হাদিস:',
      'এই কালেমা পড়লে গুনাহ ঝরে যায়',

      'মৃত্যুর সময় এই কালেমা পড়া সৌভাগ্যের লক্ষণ',
    ],
  };

  late List<String> tasbeehList;
  String? selectedTasbeeh;

  int count = 0;
  int target = 33;

  List<Map<String, dynamic>> history = [];

  TasbeehProvider() {
    tasbeehList = duaLines.keys.toList();
    selectedTasbeeh = tasbeehList.first;
  }

  void selectTasbeeh(String tasbeeh) {
    selectedTasbeeh = tasbeeh;
    count = 0;
    notifyListeners();
  }

  void increment() {
    if (count < target) {
      count++;
      notifyListeners();
    }
  }

  void reset() {
    count = 0;
    notifyListeners();
  }

  void saveToday() {
    history.add({
      'date': DateTime.now().toString().split(' ')[0],
      'tasbeeh': selectedTasbeeh,
      'count': count,
    });
    notifyListeners();
  }
}
