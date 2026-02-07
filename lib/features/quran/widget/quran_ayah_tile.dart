// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AyahTile extends StatelessWidget {
  final int ayahNo;
  final String arabic;
  final String translation;
  final double fontSizeScale;
  final bool isBookmarked;
  final VoidCallback onBookmarkTap;

  const AyahTile({
    super.key,
    required this.ayahNo,
    required this.arabic,
    required this.translation,
    required this.isBookmarked,
    required this.onBookmarkTap,
    this.fontSizeScale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Arabic Text with Star Icon Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== BAM SIDE E YELLOW STAR =====
              GestureDetector(
                onTap: onBookmarkTap,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Icon(
                    isBookmarked
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: isBookmarked
                        ? Colors.amber
                        : Colors.grey.withOpacity(0.3),
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Arabic Ayah
              Expanded(
                child: Text(
                  arabic,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 22 * fontSizeScale,
                    height: 1.8,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1B5E20),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Translation Alignment
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 38,
              ), // Star icon er jayga khali rakhar jonno
              child: Text(
                '$ayahNo. $translation',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 15 * fontSizeScale,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }
}
