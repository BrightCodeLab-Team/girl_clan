// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/core/utils/app_messenger.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/ui/root_screen/root_screen.dart';
import 'package:girl_clan/ui/auth/login/login_view_model.dart';
import 'package:girl_clan/ui/auth/sign_up/sign_up_screen.dart';
import 'package:girl_clan/ui/auth/terms_and_condition_screen.dart';
import 'package:girl_clan/ui/password/forget_password_screen.dart';
import 'package:girl_clan/ui/password/privacy_policy_screen.dart';
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
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        70.verticalSpacingDiagonal,
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
                        16.verticalSpace,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              side: BorderSide(color: secondaryColor, width: 2),
                              value: model.agreeToTerms,
                              onChanged: (v) => model.setAgreeToTerms(v ?? false),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Wrap(
                                  children: [
                                    Text(
                                      'I agree to the ',
                                      style: style16.copyWith(
                                        color: blackColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final agreed = await Get.to(
                                          () => TermsScreen(
                                            title: 'Terms of Use & Community Guidelines',
                                          ),
                                        );
                                        if (agreed == true) {
                                          model.setAgreeToTerms(true);
                                        }
                                      },
                                      child: Text(
                                        'Terms of Use & Community Guidelines',
                                        style: style16B.copyWith(
                                          color: primaryColor,
                                          fontSize: 13,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      ' and ',
                                      style: style16.copyWith(
                                        color: blackColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => const PrivacyPolicyScreen());
                                      },
                                      child: Text(
                                        'Privacy Policy',
                                        style: style16B.copyWith(
                                          color: primaryColor,
                                          fontSize: 13,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '.',
                                      style: style16.copyWith(
                                        color: blackColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (model.showTermsError && !model.agreeToTerms)
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text(
                              'Please accept the Terms of Use to continue',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        20.verticalSpace,

                        Center(
                          child: CustomButton(
                            onTap: () async {
                              if (!_formKey.currentState!.validate()) {
                                AppMessenger.show(
                                  context,
                                  'Please enter your email and password',
                                  isError: true,
                                );
                                return;
                              }

                              if (!model.agreeToTerms) {
                                model.setShowTermsError(true);
                                AppMessenger.show(
                                  context,
                                  'Please accept the Terms of Use & Community Guidelines',
                                  isError: true,
                                );
                                return;
                              }

                              final error = await model.loginUser();
                              if (!context.mounted) return;
                              if (error != null) {
                                AppMessenger.show(context, error, isError: true);
                                return;
                              }

                              AppMessenger.show(context, 'Login successful');
                              Get.offAll(() => RootScreen());
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
          );
        },
      ),
    );
  }
}
