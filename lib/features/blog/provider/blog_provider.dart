import 'package:flutter/material.dart';

class BlogProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _blogs = [
    {
      'id': '1',
      'title': 'আর-রহমান নামের ফজিলত',
      'content': '''
আর-রহমান আল্লাহ তায়ালার ৯৯টি সুন্দর নামের অন্যতম। এই নামের অর্থ “পরম করুণাময়”।
ফজিলত:
১. আল্লাহর রহমত নাযিল হয়
২. অন্তর নরম হয়
৩. দয়ার গুণ বৃদ্ধি পায়

দোয়া: ইয়া রহমান, ইয়া রহিম
      ''',
      'language': 'bn',
      'author': 'ইসলামিক স্কলার',
      'authorId': 'admin_001',
      'authorImage': 'assets/images/kaba1.jpg',
      'publishDate': '2024-01-15',
      'category': 'name_explanations',
      'tags': ['রহমান', 'ফজিলত', 'আল্লাহ'],
      'image': 'assets/images/image.jpg',
      'likes': 120,
      'comments': 25,
      'views': 1500,
      'isFeatured': true,
    },
    {
      'id': '2',
      'title': 'The Importance of Daily Du’a',
      'content': '''
Du’a is one of the greatest acts of worship in Islam. It connects a servant directly with Allah.

Benefits:
• Strengthens faith
• Brings peace to the heart
• Increases reliance on Allah
      ''',
      'language': 'en',
      'author': 'Islamic Scholar',
      'authorId': 'admin_002',
      'authorImage': 'assets/images/kaba1.jpg',
      'publishDate': '2024-01-14',
      'category': 'dua',
      'tags': ['dua', 'prayer', 'islam'],
      'image': null,
      'likes': 95,
      'comments': 18,
      'views': 1100,
      'isFeatured': false,
    },
    {
      'id': '3',
      'title': 'فضل الذكر في حياة المسلم',
      'content': '''
الذكر من أعظم العبادات التي تقرب العبد إلى الله. به تطمئن القلوب وتزكو النفوس.

فوائده:
١. طمأنينة القلب
٢. مغفرة الذنوب
٣. رفعة الدرجات
      ''',
      'language': 'ar',
      'author': 'الشيخ عبد الله',
      'authorId': 'admin_003',
      'authorImage': 'assets/images/kaba1.jpg',
      'publishDate': '2024-01-13',
      'category': 'spiritual_guidance',
      'tags': ['ذكر', 'عبادة', 'الإسلام'],
      'image': 'assets/images/image2.jpg',
      'likes': 210,
      'comments': 40,
      'views': 2300,
      'isFeatured': true,
    },
  ];

  List<Map<String, dynamic>> _filteredBlogs = [];
  String _searchQuery = '';
  String _selectedCategory = 'all';

  BlogProvider() {
    _filteredBlogs = List.from(_blogs);
  }

  List<Map<String, dynamic>> get blogs => _filteredBlogs;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;


  void searchBlogs(String query) {
    _searchQuery = query.trim();
    _applyFilters();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredBlogs = _blogs.where((blog) {
      final matchesCategory =
          _selectedCategory == 'all' || blog['category'] == _selectedCategory;
      final matchesSearch =
          _searchQuery.isEmpty ||
          blog['title'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          blog['author'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          blog['content'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

      return matchesCategory && matchesSearch;
    }).toList();

    notifyListeners();
  }

  void likeBlog(String blogId) {
    final index = _blogs.indexWhere((b) => b['id'] == blogId);
    if (index != -1) {
      _blogs[index]['likes'] = (_blogs[index]['likes'] ?? 0) + 1;
      _applyFilters();
    }
  }

  // Comment Increment
  void addComment(String blogId) {
    final index = _blogs.indexWhere((b) => b['id'] == blogId);
    if (index != -1) {
      _blogs[index]['comments'] = (_blogs[index]['comments'] ?? 0) + 1;
      _applyFilters();
    }
  }

  // New Blog Add logic
  void addNewBlog(Map<String, dynamic> newBlog) {
    final fullBlog = {
      ...newBlog,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'publishDate': DateTime.now().toIso8601String(),
      'likes': 0,
      'comments': 0,
      'views': 0,
      'isFeatured': false,
    };

    _blogs.insert(0, fullBlog);
    _applyFilters();
  }

  Future<void> saveBlog(Map<String, dynamic> blogData) async {
    try {
      final index = _blogs.indexWhere((blog) => blog['id'] == blogData['id']);

      if (index != -1) {
        _blogs[index] = blogData;
      } else {
        _blogs.insert(0, blogData);
      }

      notifyListeners();

    } catch (e) {
      print('Error saving blog: $e');
    }
  }

  Future<void> deleteBlog(String blogId) async {
    try {
      _blogs.removeWhere((blog) => blog['id'] == blogId);
      notifyListeners();
    } catch (e) {
      print('Error deleting blog: $e');
    }
  }

  // Add this method to get blog by ID
  Map<String, dynamic>? getBlogById(String blogId) {
    try {
      return _blogs.firstWhere((blog) => blog['id'] == blogId);
    } catch (e) {
      return null;
    }
  }
}
