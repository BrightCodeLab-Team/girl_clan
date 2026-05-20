// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/ui/root_screen/root_screen.dart';

class SuccessScreen extends StatefulWidget {
  String? subtitle;
  String? title;
  String? image;

  SuccessScreen({
    required this.subtitle,
    required this.image,
    required this.title,
  });

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _confettiController.play(); // start animation on screen load
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Center(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // 🎉 Confetti
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: true,
                emissionFrequency: 0.05,
                numberOfParticles: 50,
                maxBlastForce: 30,
                minBlastForce: 10,
                gravity: 0.3,
              ),

              // Main content
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "${widget.image}",
                      width: 250,
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${widget.title}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: blackColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.subtitle}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: blackColor),
                    ),
                    const SizedBox(height: 40),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: tealColor,
                        side: const BorderSide(color: tealColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () async {
                        await Get.offAll(() => RootScreen(selectedScreen: 0));
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
