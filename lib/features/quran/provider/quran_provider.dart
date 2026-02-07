import 'package:flutter/material.dart';

class QuranProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> surahs = [
    {
      'surahNo': 1,
      'name': 'Al-Fatiha',
      'nameArabic': 'الفاتحة',
      'nameMeaning': 'The Opening',
      'revelation': 'Meccan',
      'juz': 1,
      'ayahs': [
        {
          'ayahNo': 1,
          'arabic': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          'translation':
              'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
        },
        {
          'ayahNo': 2,
          'arabic': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
          'translation': '[All] praise is [due] to Allah, Lord of the worlds -',
        },
        {
          'ayahNo': 3,
          'arabic': 'الرَّحْمَٰنِ الرَّحِيمِ',
          'translation': 'The Entirely Merciful, the Especially Merciful,',
        },
        {
          'ayahNo': 4,
          'arabic': 'مَالِكِ يَوْمِ الدِّينِ',
          'translation': 'Sovereign of the Day of Recompense.',
        },
        {
          'ayahNo': 5,
          'arabic': 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
          'translation': 'It is You we worship and You we ask for help.',
        },
        {
          'ayahNo': 6,
          'arabic': 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
          'translation': 'Guide us to the straight path -',
        },
        {
          'ayahNo': 7,
          'arabic':
              'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
          'translation':
              'The path of those upon whom You have bestowed favor, not of those who have evoked [Your] anger or of those who are astray.',
        },
      ],
    },
    {
      'surahNo': 2,
      'name': 'Al-Baqarah',
      'nameArabic': 'البقرة',
      'nameMeaning': 'The Cow',
      'revelation': 'Medinan',
      'juz': 1,
      'ayahs': [
        {'ayahNo': 1, 'arabic': 'الٓمٓ', 'translation': 'Alif, Lam, Meem.'},
        {
          'ayahNo': 2,
          'arabic':
              'ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ',
          'translation':
              'This is the Book about which there is no doubt, a guidance for those conscious of Allah -',
        },
        {
          'ayahNo': 3,
          'arabic':
              'الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ وَيُقِيمُونَ الصَّلَاةَ وَمِمَّا رَزَقْنَاهُمْ يُنفِقُونَ',
          'translation':
              'Who believe in the unseen, establish prayer, and spend out of what We have provided for them,',
        },
        {
          'ayahNo': 4,
          'arabic':
              'وَالَّذِينَ يُؤْمِنُونَ بِمَا أُنزِلَ إِلَيْكَ وَمَا أُنزِلَ مِن قَبْلِكَ وَبِالْآخِرَةِ هُمْ يُوقِنُونَ',
          'translation':
              'And who believe in what has been revealed to you, [O Muhammad], and what was revealed before you, and of the Hereafter they are certain.',
        },
        {
          'ayahNo': 5,
          'arabic':
              'أُولَٰئِكَ عَلَىٰ هُدًى مِّن رَّبِّهِمْ ۖ وَأُولَٰئِكَ هُمُ الْمُفْلِحُونَ',
          'translation':
              'Those are upon [right] guidance from their Lord, and it is those who are the successful.',
        },
        {
          'ayahNo': 6,
          'arabic':
              'إِنَّ الَّذِينَ كَفَرُوا سَوَاءٌ عَلَيْهِمْ أَأَنذَرْتَهُمْ أَمْ لَمْ تُنذِرْهُمْ لَا يُؤْمِنُونَ',
          'translation':
              'Indeed, those who disbelieve - it is all the same for them whether you warn them or do not warn them - they will not believe.',
        },
        {
          'ayahNo': 7,
          'arabic':
              'خَتَمَ اللَّهُ عَلَىٰ قُلُوبِهِمْ وَعَلَىٰ سَمْعِهِمْ ۖ وَعَلَىٰ أَبْصَارِهِمْ غِشَاوَةٌ ۖ وَلَهُمْ عَذَابٌ عَظِيمٌ',
          'translation':
              'Allah has set a seal upon their hearts and upon their hearing, and over their vision is a veil. And for them is a great punishment.',
        },
        {
          'ayahNo': 8,
          'arabic':
              'وَمِنَ النَّاسِ مَن يَقُولُ آمَنَّا بِاللَّهِ وَبِالْيَوْمِ الْآخِرِ وَمَا هُم بِمُؤْمِنِينَ',
          'translation':
              'And of the people are some who say, "We believe in Allah and the Last Day," but they are not believers.',
        },
        {
          'ayahNo': 9,
          'arabic':
              'يُخَادِعُونَ اللَّهَ وَالَّذِينَ آمَنُوا وَمَا يَخْدَعُونَ إِلَّا أَنفُسَهُمْ وَمَا يَشْعُرُونَ',
          'translation':
              'They [think to] deceive Allah and those who believe, but they deceive not except themselves and perceive [it] not.',
        },
        {
          'ayahNo': 10,
          'arabic':
              'فِي قُلُوبِهِم مَّرَضٌ فَزَادَهُمُ اللَّهُ مَرَضًا ۖ وَلَهُمْ عَذَابٌ أَلِيمٌ بِمَا كَانُوا يَكْذِبُونَ',
          'translation':
              'In their hearts is disease, so Allah has increased their disease; and for them is a painful punishment because they [habitually] used to lie.',
        },
        {
          'ayahNo': 255,
          'arabic':
              'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ...',
          'translation':
              'Allah - there is no deity except Him, the Ever-Living, the Sustainer of existence... (Ayatul Kursi)',
        },
        {
          'ayahNo': 285,
          'arabic':
              'آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ وَالْمُؤْمِنُونَ...',
          'translation':
              'The Messenger has believed in what was revealed to him from his Lord, and the believers...',
        },
        {
          'ayahNo': 286,
          'arabic': 'لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا...',
          'translation':
              'Allah does not charge a soul except [with that within] its capacity...',
        },
      ],
    },
    {
      'surahNo': 112,
      'name': 'Al-Ikhlas',
      'nameArabic': 'الإخلاص',
      'nameMeaning': 'Sincerity',
      'revelation': 'Meccan',
      'juz': 30,
      'ayahs': [
        {
          'ayahNo': 1,
          'arabic': 'قُلْ هُوَ اللَّهُ أَحَدٌ',
          'translation': 'Say, "He is Allah, [who is] One.',
        },
        {
          'ayahNo': 2,
          'arabic': 'اللَّهُ الصَّمَدُ',
          'translation': 'Allah, the Eternal Refuge.',
        },
        {
          'ayahNo': 3,
          'arabic': 'لَمْ يَلِدْ وَلَمْ يُولَدْ',
          'translation': 'He neither begets nor is born,',
        },
        {
          'ayahNo': 4,
          'arabic': 'وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ',
          'translation': 'Nor is there to Him any equivalent.',
        },
      ],
    },
  ];

  int currentIndex = 0;

  Map<String, dynamic> get currentSurah => surahs[currentIndex];

  void changeSurah(int index) {
    if (index >= 0 && index < surahs.length) {
      currentIndex = index;
      notifyListeners();
    }
  }

  // provider/quran_provider.dart e thakbe
  final Set<String> _bookmarkedAyahs = {};

  bool isAyahBookmarked(String surahName, int ayahNo) {
    return _bookmarkedAyahs.contains("${surahName}_$ayahNo");
  }

  void toggleBookmark(String surahName, int ayahNo) {
    String key = "${surahName}_$ayahNo";
    if (_bookmarkedAyahs.contains(key)) {
      _bookmarkedAyahs.remove(key);
    } else {
      _bookmarkedAyahs.add(key);
    }
    notifyListeners();
  }

  // provider/quran_provider.dart file e add koro
  List<Map<String, dynamic>> get allBookmarkedAyahs {
    List<Map<String, dynamic>> bookmarks = [];

    for (var surah in surahs) {
      for (var ayah in surah['ayahs']) {
        if (isAyahBookmarked(surah['name'], ayah['ayahNo'])) {
          bookmarks.add({'surahName': surah['name'], 'ayah': ayah});
        }
      }
    }
    return bookmarks;
  }

  // provider/quran_provider.dart
  void goToAyah(String surahName, int ayahIndex) {
    // Jodi user onno kono surah te thake, tobe age surah change korte hobe
    int targetSurahIndex = surahs.indexWhere((s) => s['name'] == surahName);
    if (targetSurahIndex != -1) {
      changeSurah(targetSurahIndex);
    }
  }
}
