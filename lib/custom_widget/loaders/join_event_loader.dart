// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/strings.dart';
import 'package:girl_clan/core/model/event_model.dart';
import 'package:girl_clan/custom_widget/error/sucess_join_event.dart';
import 'package:girl_clan/ui/Event/error_screen.dart';

class JoiningEventLoaderScreen extends StatefulWidget {
  // final Future<void> Function() onClose;
  final EventModel eventModel; // ✅ ADD this

  final Future<bool> Function()
  processCall; // expects process to return true if success
  final String eventName;
  final String eventTime;

  // 👇 Add these two required fields
  final int bookedSeats;
  final int totalSeats;

  const JoiningEventLoaderScreen({
    required this.processCall,
    required this.eventName,
    required this.eventTime,
    required this.bookedSeats,
    required this.totalSeats,
    // required this.onClose, // add this
    required this.eventModel, // ✅ ADD this
  });

  @override
  State<JoiningEventLoaderScreen> createState() =>
      _JoiningEventLoaderScreenState();
}

class _JoiningEventLoaderScreenState extends State<JoiningEventLoaderScreen>
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
      final results = await Future.wait([
        Future.delayed(const Duration(seconds: 3)),
        widget.processCall(),
      ]);

      final bool isSuccess = results[1] as bool;

      if (!mounted) return; // ✅ check if still mounted

      if (isSuccess) {
        if (widget.bookedSeats >= widget.totalSeats) {
          Get.off(() => const ErrorScreen());
        } else {
          Get.offAll(
            () => SuccessJoinEventScreen(
              image: '$staticAssets/success.png',
              title: 'Congratulations!',
              subtitle:
                  'Successfully joined the event at ${widget.eventName} at ${widget.eventTime}',
              // onClose: widget.onClose,
              eventModel: widget.eventModel,
            ),
          );
        }
      } else {
        Get.off(() => const ErrorScreen());
      }
    } catch (e) {
      print("Error: $e");
      if (mounted) {
        Get.off(() => const ErrorScreen());
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double size = 120; // size of circle

    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Loader with rotating arc
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
                        Icons.bar_chart,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Joining your event',
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
