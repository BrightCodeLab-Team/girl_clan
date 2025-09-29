// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/ui/auth/login/login_view_model.dart';
import 'package:girl_clan/ui/auth/sign_up/sign_up_screen.dart';
import 'package:girl_clan/ui/password/forget_password_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
        builder: (context, model, child) {
          return ModalProgressHUD(
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
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          25.verticalSpacingDiagonal,
                          Center(
                            child: Image.asset(
                              AppAssets().appLogo,
                              height: 112,
                              width: 112,
                            ),
                          ),

                          40.verticalSpace,
                          Text(
                            "Login Account",
                            style: style25B.copyWith(
                              fontSize: 24,
                              color: blackColor,
                            ),
                          ),
                          20.verticalSpace,
                          Text(
                            "Email Address",
                            style: style16B.copyWith(color: blackColor),
                          ),
                          6.verticalSpace,
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: customAuthField3.copyWith(
                              hintText: "Email Address",
                            ),
                            controller: model.emailController,
                            validator: model.validateEmail,
                          ),
                          6.verticalSpace,
                          Text(
                            "Password",
                            style: style16B.copyWith(color: blackColor),
                          ),
                          1.verticalSpace,
                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: model.isPasswordVisible,
                            decoration: customAuthField3.copyWith(
                              hintText: "Password",
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
                          10.verticalSpace,
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                Get.to(ForgotPasswordScreen());
                              },
                              child: Text(
                                "Forgot Password?",
                                style: style16B.copyWith(color: blackColor),
                              ),
                            ),
                          ),
                          20.verticalSpace,

                          Center(
                            child: CustomButton(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  model.LoginUser();
                                  //Get.offAll(RootScreen());
                                } else {
                                  Get.snackbar(
                                    "Validation",
                                    "Please enter your email and passwords",
                                    backgroundColor: secondaryColor,
                                    colorText: whiteColor,
                                    snackPosition: SnackPosition.TOP,
                                    duration: const Duration(seconds: 4),
                                  );
                                }
                              },
                              text: 'Login',
                              backgroundColor: primaryColor,
                            ),
                          ),
                          30.verticalSpace,
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
                                  Get.offAll(() => SignUpScreen());
                                },
                                child: Text(
                                  "SignUp ",
                                  style: style16B.copyWith(color: primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
