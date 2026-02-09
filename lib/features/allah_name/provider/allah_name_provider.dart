// lib/features/allah_name/provider/allah_name_provider.dart
import 'package:flutter/material.dart';

class AllahNameProvider extends ChangeNotifier {
  final List<Map<String, String>> allahNames = [
    {
      'arabic': 'الرَّحْمَنُ',
      'transliteration': 'Ar-Rahman',
      'meaning': 'The Most Merciful',
      'virtue': 'Allah’s mercy encompasses all',
      'category': 'Mercy',
    },
    {
      'arabic': 'الرَّحِيمُ',
      'transliteration': 'Ar-Raheem',
      'meaning': 'The Most Compassionate',
      'virtue': 'Special mercy for believers',
      'category': 'Mercy',
    },
    {
      'arabic': 'الْمَلِكُ',
      'transliteration': 'Al-Malik',
      'meaning': 'The King',
      'virtue': 'The absolute Sovereign Lord',
      'category': 'Power',
    },
    {
      'arabic': 'الْقُدُّوسُ',
      'transliteration': 'Al-Quddus',
      'meaning': 'The Pure',
      'virtue': 'The One who is free from all imperfections',
      'category': 'Perfection',
    },
    {
      'arabic': 'السَّلَامُ',
      'transliteration': 'As-Salam',
      'meaning': 'The Source of Peace',
      'virtue': 'The One who grants peace and security',
      'category': 'Peace',
    },
    {
      'arabic': 'الْمُؤْمِنُ',
      'transliteration': 'Al-Mu’min',
      'meaning': 'The Giver of Faith',
      'virtue': 'The One who bestows faith and protection',
      'category': 'Protection',
    },
    {
      'arabic': 'الْمُهَيْمِنُ',
      'transliteration': 'Al-Muhaymin',
      'meaning': 'The Guardian',
      'virtue': 'The Protector and Overseer of all things',
      'category': 'Protection',
    },
    {
      'arabic': 'الْعَزِيزُ',
      'transliteration': 'Al-Aziz',
      'meaning': 'The Almighty',
      'virtue': 'The Victorious and Unconquerable',
      'category': 'Power',
    },
    {
      'arabic': 'الْجَبَّارُ',
      'transliteration': 'Al-Jabbar',
      'meaning': 'The Compeller',
      'virtue': 'The Restorer and the Repairer of hearts',
      'category': 'Power',
    },
    {
      'arabic': 'الْمُتَكَبِّرُ',
      'transliteration': 'Al-Mutakabbir',
      'meaning': 'The Supreme',
      'virtue': 'The One who reveals His Greatness',
      'category': 'Greatness',
    },
    {
      'arabic': 'الْخَالِقُ',
      'transliteration': 'Al-Khaliq',
      'meaning': 'The Creator',
      'virtue': 'The One who brings things from non-existence',
      'category': 'Creation',
    },
    {
      'arabic': 'الْبَارِئُ',
      'transliteration': 'Al-Bari\'',
      'meaning': 'The Evolver',
      'virtue': 'The One who designs and proportions creation',
      'category': 'Creation',
    },
    {
      'arabic': 'الْمُصَوِّرُ',
      'transliteration': 'Al-Musawwir',
      'meaning': 'The Fashioner',
      'virtue': 'The Bestower of forms and uniqueness',
      'category': 'Creation',
    },
    {
      'arabic': 'الْغَفَّارُ',
      'transliteration': 'Al-Ghaffar',
      'meaning': 'The Forgiving',
      'virtue': 'The One who forgives repeatedly',
      'category': 'Mercy',
    },
    {
      'arabic': 'الْقَهَّارُ',
      'transliteration': 'Al-Qahhar',
      'meaning': 'The Subduer',
      'virtue': 'The One who prevails over everything',
      'category': 'Power',
    },
    {
      'arabic': 'الْوَهَّابُ',
      'transliteration': 'Al-Wahhab',
      'meaning': 'The Bestower',
      'virtue': 'The One who gives without limit',
      'category': 'Generosity',
    },
    {
      'arabic': 'الرَّزَّاقُ',
      'transliteration': 'Ar-Razzaq',
      'meaning': 'The Provider',
      'virtue': 'The One who provides for all creation',
      'category': 'Provision',
    },
    {
      'arabic': 'الْفَتَّاحُ',
      'transliteration': 'Al-Fattah',
      'meaning': 'The Opener',
      'virtue': 'The One who opens the doors of mercy',
      'category': 'Mercy',
    },
    {
      'arabic': 'الْعَلِيمُ',
      'transliteration': 'Al-Alim',
      'meaning': 'The All-Knowing',
      'virtue': 'The One who knows everything, open or secret',
      'category': 'Knowledge',
    },
    {
      'arabic': 'الْقَابِضُ',
      'transliteration': 'Al-Qabid',
      'meaning': 'The Withholder',
      'virtue': 'The One who restrains or restricts provision',
      'category': 'Power',
    },
  ];

  int selectedIndex = -1;
  List<Map<String, String>> _filteredNames = [];
  String _searchQuery = '';
  bool _isSearching = false;

  AllahNameProvider() {
    _filteredNames = allahNames;
  }

  void selectName(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  // Get related names by category
  List<Map<String, String>> getRelatedNames(Map<String, String> name) {
    final category = name['category'];
    return allahNames
        .where(
          (n) => n['category'] == category && n['arabic'] != name['arabic'],
        )
        .take(3) // Show only 3 related names
        .toList();
  }

  // Search functionality
  void searchNames(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredNames = allahNames;
    } else {
      _filteredNames = allahNames.where((name) {
        final arabic = name['arabic']!.toLowerCase();
        final transliteration = name['transliteration']!.toLowerCase();
        final meaning = name['meaning']!.toLowerCase();
        final queryLower = query.toLowerCase();

        return arabic.contains(queryLower) ||
            transliteration.contains(queryLower) ||
            meaning.contains(queryLower);
      }).toList();
    }
    notifyListeners();
  }

  void toggleSearch(bool isSearching) {
    _isSearching = isSearching;
    if (!isSearching) {
      _searchQuery = '';
      _filteredNames = allahNames;
    }
    notifyListeners();
  }

  // Getters
  List<Map<String, String>> get displayedNames => _filteredNames;
  String get searchQuery => _searchQuery;
  bool get isSearching => _isSearching;
}
