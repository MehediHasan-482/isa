// lib/features/allah_name/screen/allah_names_screen.dart
// ignore_for_file: deprecated_member_use, use_build_context_synchronously, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:isa/features/allah_name/provider/allah_name_provider.dart';
import 'package:provider/provider.dart';

class AllahNamesScreen extends StatefulWidget {
  const AllahNamesScreen({super.key});

  @override
  State<AllahNamesScreen> createState() => _AllahNamesScreenState();
}

class _AllahNamesScreenState extends State<AllahNamesScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AllahNameProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      appBar: AppBar(
        title: provider.isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search names...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white, fontSize: 18),
                onChanged: (query) {
                  provider.searchNames(query);
                },
              )
            : const Text(
                'Asmaul Husna',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0C3B2E), Color(0xFF1B5E20), Color(0xFF2E7D32)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
        actions: [
          IconButton(
            icon: Icon(provider.isSearching ? Icons.close : Icons.search),
            onPressed: () {
              if (provider.isSearching) {
                _searchController.clear();
              }
              provider.toggleSearch(!provider.isSearching);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            // Search results info
            if (provider.searchQuery.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Found ${provider.displayedNames.length} results for "${provider.searchQuery}"',
                  style: const TextStyle(
                    color: Color(0xFF0C3B2E),
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            // Grid view
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: provider.displayedNames.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.92,
                ),
                itemBuilder: (context, index) {
                  final name = provider.displayedNames[index];
                  final originalIndex = provider.allahNames.indexOf(name);
                  final isSelected = provider.selectedIndex == originalIndex;

                  return AnimatedScale(
                    duration: const Duration(milliseconds: 200),
                    scale: isSelected ? 0.96 : 1.0,
                    child: GestureDetector(
                      onTap: () {
                        provider.selectName(originalIndex);
                        _showDetails(context, name);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isSelected
                                ? [
                                    const Color(0xFF0C3B2E),
                                    const Color(0xFF1B5E20),
                                  ]
                                : [Colors.white, const Color(0xFFF1F8F1)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? const Color(0xFF0C3B2E).withOpacity(0.3)
                                  : Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color: isSelected
                                ? Colors.white.withOpacity(0.2)
                                : Colors.green.shade100,
                            width: 1.5,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                // Arabic Name Box
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.white.withOpacity(0.12)
                                          : const Color(
                                              0xFF0C3B2E,
                                            ).withOpacity(0.06),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Text(
                                        name['arabic']!,
                                        style: TextStyle(
                                          fontSize: name['arabic']!.length > 8
                                              ? 22
                                              : 28,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Colors.white
                                              : const Color(0xFF0C3B2E),
                                          fontFamily: 'NotoNaskhArabic',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Transliteration
                                Text(
                                  name['transliteration']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF1B5E20),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                // Meaning
                                Text(
                                  name['meaning']!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isSelected
                                        ? Colors.white70
                                        : Colors.black54,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                // Index Badge Container
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.white24
                                        : Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Index Number
                                      Text(
                                        '${originalIndex + 1}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.green.shade900,
                                        ),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          _showComingSoonSnackbar(context);
                                        },
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          margin: const EdgeInsets.only(
                                            left: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Colors.white.withOpacity(0.25)
                                                : Colors.green.shade100,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isSelected
                                                  ? Colors.white.withOpacity(
                                                      0.6,
                                                    )
                                                  : Colors.green.shade400,
                                              width: 1.5,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  isSelected ? 0.15 : 0.08,
                                                ),
                                                blurRadius: 3,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.volume_up_rounded,
                                            size: 10,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.green.shade800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Temporary snackbar for coming soon feature
  void _showComingSoonSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Audio feature coming soon!',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.green.shade700,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// ===== ENHANCED MODERN DETAILS BOTTOM SHEET =====
  void _showDetails(BuildContext context, Map<String, String> name) {
    final provider = Provider.of<AllahNameProvider>(context, listen: false);
    final relatedNames = provider.getRelatedNames(name);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (innerContext, scrollController) {
            return Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1B5E20), Color(0xFF0A1A10)],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 40,
                    offset: const Offset(0, -10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Fixed Banner
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF0C3B2E),
                          const Color(0xFF1B5E20).withOpacity(0.9),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Arabic Name
                        Expanded(
                          child: Text(
                            name['arabic']!,
                            style: const TextStyle(
                              fontSize: 32,
                              color: Color(0xFFC5E1A5),
                              fontFamily: 'NotoNaskhArabic',
                              shadows: [
                                Shadow(blurRadius: 10, color: Colors.black45),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // Sound Icon in Banner
                        GestureDetector(
                          onTap: () {
                            _showComingSoonSnackbar(sheetContext);
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            margin: const EdgeInsets.only(left: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.4),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.volume_up_rounded,
                              size: 22,
                              color: Color(0xFFC5E1A5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Draggable Handle
                  Container(
                    width: 45,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Content Area
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF1B5E20), Color(0xFF0A1A10)],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Background Mosque Icon
                          Positioned(
                            right: -50,
                            top: -50,
                            child: Icon(
                              Icons.mosque,
                              size: 250,
                              color: Colors.white.withOpacity(0.03),
                            ),
                          ),
                          // Fixed SubhanAllah Button
                          Positioned(
                            bottom: 20,
                            left: 24,
                            right: 24,
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // প্রথমে বটম শিট বন্ধ করুন
                                    Navigator.of(
                                      sheetContext,
                                      rootNavigator: true,
                                    ).pop();

                                    // তারপর snackbar দেখান
                                    Future.delayed(
                                      const Duration(milliseconds: 300),
                                      () {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                              'SubhanAllah',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            backgroundColor:
                                                Colors.green.shade700,
                                            duration: const Duration(
                                              seconds: 2,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            margin: EdgeInsets.only(
                                              bottom:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.1,
                                              left: 20,
                                              right: 20,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFE8F5E9),
                                          Colors.white,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'SubhanAllah',
                                        style: TextStyle(
                                          color: Color(0xFF0C3B2E),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Scrollable Content
                          ListView(
                            controller: scrollController,
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
                            children: [
                              // Transliteration Card
                              _buildModernCard(
                                label: 'TRANSLITERATION',
                                content: name['transliteration']!,
                                icon: Icons.auto_awesome_outlined,
                                accentColor: Colors.amber.shade200,
                              ),
                              const SizedBox(height: 12),
                              // Meaning Card
                              _buildModernCard(
                                label: 'MEANING',
                                content: name['meaning']!,
                                icon: Icons.menu_book_rounded,
                                accentColor: Colors.blue.shade200,
                              ),
                              const SizedBox(height: 12),
                              // Virtue & Benefit Card
                              _buildModernCard(
                                label: 'VIRTUE & BENEFIT',
                                content: name['virtue']!,
                                icon: Icons.verified_user_outlined,
                                accentColor: Colors.teal.shade200,
                              ),
                              const SizedBox(height: 12),

                              // RELATED NAMES SECTION
                              if (relatedNames.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 4,
                                        bottom: 8,
                                      ),
                                      child: Text(
                                        'Related Names',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.08),
                                        ),
                                      ),
                                      child: Column(
                                        children: relatedNames.map((
                                          relatedName,
                                        ) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.of(
                                                sheetContext,
                                                rootNavigator: true,
                                              ).pop();
                                              Future.delayed(
                                                const Duration(
                                                  milliseconds: 300,
                                                ),
                                                () {
                                                  _showDetails(
                                                    // ignore: use_build_context_synchronously
                                                    context,
                                                    relatedName,
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom:
                                                      relatedNames.last !=
                                                          relatedName
                                                      ? BorderSide(
                                                          color: Colors.white
                                                              .withOpacity(
                                                                0.08,
                                                              ),
                                                          width: 1,
                                                        )
                                                      : BorderSide.none,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          relatedName['arabic']!,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Color(
                                                              0xFFC5E1A5,
                                                            ),
                                                            fontFamily:
                                                                'NotoNaskhArabic',
                                                          ),
                                                        ),
                                                        SizedBox(height: 4),
                                                        Text(
                                                          relatedName['transliteration']!,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.white70,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.chevron_right,
                                                    color: Colors.white
                                                        .withOpacity(0.3),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),

                              const SizedBox(height: 80),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModernCard({
    required String label,
    required String content,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: accentColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: accentColor.withOpacity(0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
