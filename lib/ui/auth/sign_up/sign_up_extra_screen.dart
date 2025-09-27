// ignore_for_file: use_key_in_widget_constructors

import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/strings.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/ui/interests/interest_screen.dart';
import 'package:girl_clan/ui/auth/sign_up/location_screen.dart';
import 'package:girl_clan/ui/auth/sign_up/sign_up_view_model.dart';
import 'package:girl_clan/ui/auth/terms_and_condition_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class SignUpExtraScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpViewModel>(
      builder: (context, model, child) {
        return ModalProgressHUD(
          inAsyncCall: model.state == ViewState.busy,
          child: Scaffold(
            backgroundColor: whiteColor,
            body: Container(
              padding: const EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height * 1,
              width: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                // image: DecorationImage(
                //   image: AssetImage("$staticAssets/loginImage.jpg"),
                //   fit: BoxFit.cover,
                // ),
              ),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          "Finish Signing Up",
                          style: style18B.copyWith(color: blackColor),
                        ),
                      ],
                    ),
                    30.verticalSpace,

                    Text(
                      "Please fill this details",
                      style: style18B.copyWith(color: blackColor),
                    ),
                    20.verticalSpace,
                    Text(
                      "Country / Region",
                      style: style16B.copyWith(color: blackColor),
                    ),
                    3.verticalSpace,
                    GestureDetector(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: false, // optional
                          onSelect: (Country country) {
                            model.countryController.text = country.name;
                          },
                        );
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: customAuthField3.copyWith(
                            hintText: "Select Country / Region",
                          ),
                          controller: model.countryController,
                          validator: model.validateCountry,
                        ),
                      ),
                    ),

                    16.verticalSpace,
                    Text(
                      "Date of Birth",
                      style: style16B.copyWith(color: blackColor),
                    ),
                    3.verticalSpace,
                    TextFormField(
                      decoration: customAuthField3.copyWith(
                        hintText: "Birthday (dd/mm/yyyy)",
                      ),
                      controller: model.dobController,
                      validator: model.validateDob,
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),

                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                // background color
                                dialogBackgroundColor: Colors.white,

                                colorScheme: ColorScheme.light(
                                  primary:
                                      primaryColor, // header background & selection color
                                  onPrimary:
                                      Colors
                                          .white, // text color on primary (e.g., year)
                                  onSurface: Colors.black, // default text color
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        primaryColor, // button text color
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (picked != null) {
                          model.dobController.text =
                              "${picked.year}-${picked.month}-${picked.day}";
                        }
                      },
                    ),
                    16.verticalSpace,
                    Text(
                      "Nationality",
                      style: style16B.copyWith(color: blackColor),
                    ),
                    3.verticalSpace,
                    TextFormField(
                      decoration: customAuthField3.copyWith(
                        hintText: "e.g Ireland",
                      ),
                      controller: model.nationalityController,
                      validator: model.validateNationality,
                    ),

                    16.verticalSpace,
                    Text(
                      "Location",
                      style: style16B.copyWith(color: blackColor),
                    ),
                    3.verticalSpace,
                    GestureDetector(
                      onTap: () async {
                        final String? selectedAddress = await Get.to(
                          () => LocationScreen(),
                        );
                        if (selectedAddress != null) {
                          model.locationController.text = selectedAddress;
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          readOnly: true,
                          decoration: customAuthField3.copyWith(
                            hintText: "City / Area",
                          ),
                          controller: model.locationController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your location';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),

                    16.verticalSpace,
                    Text(
                      "Phone Number",
                      style: style16B.copyWith(color: blackColor),
                    ),
                    3.verticalSpace,
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      obscureText: false,
                      decoration: customAuthField3.copyWith(
                        hintText: "Enter Your Phone Number",
                      ),
                      controller: model.phoneNumberController,
                      validator: model.validatePhoneNumber,
                    ),
                    16.verticalSpace,
                    Row(
                      children: [
                        Checkbox(
                          value: model.agreeToTerms,
                          onChanged: (bool? newValue) {
                            model.onclickTerms(newValue);
                          },
                          side: BorderSide(color: secondaryColor),
                          activeColor: secondaryColor,
                          checkColor: whiteColor,
                        ),
                        ConsentText(),
                      ],
                    ),

                    SizedBox(height: 20),
                    CustomButton(
                      onTap: () async {
                        if (_formKey.currentState!.validate() &&
                            model.agreeToTerms) {
                          await model.uploadProfileImageToFirebase();
                          await model.uploadUserDetailToFireStoreDatabase();
                          // Navigate to interest selection
                          Get.to(() => InterestSelectionScreen());
                        } else {
                          Get.snackbar(
                            "Error",
                            "Please complete all fields and agree to terms.",
                          );
                        }
                      },
                      text: "Finish Sign Up",
                      backgroundColor: secondaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ConsentText extends StatefulWidget {
  @override
  State<ConsentText> createState() => _ConsentTextState();
}

class _ConsentTextState extends State<ConsentText> {
  final TapGestureRecognizer _termsRecognizer = TapGestureRecognizer();
  final TapGestureRecognizer _paymentsRecognizer = TapGestureRecognizer();
  final TapGestureRecognizer _policyRecognizer = TapGestureRecognizer();
  final TapGestureRecognizer _privacyRecognizer = TapGestureRecognizer();

  @override
  void initState() {
    super.initState();
    _termsRecognizer.onTap = () {
      Get.to(() => TermsScreen(title: "Terms of Service"));
    };
    _paymentsRecognizer.onTap = () {
      Get.to(() => TermsScreen(title: "Payments Terms of Service"));
    };
    _policyRecognizer.onTap = () {
      Get.to(() => TermsScreen(title: "Nondiscrimination Policy"));
    };
    _privacyRecognizer.onTap = () {
      Get.to(() => TermsScreen(title: "Privacy Policy"));
    };
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _paymentsRecognizer.dispose();
    _policyRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 12, color: Colors.white),
          children: [
            TextSpan(text: "By Selecting Agree and continue, I agree to our "),
            TextSpan(
              text: "Terms of Service",
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: secondaryColor,
                fontWeight: FontWeight.w600,
              ),
              recognizer: _termsRecognizer,
            ),
            TextSpan(text: ", "),
            TextSpan(
              text: "Payments Terms of Service",
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: secondaryColor,
                fontWeight: FontWeight.w600,
              ),
              recognizer: _paymentsRecognizer,
            ),
            TextSpan(text: " and "),
            TextSpan(
              text: "Nondiscrimination Policy",
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: secondaryColor,
              ),
              recognizer: _policyRecognizer,
            ),
            TextSpan(text: " and acknowledge the "),
            TextSpan(
              text: "Privacy Policy",

              style: TextStyle(
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                color: secondaryColor,
              ),
              recognizer: _privacyRecognizer,
            ),
          ],
        ),
      ),
    );
  }
}
