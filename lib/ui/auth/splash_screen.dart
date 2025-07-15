import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/ui/auth/welcome_screen.dart';
import 'package:girl_clan/ui/root_screen/root_screen.dart'; // Update this import to match your file structure

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
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // User is logged in → Navigate to RootScreen or HomeScreen
        Get.offAll(() => RootScreen());
      } else {
        Get.offAll(() => WelcomeScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: [primaryColor, secondaryColor],
        ),
      ),
      child: Image.asset(AppAssets().appLogo, scale: 4),
    );
  }
}
