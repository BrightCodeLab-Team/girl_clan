import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/ui/auth/sign_up/sign_up_extra_screen.dart';
import 'package:girl_clan/core/constants/app_assets.dart'; // 👈 logo ka path

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isVerified = false;
  bool isLoading = false; // 👈 Loader ka flag

  @override
  void initState() {
    super.initState();
    checkVerification();
  }

  Future<void> checkVerification() async {
    setState(() {
      isLoading = true; // loader start
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      await user?.reload(); // refresh user status
      setState(() {
        isVerified = user?.emailVerified ?? false;
      });
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        isLoading = false; // loader stop
      });
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      Get.snackbar(
        "Verification Email Sent",
        "Please check your inbox again.",
        backgroundColor: secondaryColor,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to send email: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child:
                isLoading
                    ? const CircularProgressIndicator() // 👈 loader
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 🔹 App logo
                        Image.asset(AppAssets().appLogo, height: 100),
                        const SizedBox(height: 30),

                        // 🔹 Verification Status
                        isVerified
                            ? Column(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 80,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "Your email has been verified successfully!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: blackColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                CustomButton(
                                  text: "Continue",
                                  backgroundColor: primaryColor,
                                  onTap: () {
                                    Get.offAll(() => SignUpExtraScreen());
                                  },
                                ),
                              ],
                            )
                            : Column(
                              children: [
                                Icon(
                                  Icons.mail_outline,
                                  color: secondaryColor,
                                  size: 80,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "Please verify your email before continuing.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: blackColor,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                CustomButton(
                                  text: "I have verified",
                                  backgroundColor: secondaryColor,
                                  onTap: checkVerification,
                                ),
                                const SizedBox(height: 10),
                                TextButton(
                                  onPressed: resendVerificationEmail,
                                  child: const Text(
                                    "Resend verification email",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}
