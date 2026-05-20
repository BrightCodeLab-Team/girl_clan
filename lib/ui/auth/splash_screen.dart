import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/ui/auth/sign_up/email_verification_screen.dart';
import 'package:girl_clan/ui/auth/welcome_screen.dart';
import 'package:girl_clan/ui/root_screen/root_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkUser());
  }

  Future<void> _navigateTo(Widget screen) async {
    if (!mounted) return;
    Get.offAll(() => screen);
  }

  Future<void> checkUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      await _navigateTo(const WelcomeScreen());
      return;
    }

    try {
      await user.reload().timeout(const Duration(seconds: 3));
    } on FirebaseAuthException catch (_) {
      await FirebaseAuth.instance.signOut();
      await _navigateTo(const WelcomeScreen());
      return;
    } on TimeoutException {
      await FirebaseAuth.instance.signOut();
      await _navigateTo(const WelcomeScreen());
      return;
    }

    final refreshedUser = FirebaseAuth.instance.currentUser;
    if (refreshedUser == null) {
      await _navigateTo(const WelcomeScreen());
      return;
    }

    if (refreshedUser.emailVerified) {
      await _navigateTo(RootScreen());
    } else {
      await _navigateTo(
        EmailVerificationScreen(email: refreshedUser.email ?? ''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryColor, secondaryColor],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppAssets().appLogo, height: 120, width: 120),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(whiteColor),
            ),
          ],
        ),
      ),
    );
  }
}
