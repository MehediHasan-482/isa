// ignore_for_file: deprecated_member_use, use_build_context_synchronously, unnecessary_underscores
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ================= TASBEEH SELECT =================
            Consumer<TasbeehProvider>(
              builder: (_, provider, __) => Row(
                children: [
                  const Text(
                    'Select Tasbeeh:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: provider.selectedTasbeeh,
                    items: provider.tasbeehList
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        showTargetDialog(context, val);
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ================= DUA READER =================
            Expanded(
              child: Consumer<TasbeehProvider>(
                builder: (_, provider, __) => Container(
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
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          line,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: index == 0 ? 28 : 16,
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
            ),

            const SizedBox(height: 14),

            // ================= COUNTER =================
            Consumer<TasbeehProvider>(
              builder: (_, provider, __) => Text(
                provider.count.toString().padLeft(3, '0'),
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ================= INCREMENT BUTTON =================
            Consumer<TasbeehProvider>(
              builder: (_, provider, __) => GestureDetector(
                onTap: provider.increment,
                child: Container(
                  width: 120,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.green, Colors.teal],
                    ),
                    borderRadius: BorderRadius.circular(40),
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
            ),

            const SizedBox(height: 20),

            // ================= ACTION BUTTONS =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Consumer<TasbeehProvider>(
                  builder: (_, provider, __) => _actionButton(
                    icon: Icons.refresh,
                    color: Colors.red,
                    onPressed: provider.reset,
                  ),
                ),
                Consumer<TasbeehProvider>(
                  builder: (_, provider, _) => _actionButton(
                    icon: Icons.save,
                    color: Colors.green,
                    onPressed: provider.saveToday,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= HISTORY BOTTOM SHEET =================
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

  // ================= ACTION BUTTON =================
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

// ================= TARGET DIALOG =================
void showTargetDialog(BuildContext context, String tasbeeh) {
  final provider = context.read<TasbeehProvider>();
  final TextEditingController controller = TextEditingController(
    text: provider.target.toString(),
  );

  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Set Target Count', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter how many times you want to count:',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter a number',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Start'),
            onPressed: () {
              final input = int.tryParse(controller.text);

              if (input != null && input > 0) {
                provider.setTasbeehWithTarget(tasbeeh, input);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid number'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      );
    },
  );
}
