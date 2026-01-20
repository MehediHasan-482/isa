// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:isa/features/tasbeeh/provider/tasbeeh_provider.dart';
import 'package:provider/provider.dart';

class TasbeehScreen extends StatelessWidget {
  const TasbeehScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tasbeeh Counter',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,

        /// ===== THREE DOT MENU =====
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'history') {
                _showHistory(context);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'history',
                child: Row(
                  children: [
                    Icon(Icons.history, size: 20),
                    SizedBox(width: 10),
                    Text('History'),
                  ],
                ),
              ),
            ],
          ),
        ],

        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFF141414)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: Consumer<TasbeehProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// ================= TASBEEH SELECT =================
                Row(
                  children: [
                    const Text(
                      'Select Tasbeeh:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: provider.selectedTasbeeh,
                      items: provider.tasbeehList
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) provider.selectTasbeeh(val);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// ================= DUA READER =================
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListView.builder(
                      itemCount:
                          provider.duaLines[provider.selectedTasbeeh]?.length ??
                          0,
                      itemBuilder: (context, index) {
                        final line =
                            provider.duaLines[provider.selectedTasbeeh]![index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            line,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: index == 0 ? 28 : 18,
                              fontWeight: index == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: index == 0 ? Colors.black : Colors.black87,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// ================= COUNTER =================
                Text(
                  provider.count.toString().padLeft(3, '0'),
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),

                const SizedBox(height: 16),

                /// ================= INCREMENT BUTTON =================
                GestureDetector(
                  onTap: provider.increment,
                  child: Container(
                    width: 180,
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.green, Colors.teal],
                      ),
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 6),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        '+',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// ================= ACTION BUTTONS =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _actionButton(
                      icon: Icons.refresh,
                      color: Colors.red,
                      onPressed: provider.reset,
                    ),
                    _actionButton(
                      icon: Icons.save,
                      color: Colors.green,
                      onPressed: provider.saveToday,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// ================= HISTORY BOTTOM SHEET =================
  void _showHistory(BuildContext context) {
    final provider = context.read<TasbeehProvider>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: provider.history.isEmpty
              ? const Center(
                  child: Text(
                    'No history found',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: provider.history.length,
                  itemBuilder: (context, index) {
                    final h = provider.history.reversed.toList()[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.bookmark),
                        title: Text(h['tasbeeh']),
                        subtitle: Text(h['date']),
                        trailing: Text(
                          h['count'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  /// ================= ACTION BUTTON =================
  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
