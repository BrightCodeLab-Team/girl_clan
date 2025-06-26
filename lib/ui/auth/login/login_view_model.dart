import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/others/base_view_model.dart';
import 'package:girl_clan/ui/root_screen/root_screen.dart';

class LoginViewModel extends BaseViewModel {
  bool loading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  ///
  ///. login user if user is already  signUp
  ///
  final auth = FirebaseAuth.instance;

  // Future<void> LoginUser() async {
  //   loading = true;
  //   notifyListeners();

  //   try {
  //     await auth.signInWithEmailAndPassword(
  //       email: emailController.text.trim(),
  //       password: passwordController.text.trim(),
  //     );

  //     loading = false;
  //     notifyListeners();

  //     Get.snackbar("Login Successful", "User verified");
  //     Get.offAll(() => RootScreen());
  //   } on FirebaseAuthException catch (e) {
  //     loading = false;
  //     // notifyListeners();

  //     String message = "Login failed";

  //     if (e.code == 'user-not-found') {
  //       message = "No user found for that email.";
  //     } else if (e.code == 'wrong-password') {
  //       message = "Wrong password provided.";
  //     } else if (e.code == 'invalid-email') {
  //       message = "Invalid email format.";
  //     }

  //     debugPrint("FirebaseAuthException: ${e.code}");
  //     Get.snackbar("Error", message);
  //   } catch (e) {
  //     loading = false;
  //     notifyListeners();

  //     debugPrint("Unknown error: $e");
  //     Get.snackbar("Error", "Something went wrong. Please try again.");
  //   }
  // }

  Future<void> LoginUser() async {
    try {
      await auth
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          )
          .then((onValue) {
            Get.offAll(Get.to(RootScreen()));

            Get.snackbar("Success", "Login Success");
          })
          // ignore: avoid_types_as_parameter_names
          .onError((error, StackTrace) {
            loading = false;
            Get.snackbar("Error", "Login failed: ${error.toString()}");
            notifyListeners();
          });
    } catch (e) {
      print("Login Failed $e");
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
