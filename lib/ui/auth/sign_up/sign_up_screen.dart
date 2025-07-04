import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/ui/auth/login/login_screen.dart';
import 'package:girl_clan/ui/auth/sign_up/sign_up_view_model.dart';
import 'package:girl_clan/ui/root_screen/root_screen.dart';
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
    return ChangeNotifierProvider(
      create: (context) => SignUpViewModel(),
      child: Consumer<SignUpViewModel>(
        builder:
            (context, model, child) => Scaffold(
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.verticalSpacingDiagonal,
                        Center(
                          child: Image.asset(
                            AppAssets().appLogo,
                            height: 112,
                            width: 112,
                          ),
                        ),

                        15.verticalSpace,
                        Center(
                          child: Text("SignUp", style: style25B.copyWith()),
                        ),
                        const SizedBox(height: 10),

                        Text("First Name", style: style16.copyWith()),
                        3.verticalSpace,
                        TextFormField(
                          decoration: customAuthField3.copyWith(
                            hintText: "First Name",
                          ),
                          controller: model.firstNameController,
                          validator: model.validateFirstName,
                        ),
                        10.verticalSpace,
                        Text("Surname", style: style16.copyWith()),
                        3.verticalSpace,
                        TextFormField(
                          decoration: customAuthField3.copyWith(
                            hintText: "Surname",
                          ),
                          controller: model.surNameController,
                          validator: model.validateSurName,
                        ),

                        Text("Email Address", style: style16.copyWith()),
                        3.verticalSpace,
                        TextFormField(
                          decoration: customAuthField3.copyWith(
                            hintText: "emial Address",
                          ),
                          controller: model.emailController,
                          validator: model.validateEmail,
                        ),
                        10.verticalSpace,
                        Text("Password", style: style16.copyWith()),
                        3.verticalSpace,
                        TextFormField(
                          obscureText: true,
                          decoration: customAuthField3.copyWith(
                            hintText: "Enter your password",
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
                              activeColor: Colors.blue,
                              checkColor: Colors.white,
                            ),
                            const Text('Check if you are female.'),
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
                                      try {
                                        print("Tapped");
                                        print(
                                          "user name: ${model.firstNameController.text}${model.surNameController.text}",
                                        );
                                        print(
                                          "user email: ${model.emailController.text}",
                                        );
                                        print(
                                          "user phone: ${model.passwordController.text}",
                                        );

                                        if (_formKey.currentState!.validate()) {
                                          model.setLoading(true); // Show loader

                                          await model.signInUser();
                                          bool isUploaded =
                                              await model
                                                  .uploadUserDetailToFireStoreDatabase();

                                          model.setLoading(
                                            false,
                                          ); // Hide loader

                                          if (isUploaded) {
                                            Get.offAll(RootScreen());
                                          } else {
                                            Get.snackbar(
                                              "Error",
                                              "Failed to upload user details",
                                            );
                                          }
                                        } else {
                                          print("Form is not valid");
                                        }
                                      } catch (e) {
                                        model.setLoading(false);
                                        print("Error in onTap: $e");
                                      }
                                    },
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
                                Get.offAll(LoginScreen());
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
      ),
    );
  }
}
