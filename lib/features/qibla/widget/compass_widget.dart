// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

class LiveCompass extends StatefulWidget {
  final double qiblaAngle;
  final String regionName;

  const LiveCompass({
    super.key,
    required this.qiblaAngle,
    required this.regionName,
  });

  @override
  State<LiveCompass> createState() => _LiveCompassState();
}

class _LiveCompassState extends State<LiveCompass> {
  bool showCompass = true;

  @override
  Widget build(BuildContext context) {
    // Screen width relative size
    final double screenWidth = MediaQuery.of(context).size.width;
    final double compassSize = screenWidth * 0.7; // 70% of screen width

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Qibla Direction'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Column(
          children: [
            // Top info row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: const [
                    Icon(Icons.access_time, size: 32, color: Colors.green),
                    Text("Prayers Times"),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      widget.regionName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${widget.qiblaAngle.toStringAsFixed(1)}° west of north",
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                Switch(
                  value: showCompass,
                  onChanged: (v) => setState(() => showCompass = v),
                  activeColor: Colors.greenAccent,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Compass container
            Flexible(
              fit: FlexFit.loose,
              child: StreamBuilder<CompassEvent>(
                stream: showCompass ? FlutterCompass.events : null,
                builder: (context, snapshot) {
                  final heading =
                      snapshot.hasData && snapshot.data!.heading != null
                      ? snapshot.data!.heading!
                      : 0.0;

                  final rotation = (widget.qiblaAngle - heading) * (pi / 180);

                  return Center(
                    child: Container(
                      width: compassSize,
                      height: compassSize,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Compass Circle
                          Container(
                            width: compassSize,
                            height: compassSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                          ),

                          // Tick marks
                          CustomPaint(
                            size: Size(compassSize, compassSize),
                            painter: TickPainter(),
                          ),

                          // Direction Labels
                          _dir("N", top: 8),
                          _dir("E", right: 8),
                          _dir("S", bottom: 8),
                          _dir("W", left: 8),

                          // Kaaba icon (fixed west)
                          Positioned(
                            left: 0,
                            child: Icon(
                              Icons.location_on,
                              size: compassSize * 0.15,
                              color: Colors.black87,
                            ),
                          ),

                          // Arrow for Qibla (rotates)
                          Transform.rotate(
                            angle: rotation,
                            child: Icon(
                              Icons.navigation,
                              size: compassSize * 0.2,
                              color: Colors.green,
                            ),
                          ),

                          // Center prayer mat
                          SizedBox(
                            width: compassSize * 0.3,
                            height: compassSize * 0.3,
                            child: Image.asset(
                              "assets/images/Janamaz.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
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

  // Direction label helper
  Widget _dir(
    String text, {
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Tick painter for compass
class TickPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.6)
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (int i = 0; i < 360; i += 10) {
      final angle = i * pi / 180;
      final inner = Offset(
        center.dx + radius * 0.85 * cos(angle),
        center.dy + radius * 0.85 * sin(angle),
      );
      final outer = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      canvas.drawLine(inner, outer, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
