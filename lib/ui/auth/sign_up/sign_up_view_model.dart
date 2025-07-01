import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/others/base_view_model.dart';

class SignUpViewModel extends BaseViewModel {
  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners(); // or update() if using GetX
  }

  ///
  ///  controllers
  ///
  TextEditingController firstNameController = TextEditingController();
  TextEditingController surNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  ///
  ///
  ///
  FirebaseAuth auth = FirebaseAuth.instance;

  ///
  ///
  ///
  ///
  ///. regex
  ///
  final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    caseSensitive: false,
  );

  ///
  /// validate first name
  ///
  String? validateFirstName(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your first name';
    } else {
      return null;
    }
  }

  ///
  /// validate surname
  ///
  String? validateSurName(String? value) {
    if (value!.trim().isEmpty) {
      return 'Please enter your surname';
    } else {
      return null;
    }
  }

  ///
  ///  validate email Address
  ///
  String? validateEmail(String? value) {
    if (value!.trim().isEmpty) {
      return 'Enter your email';
    }
    // else if (!emailRegex.hasMatch(value)) {
    //   return "enter valid email e.g abc@gmail.com";
    // }
    return null;
  }

  ///
  ///  validate password
  ///
  String? validatePassword(String? value) {
    if (value!.trim().isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 7) {
      return 'Password must be at least 7 character ';
    }
    return null;
  }

  ///
  ///. signIn user
  ///

  Future<void> signInUser() async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.snackbar("Success", "User signed up");
    } on FirebaseAuthException catch (e) {
      print("signIN failed $e");
      Get.snackbar("Error", e.message ?? "Registration failed");
    }
  }

  ///
  ///. user detail to firestore
  ///

  Future<bool> uploadUserDetailToFireStoreDatabase() async {
    final user = auth.currentUser;

    if (user == null) {
      print("No user is signed in");
      return false;
    }

    try {
      final userdata = await FirebaseFirestore.instance
          .collection('app-user')
          .doc(user.uid)
          .set({
            'id': user.uid,
            'firstName': firstNameController.text.trim(),
            'surName': surNameController.text.trim(),
            'email': emailController.text.trim(),
            'password': passwordController.text.trim(),
            'date': DateTime.now().toIso8601String(),
            'phoneNumber': phoneNumberController.text.trim(),
            'location': locationController.text.trim(),
          });

      Get.snackbar('Success', "User details added to database");
      return true;
    } catch (e) {
      print('Uploading user details failed: $e');
      Get.snackbar('Error', "Failed to add user details");
      return false;
    }
  }
}
