import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/tasbeeh_provider.dart';

class TasbeehScreen extends StatelessWidget {
  const TasbeehScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TasbeehProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tasbeeh'),
        ),
        body: Consumer<TasbeehProvider>(
          builder: (context, provider, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  provider.count.toString(),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: provider.increment,
                  child: const Text('Count'),
                ),
                TextButton(
                  onPressed: provider.reset,
                  child: const Text('Reset'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
