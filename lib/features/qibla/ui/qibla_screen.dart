// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:isa/features/qibla/widget/compass_widget.dart';
import 'package:provider/provider.dart';
import '../provider/qibla_provider.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<QiblaProvider>().updateLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QiblaProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Qibla Direction'),
        backgroundColor: Colors.green[700],
      ),
      body: provider.currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your Location: ${provider.currentPosition!.latitude.toStringAsFixed(4)}, ${provider.currentPosition!.longitude.toStringAsFixed(4)}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                LiveCompass(qiblaAngle: provider.qiblaAngle),
                const SizedBox(height: 10),
                Text(
                  'Qibla Angle: ${provider.qiblaAngle.toStringAsFixed(2)}°',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
    );
  }
}
