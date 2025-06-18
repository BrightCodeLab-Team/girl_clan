import 'dart:async';
import 'package:flutter/material.dart';
import 'package:girl_clan/core/constants/app_assets.dart';

import 'package:girl_clan/ui/auth/welcome_screen.dart'
    show WelcomeScreen; // Update this import to match your file structure

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to WelcomeScreen after 5 seconds
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets().SplashScreenImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
