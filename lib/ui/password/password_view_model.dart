import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  /// Returns `null` on success, or an error message for the UI.
  Future<String?> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      _isLoading = true;
      _isInvalidCurrent = false;
      notifyListeners();

      if (newPassword != confirmPassword) {
        return 'Passwords do not match';
      }

      if (newPassword.length < 6) {
        return 'Password must be at least 6 characters';
      }

      final isValid = await validateCurrentPassword(currentPassword);
      if (!isValid) {
        _isInvalidCurrent = true;
        notifyListeners();
        return 'Current password is incorrect';
      }

      final success = await updatePassword(newPassword);
      if (success) return null;
      return 'Failed to update password';
    } catch (e) {
      return 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
