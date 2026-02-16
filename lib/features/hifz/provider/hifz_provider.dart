import 'package:flutter/material.dart';
import 'package:isa/features/hifz/model/hifz_model.dart';

class HifzProvider extends ChangeNotifier {
  List<HifzEntry> _entries = [];
  List<HifzEntry> _revisionQueue = [];
  
  // Filters
  String _searchQuery = '';
  String _selectedType = 'All';
  String _selectedSurah = 'All';

  // Stats
  int _totalMemorizedAyahs = 0;
  int _currentStreak = 0;
  DateTime? _lastPracticeDate;
  Map<String, int> _progressBySurah = {};

  HifzProvider() {
    _loadSampleData();
  }

  // Getters
  List<HifzEntry> get entries => _entries;
  List<HifzEntry> get revisionQueue => _revisionQueue;
  int get totalMemorizedAyahs => _totalMemorizedAyahs;
  int get currentStreak => _currentStreak;
  String get searchQuery => _searchQuery;
  String get selectedType => _selectedType;
  String get selectedSurah => _selectedSurah;
  Map<String, int> get progressBySurah => _progressBySurah;

  // Filtered entries based on search and filters
  List<HifzEntry> get filteredEntries {
    return _entries.where((entry) {
      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        final matchesSurah = entry.surah.toLowerCase().contains(searchLower);
        final matchesNotes = entry.notes?.toLowerCase().contains(searchLower) ?? false;
        final matchesRange = entry.ayahRange.contains(_searchQuery);
        
        if (!matchesSurah && !matchesNotes && !matchesRange) {
          return false;
        }
      }
      
      // Apply type filter
      if (_selectedType != 'All' && entry.type != _selectedType) {
        return false;
      }
      
      // Apply surah filter
      if (_selectedSurah != 'All' && entry.surah != _selectedSurah) {
        return false;
      }
      
      return true;
    }).toList();
  }

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

  // Get entries by date range
  List<HifzEntry> getByDateRange(DateTime start, DateTime end) {
    return _entries.where((e) => 
      e.date.isAfter(start.subtract(const Duration(days: 1))) && 
      e.date.isBefore(end.add(const Duration(days: 1)))
    ).toList();
  }

  // Get completion rate
  double get completionRate {
    if (_entries.isEmpty) return 0;
    final completed = _entries.where((e) => e.isCompleted).length;
    return completed / _entries.length;
  }

  // Get average rating
  double get averageRating {
    if (_entries.isEmpty) return 0;
    final total = _entries.fold(0, (sum, e) => sum + e.rating);
    return total / _entries.length;
  }

  // Filter methods
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setTypeFilter(String type) {
    _selectedType = type;
    notifyListeners();
  }

  void setSurahFilter(String surah) {
    _selectedSurah = surah;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedType = 'All';
    _selectedSurah = 'All';
    notifyListeners();
  }

  // Add new entry
  void addEntry(HifzEntry entry) {
    _entries.add(entry);
    _updateStats();
    _checkAndUpdateStreak();
    _updateRevisionQueue();
    _updateProgressBySurah();
    notifyListeners();
  }

  // Delete entry
  void deleteEntry(String id) {
    _entries.removeWhere((e) => e.id == id);
    _updateStats();
    _updateRevisionQueue();
    _updateProgressBySurah();
    notifyListeners();
  }

  // Update entry rating
  void updateRating(String id, int newRating) {
    final index = _entries.indexWhere((e) => e.id == id);
    if (index != -1) {
      _entries[index] = _entries[index].copyWith(
        rating: newRating,
        lastReviewedDate: DateTime.now(),
        reviewCount: _entries[index].reviewCount + 1,
      );
      _updateRevisionQueue();
      notifyListeners();
    }
  }

  // Mark as completed
  void toggleCompleted(String id) {
    final index = _entries.indexWhere((e) => e.id == id);
    if (index != -1) {
      _entries[index] = _entries[index].copyWith(
        isCompleted: !_entries[index].isCompleted,
      );
      notifyListeners();
    }
  }

  // Update entry
  void updateEntry(HifzEntry updatedEntry) {
    final index = _entries.indexWhere((e) => e.id == updatedEntry.id);
    if (index != -1) {
      _entries[index] = updatedEntry;
      _updateStats();
      _updateRevisionQueue();
      _updateProgressBySurah();
      notifyListeners();
    }
  }

  // Bulk delete
  void deleteMultiple(List<String> ids) {
    _entries.removeWhere((e) => ids.contains(e.id));
    _updateStats();
    _updateRevisionQueue();
    _updateProgressBySurah();
    notifyListeners();
  }

  // Update stats
  void _updateStats() {
    _totalMemorizedAyahs = _entries.fold(0, (sum, entry) => sum + entry.ayahCount);
  }

  // Update streak
  void _checkAndUpdateStreak() {
    final today = DateTime.now();
    
    if (_entries.isEmpty) {
      _currentStreak = 0;
      _lastPracticeDate = null;
      return;
    }

    // Get the most recent practice date
    final latestEntry = _entries.reduce((a, b) => a.date.isAfter(b.date) ? a : b);
    final latestDate = latestEntry.date;
    
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

  // Update revision queue
  void _updateRevisionQueue() {
    _revisionQueue = _entries
        .where((e) => e.needsRevision && !e.isCompleted)
        .toList()
      ..sort((a, b) => a.rating.compareTo(b.rating));
  }

  // Update progress by surah
  void _updateProgressBySurah() {
    _progressBySurah = {};
    for (var entry in _entries) {
      _progressBySurah[entry.surah] = (_progressBySurah[entry.surah] ?? 0) + entry.ayahCount;
    }
  }

  // Get weekly activity
  Map<DateTime, int> getWeeklyActivity() {
    final today = DateTime.now();
    final weekData = <DateTime, int>{};
    
    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final entriesOnDate = _entries.where((e) =>
        e.date.year == date.year &&
        e.date.month == date.month &&
        e.date.day == date.day
      ).toList();
      
      final totalAyahs = entriesOnDate.fold(0, (sum, e) => sum + e.ayahCount);
      weekData[DateTime(date.year, date.month, date.day)] = totalAyahs;
    }
    
    return weekData;
  }

  // Get statistics
  Map<String, dynamic> getStatistics() {
    return {
      'totalEntries': _entries.length,
      'totalAyahs': _totalMemorizedAyahs,
      'currentStreak': _currentStreak,
      'averageRating': averageRating.toStringAsFixed(1),
      'completionRate': (completionRate * 100).toStringAsFixed(0),
      'revisionNeeded': _revisionQueue.length,
      'newCount': getByType('New').length,
      'sabaqiCount': getByType('Sabaqi').length,
      'manzilCount': getByType('Manzil').length,
      'completedCount': _entries.where((e) => e.isCompleted).length,
    };
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
        notes: "Memorized with tajweed rules",
        rating: 5,
        lastReviewedDate: DateTime.now().subtract(const Duration(days: 2)),
        reviewCount: 1,
      ),
      HifzEntry(
        id: '2',
        surah: "Al-Imran",
        startAyah: 10,
        endAyah: 20,
        type: "Sabaqi",
        date: DateTime.now().subtract(const Duration(days: 1)),
        totalAyahs: 11,
        notes: "Need more practice on verses 15-18",
        rating: 3,
        lastReviewedDate: DateTime.now().subtract(const Duration(days: 1)),
        reviewCount: 2,
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
        lastReviewedDate: DateTime.now(),
        reviewCount: 3,
      ),
      HifzEntry(
        id: '4',
        surah: "Al-Mulk",
        startAyah: 1,
        endAyah: 10,
        type: "New",
        date: DateTime.now().subtract(const Duration(days: 3)),
        totalAyahs: 10,
        notes: "Completed with good fluency",
        rating: 5,
        isCompleted: true,
        lastReviewedDate: DateTime.now().subtract(const Duration(days: 3)),
        reviewCount: 2,
      ),
      HifzEntry(
        id: '5',
        surah: "Ar-Rahman",
        startAyah: 1,
        endAyah: 15,
        type: "Sabaqi",
        date: DateTime.now().subtract(const Duration(days: 5)),
        totalAyahs: 15,
        rating: 2,
        notes: "Need significant revision",
        lastReviewedDate: DateTime.now().subtract(const Duration(days: 5)),
        reviewCount: 1,
      ),
    ];
    
    _updateStats();
    _updateRevisionQueue();
    _updateProgressBySurah();
    _checkAndUpdateStreak();
  }
}