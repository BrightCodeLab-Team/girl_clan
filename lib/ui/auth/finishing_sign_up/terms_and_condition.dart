import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/ui/auth/login/login_screen.dart';

class TermsAndConditionScreen extends StatelessWidget {
  const TermsAndConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            50.verticalSpace,
            Text("Our community commitment", style: style16B.copyWith()),
            10.verticalSpace,
            Text("Terms & Conditions", style: style25B.copyWith()),
            20.verticalSpace,
            Text(
              textAlign: TextAlign.start,
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
              style: style14.copyWith(),
            ),
            20.verticalSpace,
            GestureDetector(
              onTap: () {
                Get.to(LoginScreen());
              },
              child: Text(
                textAlign: TextAlign.start,
                "Learn more.",
                style: style16B.copyWith(),
              ),
            ),
            30.verticalSpace,
            Center(
              child: CustomButton(
                onTap: () {},
                text: "Agree and Continue",
                backgroundColor: secondaryColor,
              ),
            ),
            10.verticalSpace,
            Center(
              child: CustomButton(
                onTap: () {},
                text: 'Decline',
                textColor: blackColor,
                backgroundColor: transparentColor,
                borderColor: blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
