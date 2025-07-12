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

  void toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
  }

  Future<void> saveInterests() async {
    if (selectedInterests.length < 3) {
      Get.snackbar(
        'Select at least 3',
        'Please select at least 3 interests to continue.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: secondaryColor,
        colorText: Colors.white,
      );
      return;
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('app-user')
          .doc(user.uid)
          .update({'interests': selectedInterests});
      // Navigate to root screen
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
        child: Wrap(
          spacing: 10,
          children:
              interests.map((interest) {
                final isSelected = selectedInterests.contains(interest);
                return ChoiceChip(
                  checkmarkColor: whiteColor,
                  selectedColor: primaryColor,
                  backgroundColor: secondaryColor,
                  selectedShadowColor: blackColor,
                  side: BorderSide.none, // <-- yahan border remove kiya
                  label: Text(
                    interest,
                    style: style14.copyWith(color: whiteColor),
                  ),

                  selected: isSelected,
                  onSelected: (_) => toggleInterest(interest),
                );
              }).toList(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomButton(
          onTap: saveInterests,
          text: 'Save & Continue',
          backgroundColor: primaryColor,
          textColor: whiteColor,
        ),
      ),
    );
  }
}
