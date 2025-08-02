import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/core/others/base_view_model.dart';
import 'package:girl_clan/ui/auth/login/login_screen.dart';
import 'package:girl_clan/ui/root_screen/root_screen.dart';

class ProfileViewModel extends BaseViewModel {
  File? image;
  Uint8List? webImage; // for web
  ///
  ///. this is for editing profile screen
  ///
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController surNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  ///
  ///. update user profile
  ///
  final currentUser = FirebaseAuth.instance.currentUser;
  Future<void> updateUserProfileInformation({
    File? image,
    Uint8List? webImage,
  }) async {
    setState(ViewState.busy);
    try {
      // 1. Upload image if provided
      String? imageUrl = await uploadImageToStorage(image, webImage);

      // 2. Get current user data first to preserve existing fields
      final userDoc =
          await FirebaseFirestore.instance
              .collection('app-user')
              .doc(currentUser?.uid)
              .get();

      final existingData = userDoc.data() ?? {};

      // 3. Prepare update data
      final updateData = {
        ...existingData, // Keep existing data
        'firstName': firstNameController.text.trim(),
        'surName': surNameController.text.trim(),
        'location': locationController.text.trim(),
        'phoneNumber': phoneController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
        if (imageUrl != null) 'imgUrl': imageUrl,
      };

      // 4. Update profile
      await FirebaseFirestore.instance
          .collection('app-user')
          .doc(currentUser?.uid)
          .set(updateData, SetOptions(merge: true));

      // 5. Update Firebase Auth display name
      await currentUser?.updateDisplayName(
        '${firstNameController.text.trim()} ${surNameController.text.trim()}',
      );

      // 6. Update photo URL if image was uploaded
      if (imageUrl != null) {
        await currentUser?.updatePhotoURL(imageUrl);
      }

      // 7. Show success and navigate
      Get.offAll(() => RootScreen(selectedScreen: 2));
      Get.snackbar(
        'Profile Updated',
        'Profile updated successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: primaryColor,
        colorText: whiteColor,
      );
    } catch (e) {
      debugPrint('Update failed: $e');
      Get.snackbar(
        'Update Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      setState(ViewState.idle);
    }
  }

  Future<String?> uploadImageToStorage(File? image, Uint8List? webImage) async {
    try {
      final uid = currentUser?.uid;
      if (uid == null) return null;

      final ref = FirebaseStorage.instance.ref().child(
        'profile_images/$uid.jpg',
      );

      UploadTask uploadTask;
      if (kIsWeb && webImage != null) {
        uploadTask = ref.putData(webImage);
      } else if (image != null) {
        uploadTask = ref.putFile(image);
      } else {
        return null;
      }

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Image upload error: $e');
      return null;
    }
  }

  ///
  ///. logout user
  ///

  // In ProfileViewModel
  void clearData() {
    firstNameController.clear();
    surNameController.clear();
    phoneController.clear();
    locationController.clear();
    image = null;
    webImage = null;
  }

  void logoutUser() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Clear viewmodel data first
      clearData();

      await FirebaseAuth.instance.signOut();
      Get.offAll(() => LoginScreen());
    } catch (e) {
      Get.snackbar('Error', e.toString());
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

  // ///
  // ///. validate phone number
  // ///
  // String? validatePhoneNumber(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please enter your phone number';
  //   }
  //   if (value.length < 10) {
  //     return 'Phone number must be at least 10 digits long';
  //   }
  //   final phoneRegex = RegExp(r'^\d+$');
  //   if (!phoneRegex.hasMatch(value)) {
  //     return 'Please enter a valid phone number';
  //   }
  //   return null;
  // }

  @override
  void dispose() {
    firstNameController.dispose();
    surNameController.dispose();
    locationController.dispose();

    phoneController.dispose();
    super.dispose();
  }
}
