// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/colors.dart';

class LeaveEventLoader extends StatefulWidget {
  final Future<void> Function() onFinished;
  const LeaveEventLoader({required this.onFinished});
  @override
  State<LeaveEventLoader> createState() => _LeaveEventLoaderState();
}

class _LeaveEventLoaderState extends State<LeaveEventLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _startProcess();
  }

  Future<void> _startProcess() async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      await widget.onFinished(); // run leave + update + refresh
      Get.back();
    } catch (e) {
      print("Error: $e");
      Get.back();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double size = 120;

    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: lightGreyColor, width: 4),
                    ),
                  ),
                  SizedBox(
                    width: size,
                    height: size,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (_, __) {
                        return CustomPaint(
                          painter: ArcPainter(
                            angle: _controller.value * 2 * math.pi,
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: size * 0.6,
                    height: size * 0.6,
                    decoration: BoxDecoration(
                      color: tealColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Leaving your event',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please wait, it may take a minute',
                style: TextStyle(fontSize: 16, color: blackColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Painter for the animated arc
class ArcPainter extends CustomPainter {
  final double angle;
  ArcPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint =
        Paint()
          ..color = primaryColor
          ..strokeWidth = 6
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final startAngle = angle;
    final sweepAngle = math.pi / 4; // 45 degrees

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(ArcPainter oldDelegate) => true;
}
