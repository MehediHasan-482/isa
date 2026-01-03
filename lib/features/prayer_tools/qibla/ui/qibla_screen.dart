import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qibla Direction')),
      body: StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final direction = snapshot.data!.heading;

          if (direction == null) {
            return const Center(child: Text('Device does not have compass'));
          }

          return Center(
            child: Transform.rotate(
              angle: (-direction) * (math.pi / 180),
              child: const Icon(
                Icons.navigation,
                size: 150,
                color: Colors.red,
              ),
            ),
          );
        },
      ),
    );
  }
}
