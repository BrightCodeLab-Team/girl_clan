// ignore_for_file: unused_local_variable, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/core/others/base_view_model.dart';
import 'package:girl_clan/ui/root_screen/root_screen.dart';
import 'package:image_picker/image_picker.dart';

class SignUpViewModel extends BaseViewModel {
  bool isLoading = false;
  File? profileImage;
  String? uploadedImageUrl;
  List<String> selectedInterests = [];

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

  TextEditingController countryController = TextEditingController();
  TextEditingController dobController =
      TextEditingController(); // or store DateTime
  TextEditingController nationalityController = TextEditingController();

  bool agreeToTerms = false;

  onclickTerms(newValue) {
    agreeToTerms = newValue ?? false;
    notifyListeners();
  }

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
  /// validate Phone number
  ///
  String? validatePhoneNumber(String? value) {
    if (value!.trim().isEmpty) {
      return 'Please enter your Phone Number';
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

  String? validateCountry(String? value) {
    if (value!.trim().isEmpty) return 'Please select your country/region';
    return null;
  }

  String? validateDob(String? value) {
    if (value!.trim().isEmpty) return 'Please enter your date of birth';
    return null;
  }

  String? validateNationality(String? value) {
    if (value!.trim().isEmpty) return 'Please enter your nationality';
    return null;
  }

  final picker = ImagePicker();

  Future<void> pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> uploadProfileImageToFirebase() async {
    if (profileImage == null) return;

    final storageRef = FirebaseStorage.instance
        .ref()
        .child("profile_images")
        .child("${DateTime.now().millisecondsSinceEpoch}.jpg");

    UploadTask uploadTask = storageRef.putFile(profileImage!);
    TaskSnapshot snapshot = await uploadTask;
    uploadedImageUrl = await snapshot.ref.getDownloadURL();
  }

  ///
  ///. signIn user
  ///

  Future<void> signInUser() async {
    setState(ViewState.busy);
    try {
      await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print("signIN failed $e");
      Get.snackbar("Error", e.message ?? "Registration failed");
    }
    setState(ViewState.idle);
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
            'country': countryController.text.trim(),
            'dob': dobController.text.trim(),
            'nationality': nationalityController.text.trim(),
            'imgUrl': uploadedImageUrl ?? "",
            'interests': selectedInterests, // ✅ yahan interests bhi save ho gai
          });

      return true;
    } catch (e) {
      print('Uploading user details failed: $e');
      Get.snackbar('Error', "Failed to add user details");
      return false;
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    surNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    locationController.dispose();
    countryController.dispose();
    dobController.dispose();
    nationalityController.dispose();

    super.dispose();
  }
}
