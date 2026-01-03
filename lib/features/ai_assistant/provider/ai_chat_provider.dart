import 'package:flutter/material.dart';

class AIChatProvider extends ChangeNotifier {
  final List<Map<String, String>> _messages = [];

  int freeQuestionsLeft = 3; // Free limit (demo)

  List<Map<String, String>> get messages => _messages;

  void sendMessage(String question, {required bool isPremium}) {
    if (!isPremium && freeQuestionsLeft <= 0) return;

    _messages.add({'role': 'user', 'text': question});

    if (!isPremium) {
      freeQuestionsLeft--;
    }

    /// Dummy AI response (safe placeholder)
    _messages.add({
      'role': 'assistant',
      'text':
          'This is a placeholder Islamic answer.\n'
          'In future, ISA AI will provide authentic answers '
          'with Quran & Hadith references.\n\n'
          '⚠️ For complex fiqh matters, consult a qualified scholar.',
    });

    notifyListeners();
  }
}
