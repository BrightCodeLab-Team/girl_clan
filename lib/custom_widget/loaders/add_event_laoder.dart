// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/strings.dart';
import 'package:girl_clan/ui/Event/sucess_screen.dart';

class AddEventLoader extends StatefulWidget {
  final Future Function() addEventCall;
  final String eventName;
  final String eventTime;

  const AddEventLoader({
    required this.addEventCall,
    required this.eventName,
    required this.eventTime,
  });

  @override
  State<AddEventLoader> createState() => _JoiningEventLoaderScreenState();
}

class _JoiningEventLoaderScreenState extends State<AddEventLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _process();
  }

  Future<void> _process() async {
    try {
      // wait at least 3 seconds to show loader
      await Future.delayed(Duration(seconds: 3));
      widget.addEventCall();
      Get.offAll(
        () => SuccessScreen(
          image: '$staticAssets/success1.png',
          title: 'Congratulations!',
          subtitle: 'Successfully Created  the event',
        ),
      );
    } catch (e) {
      print("Error: $e");
      Get.snackbar("Error", 'Please add event again');
      // Get.off(() => const ErrorScreen());
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
      backgroundColor: whiteColor, // very light background like in image
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Loader with rotating arc
              Stack(
                alignment: Alignment.center,
                children: [
                  // Grey background circle
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: lightGreyColor, width: 4),
                    ),
                  ),
                  // Rotating colored arc
                  SizedBox(
                    width: size,
                    height: size,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: ArcPainter(
                            angle: _controller.value * 2 * math.pi,
                          ),
                        );
                      },
                    ),
                  ),
                  // Center circle with icon or image
                  Container(
                    width: size * 0.6,
                    height: size * 0.6,
                    decoration: BoxDecoration(
                      color: tealColor, // teal color like in image
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.bar_chart, // similar icon to your screenshot
                        color: whiteColor,
                        size: 30,
                      ),
                      // If you want to use your uploaded image instead:
                      // child: Image.asset('assets/success.png', width: 30, height: 30),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(
                'Joining your event',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Please wait it may take a minute',
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
    final sweepAngle = math.pi / 4; // 45 degrees arc

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(ArcPainter oldDelegate) => true;
}
