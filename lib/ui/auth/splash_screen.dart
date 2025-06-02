import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/app_assest.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/ui/auth/login/login_screen.dart';
import 'package:girl_clan/ui/auth/sign_up/sign_up_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets().splashImage),
            fit: BoxFit.cover,
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(AppAssets().appLogo, height: 150, width: 150),
            ),
            const SizedBox(height: 30),

            Text(
              "Welcome",
              style: style25B.copyWith(color: whiteColor, fontSize: 25),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            Text(
              "thanks For Joining",
              style: style16B.copyWith(color: whiteColor, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              "access Or Create Account",
              style: style16B.copyWith(color: whiteColor, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              "ge Started On Journey",
              style: style16B.copyWith(color: whiteColor, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 80),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(LoginScreen());
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
                    10.horizontalSpace,
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(SignUpScreen());
                        },
                        child: Container(
                          height: 45.h,
                          width: 71.w,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Sign up",
                              style: style20.copyWith(
                                color: whiteColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
