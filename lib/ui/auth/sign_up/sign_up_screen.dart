// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/ui/auth/login/login_screen.dart';
import 'package:girl_clan/ui/auth/sign_up/email_verification_screen.dart';
import 'package:girl_clan/ui/auth/sign_up/sign_up_view_model.dart';
import 'package:girl_clan/ui/auth/sign_up/sign_up_extra_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isChecked = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpViewModel>(
      builder:
          (context, model, child) => ModalProgressHUD(
            inAsyncCall: model.state == ViewState.busy,
            child: Scaffold(
              backgroundColor: whiteColor,
              body: Container(
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1,
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //     image: AssetImage("$staticAssets/loginImage.jpg"),
                //     fit: BoxFit.cover,
                //   ),
                // ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          60.verticalSpace,
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (_) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.camera_alt),
                                          title: Text("Take a photo"),
                                          onTap: () {
                                            Navigator.pop(context);
                                            model.pickImageFromCamera();
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.photo),
                                          title: Text("Choose from gallery"),
                                          onTap: () {
                                            Navigator.pop(context);
                                            model.pickImageFromGallery();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 56,
                                    backgroundColor: blackColor,
                                    child:
                                        model.profileImage != null
                                            ? Image.file(
                                              model.profileImage!,
                                              fit: BoxFit.cover,
                                            )
                                            : Image.asset(
                                              AppAssets().profileIcon,
                                              fit: BoxFit.cover,
                                              color: whiteColor,
                                            ),
                                  ),

                                  CircleAvatar(
                                    backgroundColor: whiteColor,
                                    radius: 17,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: blackColor,
                                      size: 19,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          15.verticalSpace,
                          Text(
                            "Register Your Account",
                            style: style25B.copyWith(color: blackColor),
                          ),
                          10.verticalSpace,

                          Text(
                            "First Name",
                            style: style16B.copyWith(color: blackColor),
                          ),
                          6.verticalSpace,
                          TextFormField(
                            decoration: customAuthField3.copyWith(
                              hintText: "First Name",
                            ),
                            controller: model.firstNameController,
                            validator: model.validateFirstName,
                          ),
                          20.verticalSpace,
                          Text(
                            "Surname",
                            style: style16B.copyWith(color: blackColor),
                          ),
                          6.verticalSpace,
                          TextFormField(
                            decoration: customAuthField3.copyWith(
                              hintText: "Surname",
                            ),
                            controller: model.surNameController,
                            validator: model.validateSurName,
                          ),
                          20.verticalSpace,
                          Text(
                            "Email Address",
                            style: style16B.copyWith(color: blackColor),
                          ),
                          6.verticalSpace,
                          TextFormField(
                            decoration: customAuthField3.copyWith(
                              hintText: "Email Address",
                            ),
                            controller: model.emailController,
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode:
                                AutovalidateMode
                                    .onUserInteraction, // ✅ turant validation
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email is required";
                              }
                              // ✅ simple regex for valid email
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );
                              if (!emailRegex.hasMatch(value)) {
                                return "Please enter a valid email address";
                              }
                              return null;
                            },
                          ),

                          20.verticalSpace,
                          Text(
                            "Password",
                            style: style16B.copyWith(color: blackColor),
                          ),
                          6.verticalSpace,
                          TextFormField(
                            obscureText: model.isPasswordVisible,
                            decoration: customAuthField3.copyWith(
                              hintText: "Enter Your Password",

                              suffixIcon: IconButton(
                                icon: Icon(
                                  model.isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  model.togglePasswordVisibility();
                                },
                              ),
                            ),

                            controller: model.passwordController,
                            validator: model.validatePassword,
                          ),
                          6.verticalSpace,
                          Row(
                            children: [
                              Checkbox(
                                side: BorderSide(
                                  color: secondaryColor,
                                  width: 2,
                                ),
                                value: _isChecked,
                                onChanged: (value) {
                                  setState(() => _isChecked = value!);
                                },
                              ),
                              const Text("I confirm I am female"),
                            ],
                          ),
                          if (!_isChecked)
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Please confirm that you are female",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          20.verticalSpace,

                          Center(
                            child:
                                model.isLoading
                                    ? Center(
                                      child: CircularProgressIndicator(
                                        color: secondaryColor,
                                      ),
                                    )
                                    : CustomButton(
                                      text: "Next",
                                      backgroundColor: primaryColor,
                                      onTap: () async {
                                        if (_formKey.currentState!.validate() &&
                                            _isChecked) {
                                          bool success =
                                              await model.signUpUser();
                                          if (success) {
                                            // ✅ pehle email verification screen pe le jao
                                            Get.to(
                                              () => EmailVerificationScreen(
                                                email:
                                                    "${model.emailController.text}",
                                              ),
                                            );
                                          }
                                        } else if (!_isChecked) {
                                          // checkbox error alag se dikhana
                                          Get.snackbar(
                                            "Notice",
                                            "Please confirm that you are female",
                                            backgroundColor: secondaryColor,
                                            colorText: Colors.white,
                                          );
                                        }
                                      },
                                    ),
                          ),
                          20.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Don’t have an account? ",
                                style: style16.copyWith(color: blackColor),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.offAll(LoginScreen());
                                },
                                child: Text(
                                  "Login ",
                                  style: style16B.copyWith(color: primaryColor),
                                ),
                              ),
                            ],
                          ),
                          51.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
