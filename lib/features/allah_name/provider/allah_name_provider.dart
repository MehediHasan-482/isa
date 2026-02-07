import 'package:flutter/material.dart';

class AllahNameProvider extends ChangeNotifier {
  final List<Map<String, String>> allahNames = [
    {
      'arabic': 'الرَّحْمَنُ',
      'transliteration': 'Ar-Rahman',
      'meaning': 'The Most Merciful',
      'virtue': 'Allah’s mercy encompasses all',
    },
    {
      'arabic': 'الرَّحِيمُ',
      'transliteration': 'Ar-Raheem',
      'meaning': 'The Most Compassionate',
      'virtue': 'Special mercy for believers',
    },
    {
      'arabic': 'الْمَلِكُ',
      'transliteration': 'Al-Malik',
      'meaning': 'The King',
      'virtue': 'Recognizing Allah as the only ruler',
    },
  ];

  int selectedIndex = -1;

  void selectName(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
