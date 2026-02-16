// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:isa/features/hifz/model/hifz_model.dart';
import 'package:isa/features/quran/ui/quran_screen.dart';
import 'package:provider/provider.dart';
import '../provider/hifz_provider.dart';
import 'package:intl/intl.dart';

class HifzScreen extends StatelessWidget {
  const HifzScreen({super.key});

  static const Color darkGreen = Color(0xFF0C3B2E);
  static const Color mediumGreen = Color(0xFF1B5E20);
  static const Color lightGreen = Color(0xFF2E7D32);
  static const Color softOrange = Color(0xFFF57C00);
  static const Color softPurple = Color(0xFF7B1FA2);
  static const Color softRed = Color(0xFFD32F2F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hifz Tracker",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        // ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics, size: 24),
            onPressed: () => _showStatsDialog(context),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.filter_list),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'clear', child: Text('Clear Filters')),
              const PopupMenuItem(value: 'export', child: Text('Export Data')),
            ],
            onSelected: (value) {
              if (value == 'clear') {
                Provider.of<HifzProvider>(
                  context,
                  listen: false,
                ).clearFilters();
              } else if (value == 'export') {
                _showExportDialog(context);
              }
            },
          ),
        ],
      ),
      body: Consumer<HifzProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(provider),
                const SizedBox(height: 6),
                _buildSearchBar(provider),
                const SizedBox(height: 6),
                _buildTodayCard(provider),
                const SizedBox(height: 6),
                _buildRevisionAlert(context, provider),
                const SizedBox(height: 6),
                _buildFilterChips(provider),
                const SizedBox(height: 6),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.48,
                  child: DefaultTabController(
                    length: 4,
                    child: Column(
                      children: [
                        _buildTabBar(),
                        const SizedBox(height: 8),
                        Expanded(child: _buildEntriesList(provider)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEntryDialog(context),
        icon: const Icon(Icons.add, size: 20),
        label: const Text(
          "Add Hifz",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: mediumGreen,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildHeader(HifzProvider provider) {
    final stats = provider.getStatistics();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [darkGreen, mediumGreen, lightGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            icon: Icons.menu_book,
            value: "${stats['totalAyahs']}",
            label: "Total Ayahs",
            subLabel: "${stats['totalEntries']} entries",
          ),
          Container(height: 30, width: 1, color: Colors.white.withOpacity(0.5)),
          _buildStatItem(
            icon: Icons.whatshot,
            value: "${stats['currentStreak']}",
            label: "Day Streak",
            color: Colors.orange,
            subLabel: "${stats['completionRate']}% completed",
          ),
          Container(height: 30, width: 1, color: Colors.white.withOpacity(0.5)),
          _buildStatItem(
            icon: Icons.update,
            value: "${stats['revisionNeeded']}",
            label: "To Review",
            color: softOrange,
            subLabel: "Need practice",
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    String? subLabel,
    Color? color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color ?? Colors.white, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        if (subLabel != null)
          Text(
            subLabel,
            style: const TextStyle(color: Colors.white54, fontSize: 10),
          ),
      ],
    );
  }

  Widget _buildSearchBar(HifzProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          onChanged: provider.setSearchQuery,
          decoration: InputDecoration(
            hintText: 'Search surah, notes, or ayah range...',
            prefixIcon: const Icon(Icons.search, color: mediumGreen),
            suffixIcon: provider.searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () => provider.setSearchQuery(''),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(HifzProvider provider) {
    final surahNames = ['All', ...SurahData.surahNames.take(5)];

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          ...surahNames.map(
            (surah) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(surah),
                selected: provider.selectedSurah == surah,
                onSelected: (_) => provider.setSurahFilter(surah),
                backgroundColor: Colors.grey.shade100,
                selectedColor: lightGreen.withOpacity(0.2),
                checkmarkColor: mediumGreen,
                labelStyle: TextStyle(
                  color: provider.selectedSurah == surah
                      ? mediumGreen
                      : Colors.black87,
                  fontWeight: provider.selectedSurah == surah
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayCard(HifzProvider provider) {
    final todayEntries = provider.todayEntries;
    if (todayEntries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200), // ← key change
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: lightGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.today, color: mediumGreen, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Today's Hifz",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: darkGreen,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "${todayEntries.length} entries",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Scrollable list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                itemCount: todayEntries.length,
                itemBuilder: (context, index) {
                  final e = todayEntries[index];
                  return ListTile(
                    dense: true, // ← makes items more compact
                    visualDensity: VisualDensity.compact,
                    minLeadingWidth: 36,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: lightGreen.withOpacity(0.1),
                      radius: 18,
                      child: Text(
                        e.ayahCount.toString(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: mediumGreen,
                        ),
                      ),
                    ),
                    title: Text(
                      e.surah,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      "Ayah ${e.ayahRange} • ${e.type}",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                      ),
                    ),
                    trailing: _buildRatingStars(e.rating),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevisionAlert(BuildContext context, HifzProvider provider) {
    if (provider.revisionQueue.isEmpty) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: softOrange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: softOrange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: softOrange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.warning_amber, color: softOrange, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${provider.revisionQueue.length} entries need revision",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Rating below 4 or not reviewed recently",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              _showRevisionDialog(context, provider.revisionQueue);
            },
            style: TextButton.styleFrom(
              foregroundColor: softOrange,
              backgroundColor: softOrange.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text("Review Now"),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [darkGreen, mediumGreen, lightGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black54,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: "All"),
          Tab(text: "New"),
          Tab(text: "Sabaqi"),
          Tab(text: "Manzil"),
        ],
      ),
    );
  }

  Widget _buildEntriesList(HifzProvider provider) {
    return TabBarView(
      children: [
        _buildListView(provider.filteredEntries, provider),
        _buildListView(provider.getByType("New"), provider),
        _buildListView(provider.getByType("Sabaqi"), provider),
        _buildListView(provider.getByType("Manzil"), provider),
      ],
    );
  }

  Widget _buildListView(List<HifzEntry> entries, HifzProvider provider) {
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: lightGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu_book,
                size: 48,
                color: lightGreen.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "No hifz entries found",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              provider.searchQuery.isNotEmpty
                  ? 'No matches for "${provider.searchQuery}"'
                  : 'Tap "+" button to add new entry',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return _buildEntryCard(entry, context, provider);
      },
    );
  }

  Widget _buildEntryCard(
    HifzEntry entry,
    BuildContext context,
    HifzProvider provider,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: entry.isCompleted
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Colors.white, lightGreen.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              )
            : null,
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getTypeColor(entry.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: entry.isCompleted
                  ? Border.all(color: lightGreen.withOpacity(0.3))
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  entry.ayahCount.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _getTypeColor(entry.type),
                  ),
                ),
                Text(
                  "Ayahs",
                  style: TextStyle(
                    fontSize: 8,
                    color: _getTypeColor(entry.type),
                  ),
                ),
              ],
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  entry.surah,
                  style: TextStyle(
                    fontWeight: entry.isCompleted
                        ? FontWeight.w600
                        : FontWeight.bold,
                    fontSize: 16,
                    decoration: entry.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: entry.isCompleted ? Colors.grey.shade600 : darkGreen,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getTypeColor(entry.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  entry.type,
                  style: TextStyle(
                    color: _getTypeColor(entry.type),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                "Ayahs: ${entry.ayahRange}",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: Colors.grey.shade500,
                  ),
                  //const SizedBox(width: 4),
                  Text(
                    DateFormat('dd MMM yyyy').format(entry.date),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.star, size: 14, color: Colors.amber.shade700),
                  const SizedBox(width: 4),
                  Text(
                    "${entry.rating}/5",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  if (entry.reviewCount > 0) ...[
                    const SizedBox(width: 12),
                    Icon(Icons.repeat, size: 14, color: softPurple),
                    const SizedBox(width: 4),
                    Text(
                      "${entry.reviewCount}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ],
              ),
              if (entry.notes != null && entry.notes!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    entry.notes!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
              if (entry.needsRevision && !entry.isCompleted) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: softOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning, size: 12, color: softOrange),
                      const SizedBox(width: 4),
                      Text(
                        "Needs Revision",
                        style: TextStyle(
                          fontSize: 10,
                          color: softOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          trailing: PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'rating',
                child: Row(
                  children: [
                    Icon(Icons.star, size: 18),
                    SizedBox(width: 8),
                    Text("Update Rating"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'complete',
                child: Row(
                  children: [
                    Icon(
                      entry.isCompleted ? Icons.undo : Icons.check_circle,
                      size: 18,
                      color: entry.isCompleted ? softOrange : mediumGreen,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      entry.isCompleted ? "Mark Incomplete" : "Mark Complete",
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 8),
                    Text("Edit Entry"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text("Delete", style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteDialog(context, entry.id);
              } else if (value == 'complete') {
                provider.toggleCompleted(entry.id);
                _showSnackBar(
                  context,
                  entry.isCompleted
                      ? "Entry marked as incomplete"
                      : "Entry marked as complete",
                  color: entry.isCompleted ? softOrange : mediumGreen,
                );
              } else if (value == 'rating') {
                _showRatingDialog(context, entry);
              } else if (value == 'edit') {
                _showEditDialog(context, entry);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case "New":
        return mediumGreen;
      case "Sabaqi":
        return softOrange;
      case "Manzil":
        return softPurple;
      default:
        return lightGreen;
    }
  }

  void _showAddEntryDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String selectedSurah = SurahData.surahNames.first;
    final startController = TextEditingController();
    final endController = TextEditingController();
    final notesController = TextEditingController();
    String selectedType = "New";
    int rating = 3;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            title: Row(
              children: [
                Icon(Icons.add_circle, color: mediumGreen, size: 24),
                const SizedBox(width: 8),
                Text(
                  "Add New Hifz Entry",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Surah Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedSurah,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: "Select Surah",
                        prefixIcon: Icon(Icons.menu_book, color: mediumGreen),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: mediumGreen, width: 2),
                        ),
                      ),
                      items: SurahData.surahNames.map((surah) {
                        return DropdownMenuItem(
                          value: surah,
                          child: Text(surah),
                        );
                      }).toList(),
                      onChanged: (v) {
                        setState(() {
                          selectedSurah = v!;
                        });
                      },
                      validator: (v) =>
                          v == null ? "Please select a surah" : null,
                    ),
                    const SizedBox(height: 12),

                    // Start Ayah
                    TextFormField(
                      controller: startController,
                      decoration: InputDecoration(
                        labelText: "Start Ayah",
                        prefixIcon: Icon(Icons.looks_one, color: mediumGreen),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: mediumGreen, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return "Please enter start ayah";
                        }
                        final start = int.tryParse(v);
                        if (start == null || start < 1) {
                          return "Please enter a valid ayah number";
                        }
                        final maxAyahs = SurahData.getAyahCount(selectedSurah);
                        if (start > maxAyahs) {
                          return "Maximum ayah for this surah is $maxAyahs";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    // End Ayah
                    TextFormField(
                      controller: endController,
                      decoration: InputDecoration(
                        labelText: "End Ayah",
                        prefixIcon: Icon(Icons.looks_two, color: mediumGreen),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: mediumGreen, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return "Please enter end ayah";
                        }
                        final end = int.tryParse(v);
                        if (end == null) {
                          return "Please enter a valid ayah number";
                        }
                        final start = int.tryParse(startController.text) ?? 0;
                        if (end < start) {
                          return "End ayah must be greater than start ayah";
                        }
                        final maxAyahs = SurahData.getAyahCount(selectedSurah);
                        if (end > maxAyahs) {
                          return "Maximum ayah for this surah is $maxAyahs";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    // Type Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: "Type",
                        prefixIcon: Icon(Icons.category, color: mediumGreen),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: mediumGreen, width: 2),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: "New", child: Text("New")),
                        DropdownMenuItem(
                          value: "Sabaqi",
                          child: Text("Sabaqi"),
                        ),
                        DropdownMenuItem(
                          value: "Manzil",
                          child: Text("Manzil"),
                        ),
                      ],
                      onChanged: (v) {
                        setState(() {
                          selectedType = v!;
                        });
                      },
                    ),
                    const SizedBox(height: 8),

                    // Rating
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Memorization Quality:",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: List.generate(5, (index) {
                              return Expanded(
                                child: IconButton(
                                  icon: Icon(
                                    index < rating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      rating = index + 1;
                                    });
                                  },
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Notes
                    TextFormField(
                      controller: notesController,
                      decoration: InputDecoration(
                        labelText: "Notes (Optional)",
                        prefixIcon: Icon(Icons.note, color: mediumGreen),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: mediumGreen, width: 2),
                        ),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final start = int.parse(startController.text);
                    final end = int.parse(endController.text);

                    final entry = HifzEntry(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      surah: selectedSurah,
                      startAyah: start,
                      endAyah: end,
                      type: selectedType,
                      date: DateTime.now(),
                      totalAyahs: end - start + 1,
                      notes: notesController.text.isNotEmpty
                          ? notesController.text
                          : null,
                      rating: rating,
                      lastReviewedDate: DateTime.now(),
                      reviewCount: 0,
                    );

                    Provider.of<HifzProvider>(
                      context,
                      listen: false,
                    ).addEntry(entry);

                    Navigator.pop(context);

                    _showSnackBar(
                      context,
                      "Hifz entry added successfully",
                      color: mediumGreen,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mediumGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Save"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, HifzEntry entry) {
    final formKey = GlobalKey<FormState>();
    String selectedSurah = entry.surah;
    final startController = TextEditingController(
      text: entry.startAyah.toString(),
    );
    final endController = TextEditingController(text: entry.endAyah.toString());
    final notesController = TextEditingController(text: entry.notes ?? '');
    String selectedType = entry.type;
    int rating = entry.rating;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.edit, color: mediumGreen, size: 24),
                const SizedBox(width: 8),
                Text(
                  "Edit Hifz Entry",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Surah Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedSurah,
                      decoration: InputDecoration(
                        labelText: "Select Surah",
                        prefixIcon: Icon(Icons.menu_book, color: mediumGreen),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: mediumGreen, width: 2),
                        ),
                      ),
                      items: SurahData.surahNames.map((surah) {
                        return DropdownMenuItem(
                          value: surah,
                          child: Text(surah),
                        );
                      }).toList(),
                      onChanged: (v) {
                        setState(() {
                          selectedSurah = v!;
                        });
                      },
                      validator: (v) =>
                          v == null ? "Please select a surah" : null,
                    ),
                    const SizedBox(height: 12),

                    // Start Ayah
                    TextFormField(
                      controller: startController,
                      decoration: InputDecoration(
                        labelText: "Start Ayah",
                        prefixIcon: Icon(Icons.looks_one, color: mediumGreen),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: mediumGreen, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return "Please enter start ayah";
                        }
                        final start = int.tryParse(v);
                        if (start == null || start < 1) {
                          return "Please enter a valid ayah number";
                        }
                        final maxAyahs = SurahData.getAyahCount(selectedSurah);
                        if (start > maxAyahs) {
                          return "Maximum ayah for this surah is $maxAyahs";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // End Ayah
                    TextFormField(
                      controller: endController,
                      decoration: InputDecoration(
                        labelText: "End Ayah",
                        prefixIcon: Icon(Icons.looks_two, color: mediumGreen),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: mediumGreen, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return "Please enter end ayah";
                        }
                        final end = int.tryParse(v);
                        if (end == null) {
                          return "Please enter a valid ayah number";
                        }
                        final start = int.tryParse(startController.text) ?? 0;
                        if (end < start) {
                          return "End ayah must be greater than start ayah";
                        }
                        final maxAyahs = SurahData.getAyahCount(selectedSurah);
                        if (end > maxAyahs) {
                          return "Maximum ayah for this surah is $maxAyahs";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Type Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: "Type",
                        prefixIcon: Icon(Icons.category, color: mediumGreen),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: mediumGreen, width: 2),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: "New", child: Text("New")),
                        DropdownMenuItem(
                          value: "Sabaqi",
                          child: Text("Sabaqi"),
                        ),
                        DropdownMenuItem(
                          value: "Manzil",
                          child: Text("Manzil"),
                        ),
                      ],
                      onChanged: (v) {
                        setState(() {
                          selectedType = v!;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // Rating
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Memorization Quality:",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(5, (index) {
                              return IconButton(
                                icon: Icon(
                                  index < rating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 30,
                                ),
                                onPressed: () {
                                  setState(() {
                                    rating = index + 1;
                                  });
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Notes
                    TextFormField(
                      controller: notesController,
                      decoration: InputDecoration(
                        labelText: "Notes (Optional)",
                        prefixIcon: Icon(Icons.note, color: mediumGreen),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: mediumGreen, width: 2),
                        ),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final start = int.parse(startController.text);
                    final end = int.parse(endController.text);

                    final updatedEntry = entry.copyWith(
                      surah: selectedSurah,
                      startAyah: start,
                      endAyah: end,
                      type: selectedType,
                      totalAyahs: end - start + 1,
                      notes: notesController.text.isNotEmpty
                          ? notesController.text
                          : null,
                      rating: rating,
                      lastReviewedDate: DateTime.now(),
                    );

                    Provider.of<HifzProvider>(
                      context,
                      listen: false,
                    ).updateEntry(updatedEntry);

                    Navigator.pop(context);

                    _showSnackBar(
                      context,
                      "Hifz entry updated successfully",
                      color: mediumGreen,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mediumGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Update"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showRatingDialog(BuildContext context, HifzEntry entry) {
    int newRating = entry.rating;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 24),
                const SizedBox(width: 4),
                Text(
                  "Rate Memorization",
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: lightGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        entry.surah,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Ayah ${entry.ayahRange}",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "How well have you memorized this?",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          newRating = index + 1;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          index < newRating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 26,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  _getRatingDescription(newRating),
                  style: TextStyle(
                    color: mediumGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey.shade600,
                ),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<HifzProvider>(
                    context,
                    listen: false,
                  ).updateRating(entry.id, newRating);
                  Navigator.pop(context);
                  _showSnackBar(
                    context,
                    "Rating updated to $newRating/5",
                    color: mediumGreen,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mediumGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Update"),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getRatingDescription(int rating) {
    switch (rating) {
      case 1:
        return "Needs significant revision";
      case 2:
        return "Partially memorized";
      case 3:
        return "Adequately memorized";
      case 4:
        return "Well memorized";
      case 5:
        return "Perfectly memorized";
      default:
        return "";
    }
  }

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: softRed, size: 24),
            const SizedBox(width: 8),
            Text(
              "Confirm Delete",
              style: TextStyle(color: darkGreen, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.delete_forever, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                "Are you sure you want to delete this entry?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                "This action cannot be undone.",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<HifzProvider>(context, listen: false).deleteEntry(id);
              Navigator.pop(context);
              _showSnackBar(
                context,
                "Entry deleted successfully",
                color: softRed,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: softRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _showRevisionDialog(
    BuildContext context,
    List<HifzEntry> revisionQueue,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: softOrange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_amber,
                      color: softOrange,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Revision Queue",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(dialogContext),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                "${revisionQueue.length} entries need your attention",
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: revisionQueue.length,
                  itemBuilder: (listContext, index) {
                    final entry = revisionQueue[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: _getTypeColor(
                            entry.type,
                          ).withOpacity(0.1),
                          child: Text(
                            entry.rating.toString(),
                            style: TextStyle(
                              color: _getTypeColor(entry.type),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        title: Text(
                          entry.surah,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        subtitle: Text(
                          "Ayah ${entry.ayahRange} • Rating: ${entry.rating}/5",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.star, color: Colors.amber, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            _showRatingDialog(context, entry);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        "Close",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => QuranReadScreen()),
                        );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: softOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        "Start Revision",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStatsDialog(BuildContext context) {
    final provider = Provider.of<HifzProvider>(context, listen: false);
    final stats = provider.getStatistics();
    final weeklyActivity = provider.getWeeklyActivity();

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: lightGreen.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.analytics, color: mediumGreen, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Statistics",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: darkGreen,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 20),

              // Main stats grid
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                children: [
                  _buildStatCard(
                    icon: Icons.menu_book,
                    value: "${stats['totalAyahs']}",
                    label: "Total Ayahs",
                    color: mediumGreen,
                  ),
                  _buildStatCard(
                    icon: Icons.whatshot,
                    value: "${stats['currentStreak']}",
                    label: "Day Streak",
                    color: Colors.orange,
                  ),
                  _buildStatCard(
                    icon: Icons.star,
                    value: "${stats['averageRating']}",
                    label: "Avg Rating",
                    color: Colors.amber,
                  ),
                  _buildStatCard(
                    icon: Icons.check_circle,
                    value: "${stats['completionRate']}%",
                    label: "Completed",
                    color: Colors.green,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Type breakdown
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Entry Breakdown",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTypeStat(
                          label: "New",
                          count: stats['newCount'],
                          color: mediumGreen,
                        ),
                        _buildTypeStat(
                          label: "Sabaqi",
                          count: stats['sabaqiCount'],
                          color: softOrange,
                        ),
                        _buildTypeStat(
                          label: "Manzil",
                          count: stats['manzilCount'],
                          color: softPurple,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Weekly activity
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Weekly Activity",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: weeklyActivity.entries.map((entry) {
                        final day = DateFormat(
                          'E',
                        ).format(entry.key).substring(0, 1);
                        final count = entry.value;
                        return Column(
                          children: [
                            Container(
                              width: 30,
                              height: count > 0 ? 20 + (count / 2) : 8,
                              decoration: BoxDecoration(
                                color: count > 0
                                    ? mediumGreen.withOpacity(
                                        0.3 + (count / 100),
                                      )
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              day,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              count.toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: mediumGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Close"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeStat({
    required String label,
    required int count,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.download, color: mediumGreen, size: 24),
            const SizedBox(width: 8),
            Text(
              "Export Data",
              style: TextStyle(color: darkGreen, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Choose export format:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.insert_drive_file, color: mediumGreen),
              title: const Text("CSV Format"),
              subtitle: const Text("Compatible with Excel"),
              onTap: () {
                Navigator.pop(context);
                _showSnackBar(context, "Export started", color: mediumGreen);
              },
            ),
            ListTile(
              leading: Icon(Icons.picture_as_pdf, color: softRed),
              title: const Text("PDF Format"),
              subtitle: const Text("Printable report"),
              onTap: () {
                Navigator.pop(context);
                _showSnackBar(context, "Export started", color: mediumGreen);
              },
            ),
            ListTile(
              leading: Icon(Icons.backup, color: softPurple),
              title: const Text("JSON Format"),
              subtitle: const Text("For backup & restore"),
              onTap: () {
                Navigator.pop(context);
                _showSnackBar(context, "Export started", color: mediumGreen);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: Colors.grey.shade600),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    required Color color,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == mediumGreen ? Icons.check_circle : Icons.info,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
