import 'package:flutter/material.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/ui/password/confirm_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());
  int timer = 35;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() async {
    while (timer > 0) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() {
        timer--;
      });
    }
  }

  void _verify() {
    bool isComplete = otpControllers.every(
      (controller) => controller.text.isNotEmpty,
    );

    if (isComplete) {
      // OTP verified
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("OTP Verified!")));

      // Navigate to Change Password screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ConfirmPasswordScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all OTP digits")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(18));

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("OTP Verification", style: style25B.copyWith(fontSize: 22)),
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.only(left: 15),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: thinGreyColor,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_sharp),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Enter the OTP sent to your email to verify your account.",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 46,
                  height: 50,
                  child: TextField(
                    controller: otpControllers[index],
                    focusNode: focusNodes[index],
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(borderRadius: borderRadius),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        focusNodes[index + 1].requestFocus();
                      }
                      if (value.isEmpty && index > 0) {
                        focusNodes[index - 1].requestFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            Text(
              "00:${timer.toString().padLeft(2, '0')}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                setState(() {
                  timer = 35;
                  startTimer();
                });
              },
              child: const Text(
                "Send again",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const Spacer(),
            CustomButton(
              onTap: _verify,
              text: 'Verify',
              backgroundColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
