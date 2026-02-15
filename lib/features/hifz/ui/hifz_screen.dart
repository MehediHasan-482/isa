// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:isa/features/hifz/model/hifz_model.dart';
import 'package:provider/provider.dart';
import '../provider/hifz_provider.dart';
import 'package:intl/intl.dart';

class HifzScreen extends StatelessWidget {
  const HifzScreen({super.key});

  // Custom colors
  static const Color darkGreen = Color(0xFF0C3B2E);
  static const Color mediumGreen = Color(0xFF1B5E20);
  static const Color lightGreen = Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hifz Tracker",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () => _showStatsDialog(context),
          ),
        ],
      ),
      body: Consumer<HifzProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              _buildHeader(provider),
              const SizedBox(height: 10),
              _buildTodayCard(provider),
              const SizedBox(height: 10),
              _buildRevisionAlert(provider),
              const SizedBox(height: 10),
              // সবকিছু DefaultTabController এর ভিতরে
              Expanded(
                child: DefaultTabController(
                  length: 4,
                  child: Column(
                    children: [
                      _buildTabBar(),
                      const SizedBox(height: 10),
                      Expanded(child: _buildEntriesList(provider)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEntryDialog(context),
        icon: const Icon(Icons.add),
        label: const Text("Add Hifz"),
        backgroundColor: mediumGreen,
      ),
    );
  }

  Widget _buildHeader(HifzProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [darkGreen, mediumGreen, lightGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.menu_book,
            value: "${provider.totalMemorizedAyahs}",
            label: "Total Ayahs",
          ),
          Container(height: 40, width: 1, color: Colors.white.withOpacity(0.5)),
          _buildStatItem(
            icon: Icons.whatshot,
            value: "${provider.currentStreak}",
            label: "Day Streak",
            color: Colors.orange,
          ),
          Container(height: 40, width: 1, color: Colors.white.withOpacity(0.5)),
          _buildStatItem(
            icon: Icons.update,
            value: "${provider.revisionQueue.length}",
            label: "To Review",
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    Color? color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color ?? Colors.white),
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
      ],
    );
  }

  Widget _buildTodayCard(HifzProvider provider) {
    final todayEntries = provider.todayEntries;

    if (todayEntries.isEmpty) {
      return const SizedBox();
    }

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.today, color: mediumGreen),
                const SizedBox(width: 8),
                Text(
                  "Today's Hifz",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                  ),
                ),
              ],
            ),
            const Divider(),
            ...todayEntries.map(
              (e) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: lightGreen.withOpacity(0.1),
                  child: Text(
                    e.ayahCount.toString(),
                    style: TextStyle(fontSize: 12, color: mediumGreen),
                  ),
                ),
                title: Text(
                  e.surah,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  "Ayah: ${e.ayahRange} (${e.type})",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                trailing: _buildRatingStars(e.rating),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevisionAlert(HifzProvider provider) {
    if (provider.revisionQueue.isEmpty) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: lightGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: mediumGreen.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber, color: mediumGreen),
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
                  ),
                ),
                Text(
                  "Rating below 4",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              // Navigate to revision screen
            },
            style: TextButton.styleFrom(foregroundColor: mediumGreen),
            child: const Text("View"),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: const TabBar(
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0C3B2E), Color(0xFF1B5E20), Color(0xFF2E7D32)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black54,
        tabs: [
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
        _buildListView(provider.entries),
        _buildListView(provider.getByType("New")),
        _buildListView(provider.getByType("Sabaqi")),
        _buildListView(provider.getByType("Manzil")),
      ],
    );
  }

  Widget _buildListView(List<HifzEntry> entries) {
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              "No hifz entries found",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap "+" button to add new entry',
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
        return _buildEntryCard(entry, context);
      },
    );
  }

  Widget _buildEntryCard(HifzEntry entry, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getTypeColor(entry.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                entry.ayahCount.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getTypeColor(entry.type),
                ),
              ),
              Text(
                "Ayahs",
                style: TextStyle(
                  fontSize: 10,
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
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
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
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
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat('dd MMM yyyy').format(entry.date),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
                const SizedBox(width: 12),
                Icon(Icons.star, size: 14, color: Colors.amber.shade700),
                const SizedBox(width: 4),
                Text(
                  "${entry.rating}/5",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
            if (entry.notes != null && entry.notes!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                entry.notes!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'rating', child: Text("Rate")),
            PopupMenuItem(
              value: 'complete',
              child: Text(
                entry.isCompleted ? "Mark Incomplete" : "Mark Complete",
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
          onSelected: (value) {
            if (value == 'delete') {
              _showDeleteDialog(context, entry.id);
            } else if (value == 'complete') {
              Provider.of<HifzProvider>(
                context,
                listen: false,
              ).toggleCompleted(entry.id);
            } else if (value == 'rating') {
              _showRatingDialog(context, entry);
            }
          },
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
        return Colors.orange;
      case "Manzil":
        return Colors.purple;
      default:
        return lightGreen;
    }
  }

  void _showAddEntryDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String selectedSurah = SurahData.surahAyahCount.keys.first;
    final startController = TextEditingController();
    final endController = TextEditingController();
    final notesController = TextEditingController();
    String selectedType = "New";
    int rating = 3;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              "Add New Hifz Entry",
              style: TextStyle(fontWeight: FontWeight.bold, color: darkGreen),
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
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: mediumGreen),
                        ),
                      ),
                      items: SurahData.surahAyahCount.keys.map((surah) {
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
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: mediumGreen),
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
                        final maxAyahs =
                            SurahData.surahAyahCount[selectedSurah]!;
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
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: mediumGreen),
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
                        final maxAyahs =
                            SurahData.surahAyahCount[selectedSurah]!;
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
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: mediumGreen),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Memorization Quality:"),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                index < rating ? Icons.star : Icons.star_border,
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
                    const SizedBox(height: 12),

                    // Notes
                    TextFormField(
                      controller: notesController,
                      decoration: InputDecoration(
                        labelText: "Notes (Optional)",
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: mediumGreen),
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
                    );

                    Provider.of<HifzProvider>(
                      context,
                      listen: false,
                    ).addEntry(entry);

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Hifz entry added successfully"),
                        backgroundColor: mediumGreen,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: mediumGreen),
                child: const Text("Save"),
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
            title: Text(
              "Rate Memorization",
              style: TextStyle(color: darkGreen),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${entry.surah} - Ayah ${entry.ayahRange}"),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < newRating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 40,
                      ),
                      onPressed: () {
                        setState(() {
                          newRating = index + 1;
                        });
                      },
                    );
                  }),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<HifzProvider>(
                    context,
                    listen: false,
                  ).updateRating(entry.id, newRating);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: mediumGreen),
                child: const Text("Update"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Confirm Delete", style: TextStyle(color: darkGreen)),
        content: const Text("Are you sure you want to delete this entry?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Provider.of<HifzProvider>(context, listen: false).deleteEntry(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Entry deleted"),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _showStatsDialog(BuildContext context) {
    final provider = Provider.of<HifzProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Statistics", style: TextStyle(color: darkGreen)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.menu_book, color: mediumGreen),
              title: const Text("Total Ayahs"),
              trailing: Text(
                "${provider.totalMemorizedAyahs}",
                style: TextStyle(fontWeight: FontWeight.bold, color: darkGreen),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.whatshot, color: Colors.orange),
              title: const Text("Current Streak"),
              trailing: Text(
                "${provider.currentStreak} days",
                style: TextStyle(fontWeight: FontWeight.bold, color: darkGreen),
              ),
            ),
            ListTile(
              leading: Icon(Icons.new_releases, color: lightGreen),
              title: const Text("New Hifz"),
              trailing: Text(
                "${provider.getByType("New").length}",
                style: TextStyle(fontWeight: FontWeight.bold, color: darkGreen),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.update, color: Colors.purple),
              title: const Text("Sabaqi"),
              trailing: Text(
                "${provider.getByType("Sabaqi").length}",
                style: TextStyle(fontWeight: FontWeight.bold, color: darkGreen),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.repeat, color: Colors.teal),
              title: const Text("Manzil"),
              trailing: Text(
                "${provider.getByType("Manzil").length}",
                style: TextStyle(fontWeight: FontWeight.bold, color: darkGreen),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: mediumGreen),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
