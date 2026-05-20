import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/utils/app_messenger.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/ui/password/forget_password_screen.dart';
import 'package:girl_clan/ui/password/password_view_model.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() {
    return _ChangePasswordScreenState();
  }
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final currentController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();

  bool showCurrent = false;
  bool showNew = false;
  bool showConfirm = false;

  bool isInvalidCurrent = false;

  Future<void> _submit(BuildContext context, PasswordViewModel model) async {
    if (!_formKey.currentState!.validate()) return;

    final error = await model.changePassword(
      currentPassword: currentController.text,
      newPassword: newController.text,
      confirmPassword: confirmController.text,
    );

    if (!context.mounted) return;
    if (error != null) {
      AppMessenger.show(context, error, isError: true);
      return;
    }

    AppMessenger.show(context, 'Password changed successfully');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PasswordViewModel>(
      builder:
          (context, model, child) => Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: Text(
                "Change Password",
                style: style25B.copyWith(fontSize: 22),
              ),
              backgroundColor: Colors.white,
              leading: Padding(
                padding: EdgeInsets.only(left: 15),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: thinGreyColor,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_sharp),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              elevation: 0,
            ),
            backgroundColor: Colors.white,
            body: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Current Password",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    const SizedBox(height: 5),

                    ///
                    ///

                    ///
                    TextFormField(
                      controller: currentController,
                      obscureText: !showCurrent,
                      decoration: EditProfileFieldDecoration.copyWith(
                        hintText: 'Current Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            showCurrent
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: greyBorderColor,
                          ),
                          onPressed: () {
                            setState(() {
                              showCurrent = !showCurrent;
                            });
                          },
                        ),
                      ),
                    ),

                    ///
                    ///
                    ///
                    // if (isInvalidCurrent)
                    //   const Padding(
                    //     padding: EdgeInsets.only(top: 5, left: 8),
                    //     child: Align(
                    //       alignment: Alignment.centerLeft,
                    //       child: Text(
                    //         'Invalid Password',
                    //         style: TextStyle(color: Colors.red, fontSize: 12),
                    //       ),
                    //     ),
                    //   ),
                    const SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "New Password",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    const SizedBox(height: 5),

                    ///
                    ///
                    ///
                    TextFormField(
                      controller: newController,
                      obscureText: !showNew,
                      decoration: EditProfileFieldDecoration.copyWith(
                        hintText: 'New Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            showNew ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              showNew = !showNew;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter new password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),

                    ///
                    ///
                    ///
                    const SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Confirm New Password",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: confirmController,
                      obscureText: !showConfirm,
                      decoration: EditProfileFieldDecoration.copyWith(
                        hintText: 'Confirm New password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            showConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              showConfirm = !showConfirm;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm password';
                        } else if (value != newController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),

                    ///

                    ///

                    ///
                    const Spacer(),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    30.verticalSpace,
                    CustomButton(
                      onTap: () => _submit(context, model),
                      text: 'Change Password',
                      backgroundColor: primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
