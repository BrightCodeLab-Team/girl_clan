import 'package:flutter/material.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart' show style25B;
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/ui/password/otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _continue() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OtpVerificationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: Text("Forget Passwords", style: style25B.copyWith(fontSize: 22)),
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "Enter your email to receive a reset code and regain access to your account",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Email", style: TextStyle(color: Colors.grey[700])),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: EditProfileFieldDecoration.copyWith(
                  hintText: 'Type your email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const Spacer(),
              CustomButton(
                onTap: _continue,
                text: 'Continue',
                backgroundColor: primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
