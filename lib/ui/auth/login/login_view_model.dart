import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/core/others/base_view_model.dart';

class LoginViewModel extends BaseViewModel {
  bool loading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool agreeToTerms = false;
  bool showTermsError = false;
  static const String termsLastUpdated = 'April 2026';

  bool isPasswordVisible = true;

  void setAgreeToTerms(bool value) {
    agreeToTerms = value;
    if (value) showTermsError = false;
    notifyListeners();
  }

  void setShowTermsError(bool value) {
    showTermsError = value;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  ///
  ///. login user if user is already  signUp
  ///
  final auth = FirebaseAuth.instance;
  String message = "";

  /// Returns `null` on success, or an error message for the UI.
  Future<String?> loginUser() async {
    setState(ViewState.busy);
    try {
      await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = auth.currentUser?.uid;
      if (uid != null && agreeToTerms) {
        await FirebaseFirestore.instance.collection('app-user').doc(uid).set({
          'termsAccepted': true,
          'termsAcceptedAt': FieldValue.serverTimestamp(),
          'termsLastUpdated': termsLastUpdated,
        }, SetOptions(merge: true));
      }

      return null;
    } on FirebaseAuthException catch (error) {
      print("Firebase Error Code: ${error.code}");
      print("Firebase Error Message: ${error.message}");
      if (error.code == 'user-not-found') {
        message = "This email is not registered. Please sign up first.";
      } else if (error.code == 'wrong-password') {
        message = "The password you entered is incorrect.";
      } else if (error.code == 'invalid-email') {
        message = "Please enter a valid email address.";
      } else if (error.code == 'user-disabled') {
        message = "This account has been disabled by the administrator.";
      } else {
        message = "Invalid email or password.";
      }
      return message;
    } catch (e) {
      return "Something went wrong. Please try again.";
    } finally {
      setState(ViewState.idle);
    }
  }

  ///
  ///. validate email
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
}
