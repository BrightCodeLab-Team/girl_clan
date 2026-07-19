// ignore_for_file: unused_local_variable, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/core/others/base_view_model.dart';
import 'package:girl_clan/core/services/notification_services.dart';
import 'package:girl_clan/locator.dart';
import 'package:image_picker/image_picker.dart';

class SignUpViewModel extends BaseViewModel {
  bool isLoading = false;
  File? profileImage;
  String? uploadedImageUrl;
  List<String> selectedInterests = [];

  bool isPasswordVisible = true;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners(); // or update() if using GetX
  }

  bool agreeToTerms = false;
  bool showTermsError = false;

  void onclickTerms(bool? value) {
    agreeToTerms = value ?? false;
    if (agreeToTerms) showTermsError = false; // ✅ hide error jab user tick kare
    notifyListeners();
  }

  static const String termsLastUpdated = 'April 2026';

  void setShowTermsError(bool value) {
    showTermsError = value;
    notifyListeners();
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

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
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
    if (value!.trim().isEmpty) return 'Please select your country';
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

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("profile_images")
          .child("${DateTime.now().millisecondsSinceEpoch}.jpg");

      UploadTask uploadTask = storageRef.putFile(profileImage!);
      TaskSnapshot snapshot = await uploadTask;
      uploadedImageUrl = await snapshot.ref.getDownloadURL();
      print("Image uploaded successfully: $uploadedImageUrl");
    } catch (e) {
      print("Image upload failed: $e");
      rethrow;
    }
  }

  ///
  ///. signUp user
  ///
  /// Returns `null` on success, or an error message to show in the UI.
  Future<String?> signUpUser() async {
    setState(ViewState.busy);
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await userCredential.user?.sendEmailVerification();

      setState(ViewState.idle);
      return null;
    } on FirebaseAuthException catch (e) {
      setState(ViewState.idle);

      if (e.code == 'email-already-in-use') {
        return 'This email is already registered. Please log in or use a different email.';
      }
      return e.message ?? 'Registration failed';
    } catch (e) {
      setState(ViewState.idle);
      return 'Unexpected error: $e';
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
      await FirebaseFirestore.instance.collection('app-user').doc(user.uid).set({
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
        'interests': selectedInterests,
        'termsAccepted': agreeToTerms,
        'termsAcceptedAt': agreeToTerms ? FieldValue.serverTimestamp() : null,
        'termsLastUpdated': termsLastUpdated,
      });

      return true;
    } catch (e) {
      print('Uploading user details failed: $e');
      return false;
    }
  }

  /// Uploads profile image (if any) and saves user details. Returns an error
  /// message on failure, or `null` on success.
  Future<String?> finishSignUp() async {
    setState(ViewState.busy);
    try {
      if (profileImage != null) {
        await uploadProfileImageToFirebase();
      }

      final saved = await uploadUserDetailToFireStoreDatabase();
      if (!saved) {
        return auth.currentUser == null
            ? 'You are not signed in. Please log in and try again.'
            : 'Failed to save your details. Please try again.';
      }

      try {
        await locator<NotificationServices>().saveFcmTokenToFirestore();
      } catch (_) {}

      return null;
    } catch (e) {
      return 'Failed to upload profile image. Please try again.';
    } finally {
      setState(ViewState.idle);
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
