import 'package:flutter/material.dart';
import 'package:isa/features/hifz/model/hifz_model.dart';

class HifzProvider extends ChangeNotifier {
  List<HifzEntry> _entries = [];
  List<HifzEntry> _revisionQueue = [];

  // Stats
  int _totalMemorizedAyahs = 0;
  int _currentStreak = 0;
  DateTime? _lastPracticeDate;

  HifzProvider() {
    _loadSampleData();
  }

  List<HifzEntry> get entries => _entries;
  List<HifzEntry> get revisionQueue => _revisionQueue;
  int get totalMemorizedAyahs => _totalMemorizedAyahs;
  int get currentStreak => _currentStreak;

  // Get today's entries
  List<HifzEntry> get todayEntries {
    final today = DateTime.now();
    return _entries.where((e) => 
      e.date.year == today.year &&
      e.date.month == today.month &&
      e.date.day == today.day
    ).toList();
  }

  // Get entries by type
  List<HifzEntry> getByType(String type) {
    return _entries.where((e) => e.type == type).toList();
  }

  // Get entries by surah
  List<HifzEntry> getBySurah(String surah) {
    return _entries.where((e) => e.surah == surah).toList();
  }

  // Add new entry
  void addEntry(HifzEntry entry) {
    _entries.add(entry);
    _updateStats();
    _checkAndUpdateStreak();
    _updateRevisionQueue();
    notifyListeners();
  }

  // Delete entry
  void deleteEntry(String id) {
    _entries.removeWhere((e) => e.id == id);
    _updateStats();
    _updateRevisionQueue();
    notifyListeners();
  }

  // Update entry rating
  void updateRating(String id, int newRating) {
    final index = _entries.indexWhere((e) => e.id == id);
    if (index != -1) {
      final oldEntry = _entries[index];
      _entries[index] = HifzEntry(
        id: oldEntry.id,
        surah: oldEntry.surah,
        startAyah: oldEntry.startAyah,
        endAyah: oldEntry.endAyah,
        type: oldEntry.type,
        date: oldEntry.date,
        totalAyahs: oldEntry.totalAyahs,
        notes: oldEntry.notes,
        rating: newRating,
        isCompleted: oldEntry.isCompleted,
      );
      notifyListeners();
    }
  }

  // Mark as completed
  void toggleCompleted(String id) {
    final index = _entries.indexWhere((e) => e.id == id);
    if (index != -1) {
      final oldEntry = _entries[index];
      _entries[index] = HifzEntry(
        id: oldEntry.id,
        surah: oldEntry.surah,
        startAyah: oldEntry.startAyah,
        endAyah: oldEntry.endAyah,
        type: oldEntry.type,
        date: oldEntry.date,
        totalAyahs: oldEntry.totalAyahs,
        notes: oldEntry.notes,
        rating: oldEntry.rating,
        isCompleted: !oldEntry.isCompleted,
      );
      notifyListeners();
    }
  }

  // Update stats
  void _updateStats() {
    _totalMemorizedAyahs = _entries.fold(0, (sum, entry) => sum + entry.ayahCount);
  }

  // Update streak
  void _checkAndUpdateStreak() {
    final today = DateTime.now();
    
    if (_lastPracticeDate == null) {
      _currentStreak = 1;
    } else {
      final difference = today.difference(_lastPracticeDate!).inDays;
      
      if (difference == 1) {
        _currentStreak++;
      } else if (difference > 1) {
        _currentStreak = 1;
      }
    }
    
    _lastPracticeDate = today;
  }

  // Update revision queue (entries with rating < 4)
  void _updateRevisionQueue() {
    _revisionQueue = _entries.where((e) => e.rating < 4 && !e.isCompleted).toList();
  }

  // Get progress by Juz (simplified for now)
  Map<int, int> getProgressByJuz() {
    // This would need actual Juz mapping
    return {};
  }

  // Load sample data
  void _loadSampleData() {
    _entries = [
      HifzEntry(
        id: '1',
        surah: "Al-Baqarah",
        startAyah: 1,
        endAyah: 5,
        type: "New",
        date: DateTime.now().subtract(const Duration(days: 2)),
        totalAyahs: 5,
        rating: 5,
      ),
      HifzEntry(
        id: '2',
        surah: "Al-Imran",
        startAyah: 10,
        endAyah: 20,
        type: "Sabaqi",
        date: DateTime.now().subtract(const Duration(days: 1)),
        totalAyahs: 11,
        rating: 3,
      ),
      HifzEntry(
        id: '3',
        surah: "Ya-Sin",
        startAyah: 1,
        endAyah: 10,
        type: "Manzil",
        date: DateTime.now(),
        totalAyahs: 10,
        rating: 4,
      ),
    ];
    
    _updateStats();
    _updateRevisionQueue();
  }
}