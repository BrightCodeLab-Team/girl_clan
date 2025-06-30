import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girl_clan/ui/profile/profile_screen.dart';

class PasswordViewModel extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  bool _isLoading = false;
  bool _isInvalidCurrent = false;

  bool get isLoading => _isLoading;
  bool get isInvalidCurrent => _isInvalidCurrent;

  // Validate current password
  Future<bool> validateCurrentPassword(String currentPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      final doc = await _db.collection('App-user').doc(user.uid).get();
      if (doc.exists) {
        final userData = doc.data();
        return userData?['password'] == currentPassword;
      }
      return false;
    } catch (e) {
      debugPrint('Error validating current password: $e');
      return false;
    }
  }

  // Update user password
  Future<bool> updatePassword(String newPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      await _db.collection('App-user').doc(user.uid).update({
        'password': newPassword,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      debugPrint('Error updating password: $e');
      return false;
    }
  }

  // Main function to handle password change
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      _isLoading = true;
      _isInvalidCurrent = false;
      notifyListeners();

      // Validate inputs
      if (newPassword != confirmPassword) {
        Get.snackbar(
          'Error',
          'Passwords do not match',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (newPassword.length < 6) {
        Get.snackbar(
          'Error',
          'Password must be at least 6 characters',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Validate current password
      final isValid = await validateCurrentPassword(currentPassword);
      if (!isValid) {
        _isInvalidCurrent = true;
        notifyListeners();
        Get.snackbar(
          'Error',
          'Current password is incorrect',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Update password
      final success = await updatePassword(newPassword);
      if (success) {
        Get.snackbar(
          'Success',
          'Password changed successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.off(() => ProfileScreen());
      } else {
        Get.snackbar(
          'Error',
          'Failed to update password',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
