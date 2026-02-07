import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/quran_provider.dart';
import '../widget/quran_ayah_tile.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F4),
      appBar: AppBar(
        title: const Text(
          "My Bookmarks",
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
            ),
          ),
        ),
      ),
      body: Consumer<QuranProvider>(
        builder: (context, provider, _) {
          final bookmarks = provider.allBookmarkedAyahs;

          if (bookmarks.isEmpty) {
            return const Center(child: Text("No bookmarks added yet."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final item = bookmarks[index];
              final ayah = item['ayah'];
              final surahName = item['surahName'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Surah Name Header
                  Text(
                    surahName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  AyahTile(
                    ayahNo: ayah['ayahNo'],
                    arabic: ayah['arabic'],
                    translation: ayah['translation'],
                    isBookmarked:
                        true, // Bookmark screen e asha mane eita bookmarked
                    onBookmarkTap: () {
                      provider.toggleBookmark(surahName, ayah['ayahNo']);
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
