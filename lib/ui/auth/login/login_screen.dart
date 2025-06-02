import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/app_assest.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/ui/auth/forget/forget_screen.dart';
import 'package:girl_clan/ui/auth/login/login_view_model.dart';
import 'package:girl_clan/ui/auth/sign_up/sign_up_screen.dart';
import 'package:girl_clan/ui/home/home_view_model.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppAssets().loginImage),
                  fit: BoxFit.cover,
                ),
              ),

              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    15.verticalSpacingDiagonal,
                    Center(
                      child: Image.asset(
                        AppAssets().appLogo,
                        height: 112,
                        width: 112,
                      ),
                    ),

                    15.verticalSpace,
                    Center(
                      child: Text(
                        "Login",
                        style: style25B.copyWith(
                          fontSize: 24,
                          color: whiteColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Email Address",
                      style: style16.copyWith(color: whiteColor),
                    ),
                    1.verticalSpace,
                    TextFormField(
                      decoration: customAuthField3.copyWith(
                        hintText: "emial Address",
                      ),
                    ),
                    10.verticalSpace,
                    Text(
                      "password",
                      style: style16.copyWith(color: whiteColor),
                    ),
                    1.verticalSpace,
                    TextFormField(
                      obscureText: true,
                      decoration: customAuthField3.copyWith(
                        hintText: "password",
                      ),
                    ),
                    10.verticalSpace,
                    Align(
                      alignment: Alignment.topRight,

                      child: GestureDetector(
                        onTap: () {
                          Get.to(ForgetScreen());
                        },
                        child: Text(
                          "Forgot Password?",
                          style: style16.copyWith(
                            color: whiteColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    20.verticalSpace,

                    Center(
                      child: Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.to(HomeScreen());
                          },
                          child: Container(
                            height: 45.h,
                            width: 71.w,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Login",
                                style: style20.copyWith(
                                  color: whiteColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    30.verticalSpace,
                    Row(
                      children: [
                        Text(
                          "Don’t have an account? ",
                          style: style16.copyWith(color: whiteColor),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(SignUpScreen());
                          },
                          child: Text(
                            "signUp ",
                            style: style16.copyWith(color: primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
