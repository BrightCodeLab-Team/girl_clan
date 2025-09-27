import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/core/others/base_view_model.dart';
import 'package:girl_clan/ui/root_screen/root_screen.dart';

class LoginViewModel extends BaseViewModel {
  bool loading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = true;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  ///
  ///. login user if user is already  signUp
  ///
  final auth = FirebaseAuth.instance;
  String message = "Login failed";

  Future<void> LoginUser() async {
    setState(ViewState.busy);
    try {
      await auth
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          )
          .then((onValue) {
            Get.offAll(RootScreen());

            Get.snackbar(
              "Success",
              "Login successfully",
              colorText: whiteColor,
              backgroundColor: secondaryColor,
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 4),
            );
          })
          .catchError((error) {
            if (error is FirebaseAuthException) {
              String message = "Login failed";

              if (error.code == 'user-not-found') {
                message = "This email is not registered. Please sign up first.";
              } else if (error.code == 'wrong-password') {
                message = "The password you entered is incorrect.";
              } else if (error.code == 'invalid-email') {
                message = "Please enter a valid email address.";
              }

              Get.snackbar(
                "Error",
                message,
                backgroundColor: secondaryColor,
                colorText: whiteColor,
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
              );
            } else {
              Get.snackbar(
                "Error",
                "Something went wrong. Please try again.",
                backgroundColor: secondaryColor,
                colorText: whiteColor,
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 4),
              );
            }
            notifyListeners();
          });
    } catch (e) {
      print("Login Failed $e");
    }
    setState(ViewState.idle);
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
