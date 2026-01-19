// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

class TasbeehProvider extends ChangeNotifier {
  List<String> tasbeehList = [
    'SubhanAllah',
    'Alhamdulillah',
    'Allahu Akbar',
    'La ilaha illallah',
  ];

  String? selectedTasbeeh;

  int count = 0;
  int target = 33;
  List<Map<String, dynamic>> history = [];

  TasbeehProvider() {
    selectedTasbeeh = tasbeehList.first;
    _loadSampleHistory();
  }

  void _loadSampleHistory() {
    history = [
      {'date': '2026-01-19', 'tasbeeh': 'SubhanAllah', 'count': 33},
      {'date': '2026-01-18', 'tasbeeh': 'Alhamdulillah', 'count': 21},
      {'date': '2026-01-17', 'tasbeeh': 'Allahu Akbar', 'count': 50},
    ];
    notifyListeners();
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

  void setTarget(int t) {
    target = t;
    notifyListeners();
  }
}
