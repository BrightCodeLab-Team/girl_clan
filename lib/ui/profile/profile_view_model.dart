import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/others/base_view_model.dart';
import 'package:girl_clan/ui/auth/sign_up/sign_up_screen.dart';

class ProfileViewModel extends BaseViewModel {
  ///
  ///. this is for editing profile screen
  ///
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController surNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  ///
  ///. update user profile
  ///
  final currentUser = FirebaseAuth.instance.currentUser;
  void updateUserProfileInformation() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('app-user')
          .doc(currentUser!.uid)
          ///
          ///
          ///
          .update({
            'firstName': firstNameController.text.toString(),
            'surName': surNameController.text.toString(),
            'email': emailController.text.toString(),
            'phoneNumber': phoneController.text.toString(),
            'location': locationController.text.toString(),
          })
          .then((value) {
            debugPrint('Profile updated successfully');
          })
          .onError((error, stackTrace) {
            debugPrint('Error updating profile: $error');
          });
    }
  }

  ///
  ///. logout user
  ///

  void logoutUser() async {
    try {
      // Show loading if needed
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Firebase logout
      await FirebaseAuth.instance.signOut();

      // Remove loading
      Get.back();

      // Navigate to signup screen
      Get.offAll(() => SignUpScreen());
    } catch (e) {
      // Remove loading if it was shown
      Get.back();

      // Show error
      Get.snackbar(
        'Logout Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  ///
  ///. validate user name
  ///

  String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters long';
    }
    return null;
  }

  ///
  ///. validate user name
  ///

  String? validateSurName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters long';
    }
    return null;
  }

  ///
  ///. validate location
  ///
  String? validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your location';
    }
    if (value.length < 3) {
      return 'Location must be at least 3 characters long';
    }
    return null;
  }

  ///
  ///. validate email
  ///
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email address';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    if (value.length < 5) {
      return 'Email must be at least 5 characters long';
    }
    return null;
  }

  ///
  ///. validate phone number
  ///
  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.length < 10) {
      return 'Phone number must be at least 10 digits long';
    }
    final phoneRegex = RegExp(r'^\d+$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
}
