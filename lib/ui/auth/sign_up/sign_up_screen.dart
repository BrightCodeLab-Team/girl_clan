import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/strings.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/ui/auth/login/login_screen.dart';
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
                            "Create An Account",
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
                            validator: model.validateEmail,
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
                                value: _isChecked,
                                side: const BorderSide(
                                  color: primaryColor,
                                  width: 2,
                                ),
                                activeColor:
                                    Colors.pink, // tick ka background color
                                checkColor: Colors.white, // tick ka color
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    _isChecked = newValue ?? false;
                                  });
                                },
                              ),
                              Text(
                                'Check if you are female.',
                                style: style16.copyWith(color: blackColor),
                              ),
                            ],
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
                                      text: "Sign Up",
                                      backgroundColor: primaryColor,
                                      onTap: () async {
                                        if (!_isChecked) {
                                          Get.snackbar(
                                            "Notice",
                                            "Please confirm that you are female by checking the box.",
                                            backgroundColor: secondaryColor,
                                            colorText: Colors.white,
                                          );
                                        } else if (_formKey.currentState!
                                            .validate()) {
                                          bool success =
                                              await model.signInUser();
                                          if (success) {
                                            // ✅ sirf tabhi agle screen pe jao jab email already registered na ho
                                            Get.to(() => SignUpExtraScreen());
                                          }
                                        } else {
                                          print("Form is not valid");
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
