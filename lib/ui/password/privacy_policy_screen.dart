import 'package:flutter/material.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: Text("Privacy Policy", style: style25B.copyWith(fontSize: 22)),
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
        child: ListView(
          children: const [
            Text(
              "Last Updated: 12 Feb, 2025",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              "We respect your privacy. Your personal information — including name, email, location, and event activity — is collected only to improve your experience on the app. We never sell your data and only share details when necessary to deliver core features like event updates, notifications, and personalized suggestions.You’re always in control of your privacy settings.",
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "1. Information We Collect",
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              " We may collect the following types of information:",
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.black,
              ),
            ),
            Text(
              "• Personal Information: Name, email address, phone number, etc.\n"
              "• Usage Data: Information about how you interact with our app/website.\n"
              "• Device Information: IP address, browser type, and operating system.",
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "2. How We Use Your Information",
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "We use your information to:",
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.black,
              ),
            ),
            Text(
              "• Improve our services and user experience.\n"
              "• Provide customer support.\n"
              "• Send updates, notifications, or promotional offers.\n"
              "• Ensure security and prevent fraud.",
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "3. Sharing Your Information",
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "We do not sell your personal data. However, we may share information with:\n"
              "• Service providers assisting in app operations.\n"
              "• Legal authorities if required by law.",
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.black,
              ),
            ),
            Text(
              "We do not sell your personal data. However, we may share information with:\n"
              "• Service providers assisting in app operations.\n"
              "• Legal authorities if required by law.",
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
