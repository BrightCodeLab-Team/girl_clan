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
              body: Container(
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("$staticAssets/loginImage.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
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
                                    backgroundColor: Colors.white,
                                    backgroundImage:
                                        model.profileImage != null
                                            ? FileImage(model.profileImage!)
                                            : AssetImage(
                                                  AppAssets().profileIcon,
                                                )
                                                as ImageProvider,
                                  ),

                                  CircleAvatar(
                                    backgroundColor: whiteColor,
                                    radius: 15,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: blackColor,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          15.verticalSpace,
                          Center(
                            child: Text(
                              "SignUp",
                              style: style25B.copyWith(color: whiteColor),
                            ),
                          ),
                          const SizedBox(height: 10),

                          Text(
                            "First Name",
                            style: style16.copyWith(color: whiteColor),
                          ),
                          3.verticalSpace,
                          TextFormField(
                            decoration: customAuthField3.copyWith(
                              hintText: "First Name",
                            ),
                            controller: model.firstNameController,
                            validator: model.validateFirstName,
                          ),
                          10.verticalSpace,
                          Text(
                            "Surname",
                            style: style16.copyWith(color: whiteColor),
                          ),
                          3.verticalSpace,
                          TextFormField(
                            decoration: customAuthField3.copyWith(
                              hintText: "Surname",
                            ),
                            controller: model.surNameController,
                            validator: model.validateSurName,
                          ),

                          Text(
                            "Email Address",
                            style: style16.copyWith(color: whiteColor),
                          ),
                          3.verticalSpace,
                          TextFormField(
                            decoration: customAuthField3.copyWith(
                              hintText: "Emial Address",
                            ),
                            controller: model.emailController,
                            validator: model.validateEmail,
                          ),
                          10.verticalSpace,
                          Text(
                            "Password",
                            style: style16.copyWith(color: whiteColor),
                          ),
                          3.verticalSpace,
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
                          3.verticalSpace,
                          Row(
                            children: [
                              Checkbox(
                                value: _isChecked,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    _isChecked = newValue ?? false;
                                  });
                                },
                                activeColor: primaryColor,
                              ),

                              Text(
                                'Check if you are female.',
                                style: style16.copyWith(color: whiteColor),
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
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                        } else if (_formKey.currentState!
                                            .validate()) {
                                          Get.to(() => SignUpExtraScreen());
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
                                style: style16.copyWith(color: whiteColor),
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
