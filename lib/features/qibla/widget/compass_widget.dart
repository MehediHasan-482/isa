import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

class LiveCompass extends StatelessWidget {
  final double qiblaAngle;

  const LiveCompass({required this.qiblaAngle, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.heading == null) {
          return const Center(child: CircularProgressIndicator());
        }

        double heading = snapshot.data!.heading!; // degree
        double rotation = (qiblaAngle - heading) * (pi / 180);

        return Center(
          child: Transform.rotate(
            angle: rotation,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[900],
                border: Border.all(color: Colors.white24, width: 2),
              ),
              child: const Center(
                child: Icon(
                  Icons.navigation,
                  size: 80,
                  color: Colors.greenAccent,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
