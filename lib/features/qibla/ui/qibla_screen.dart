// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:provider/provider.dart';
import '../provider/qibla_provider.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  bool showCompass = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await context.read<QiblaProvider>().updateLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QiblaProvider>();
    final double compassSize = MediaQuery.of(context).size.width * 0.75;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'Qibla Direction',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Optional: show info or help dialog
            },
          ),
        ],
        // ---------------- GRADIENT ----------------
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

      body: provider.currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 20),

                // ================= COMPASS =================
                Center(
                  child: SizedBox(
                    width: compassSize,
                    height: compassSize,
                    child: showCompass
                        ? StreamBuilder<CompassEvent>(
                            stream: FlutterCompass.events,
                            builder: (context, snapshot) {
                              final heading = snapshot.data?.heading ?? 0.0;

                              // 🔑 MAIN QIBLA ROTATION LOGIC
                              final rotation =
                                  (provider.qiblaAngle - heading) * pi / 180;

                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Compass circle
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 12,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Ticks
                                  CustomPaint(
                                    size: Size(compassSize, compassSize),
                                    painter: TickPainter(),
                                  ),

                                  // Directions
                                  _dir("N", top: 10),
                                  _dir("E", right: 10),
                                  _dir("S", bottom: 10),
                                  _dir("W", left: 10),

                                  // Qibla arrow
                                  Transform.rotate(
                                    angle: rotation,
                                    child: const Icon(
                                      Icons.navigation,
                                      size: 80,
                                      color: Colors.green,
                                    ),
                                  ),

                                  // 🧎 Janamaz at arrow tip (QIBLA SIDE)
                                  Transform.rotate(
                                    angle: rotation,
                                    child: Transform.translate(
                                      offset: Offset(0, -compassSize * 0.32),
                                      child: SizedBox(
                                        width: compassSize * 0.22,
                                        height: compassSize * 0.22,
                                        child: Image.asset(
                                          "assets/images/kaba1.jpg",
                                          //fit: BoxFit.contain,
                                          width: 80,
                                          height: 80,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              "Compass Hidden",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // ================= INFO CARD =================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Address
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                provider.address ??
                                    "Lat: ${provider.currentPosition!.latitude.toStringAsFixed(4)}, "
                                        "Lng: ${provider.currentPosition!.longitude.toStringAsFixed(4)}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.explore, // compass icon
                                  size: 18,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Qibla: ${provider.qiblaAngle.toStringAsFixed(2)}°",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.compass_calibration,
                              size: 20,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              "Show Compass:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Switch(
                              value: showCompass,
                              activeColor: Colors.green,
                              onChanged: (v) => setState(() => showCompass = v),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

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

// ================= TICK PAINTER =================
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
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
