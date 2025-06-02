import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/app_assest.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/ui/auth/forget/forget_screen.dart';
import 'package:girl_clan/ui/auth/login/login_screen.dart';
import 'package:girl_clan/ui/auth/sign_up/sign_up_view_model.dart';
import 'package:girl_clan/ui/home/home_view_model.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpViewModel(),
      child: Consumer<SignUpViewModel>(
        builder:
            (context, model, child) => Scaffold(
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: SingleChildScrollView(
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
                      Center(child: Text("Login", style: style25B.copyWith())),
                      const SizedBox(height: 10),

                      Text("First Name", style: style16.copyWith()),
                      3.verticalSpace,
                      TextFormField(
                        decoration: customAuthField3.copyWith(
                          hintText: "First Name",
                        ),
                      ),
                      10.verticalSpace,
                      Text("Surname", style: style16.copyWith()),
                      3.verticalSpace,
                      TextFormField(
                        obscureText: true,
                        decoration: customAuthField3.copyWith(
                          hintText: "Surname",
                        ),
                      ),

                      Text("Email Address", style: style16.copyWith()),
                      3.verticalSpace,
                      TextFormField(
                        decoration: customAuthField3.copyWith(
                          hintText: "emial Address",
                        ),
                      ),
                      10.verticalSpace,
                      Text("Phone Number", style: style16.copyWith()),
                      3.verticalSpace,
                      TextFormField(
                        obscureText: true,
                        decoration: customAuthField3.copyWith(
                          hintText: "Phone Number",
                        ),
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
                            activeColor: Colors.blue,
                            checkColor: Colors.white,
                          ),
                          const Text('Check if you are female.'),
                        ],
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
                                  "SignUp",
                                  style: style20.copyWith(
                                    fontSize: 20,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      20.verticalSpace,
                      Row(
                        children: [
                          Text(
                            "Don’t have an account? ",
                            style: style16.copyWith(),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(LoginScreen());
                            },
                            child: Text(
                              "Login ",
                              style: style16.copyWith(color: Colors.red),
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
    );
  }
}
