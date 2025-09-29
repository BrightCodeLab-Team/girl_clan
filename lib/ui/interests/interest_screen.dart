// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/ui/root_screen/root_screen.dart';

class InterestSelectionScreen extends StatefulWidget {
  @override
  _InterestSelectionScreenState createState() =>
      _InterestSelectionScreenState();
}

class _InterestSelectionScreenState extends State<InterestSelectionScreen> {
  final List<String> interests = [
    "Coffee & Chats",
    "Dinner & Drinks",
    "Run",
    "Water sports",
    "Book Club",
    "Games",
    "Mommy & Baby",
    "Sport",
    "Fun",
    "Art & Cultural",
    "Health & Wellbeing",
    "Career & Business",
    "Hobbies & Passions",
    "Dance",
    "Ideas",
    'Party',
    'Concert',
    'Travel',
    'Festival',
    'Hiking',
    'Food & Drinks',
    'Beach Day',
    'Road Trip',
    'Camping',
    'Workshop',
  ];

  final List<String> selectedInterests = [];
  String?
  errorMessage; // ✅ error ko snackbar ke bajaye screen par show karne ke liye

  void toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
      // jab user interact kare to error hata do
      if (selectedInterests.length >= 3) {
        errorMessage = null;
      }
    });
  }

  Future<void> saveInterests() async {
    if (selectedInterests.length < 3) {
      setState(() {
        errorMessage = "Please select at least 3 interests to continue.";
      });
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('app-user')
          .doc(user.uid)
          .update({'interests': selectedInterests});
      Get.offAll(RootScreen());
    }
  }

  Future<void> skipInterests() async {
    // ✅ skip option: bina interests ke bhi aage jaa sakte ho
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('app-user').doc(user.uid).set(
        {'interests': []},
        SetOptions(merge: true),
      );
      Get.offAll(RootScreen());
    }
  }

  Future<void> loadSavedInterests() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('app-user')
              .doc(user.uid)
              .get();
      final saved = doc.data()?['interests'] as List<dynamic>? ?? [];
      setState(() {
        selectedInterests.addAll(saved.map((e) => e.toString()));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadSavedInterests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Your Interests', style: style20B)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              children:
                  interests.map((interest) {
                    final isSelected = selectedInterests.contains(interest);
                    return ChoiceChip(
                      checkmarkColor: whiteColor,
                      selectedColor: primaryColor,
                      backgroundColor: secondaryColor,
                      side: BorderSide.none,
                      label: Text(
                        interest,
                        style: style14.copyWith(color: whiteColor),
                      ),
                      selected: isSelected,
                      onSelected: (_) => toggleInterest(interest),
                    );
                  }).toList(),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              onTap: saveInterests,
              text: 'Save & Continue',
              backgroundColor: primaryColor,
              textColor: whiteColor,
            ),
            const SizedBox(height: 10),
            CustomButton(
              onTap: skipInterests,
              text: 'Skip for now',
              backgroundColor: secondaryColor,
              textColor: whiteColor,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
