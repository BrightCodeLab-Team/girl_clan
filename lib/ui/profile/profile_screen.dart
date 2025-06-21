import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/ui/interests/interest_screen.dart';
import 'package:girl_clan/ui/notification_screen/notification_screen.dart';
import 'package:girl_clan/ui/password/Change_Password_Screen.dart';
import 'package:girl_clan/ui/password/privacy_policy_screen.dart';
import 'package:girl_clan/ui/profile/my_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 375.w,
              height: 234.h,

              decoration: BoxDecoration(
                color: blackColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.r),
                  bottomRight: Radius.circular(40.r),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  20.verticalSpace,
                  CircleAvatar(
                    radius: 60.r,
                    child: Image.asset(AppAssets().appLogo),
                  ),
                  //
                  15.verticalSpace,
                  //
                  Text(
                    'Mate Cruz',
                    style: style18B.copyWith(color: whiteColor),
                  ),
                  Text(
                    'Mateocru912@gmail.com',
                    style: style12.copyWith(color: whiteColor),
                  ),
                ],
              ),
            ),
            //
            20.verticalSpace,
            //
            //
            //  Events row start
            //
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Container(
                    height: 72.h,
                    width: 327.w,
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildEvent('08', 'Join events'),
                          VerticalDivider(),
                          buildEvent('03', 'My events'),
                          VerticalDivider(),
                          buildEvent('02', 'Upcoming events'),
                        ],
                      ),
                    ),
                  ),
                  //
                  // events row end
                  //
                  //
                  20.verticalSpace,

                  //
                  //
                  // Menu selection start
                  //
                  Container(
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(32.r),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 15, top: 25),
                            child: Text(
                              'Account',
                              style: style12.copyWith(
                                fontSize: 10,
                                // ignore: deprecated_member_use
                                color: blackColor.withOpacity(0.4),
                              ),
                            ),
                          ),
                          buildMenuItem('My Profile', () {
                            Get.to(MyProfileScreen());
                          }),
                          buildMenuItem('My Interests', () {
                            Get.to(InterestScreen(selected: []));
                          }),
                          buildMenuItem('Notification', () {
                            Get.to(NotificationScreen());
                          }),

                          Padding(
                            padding: EdgeInsets.only(left: 15, top: 20),
                            child: Text(
                              'Setting',
                              style: style12.copyWith(
                                fontSize: 10,
                                // ignore: deprecated_member_use
                                color: blackColor.withOpacity(0.4),
                              ),
                            ),
                          ),

                          buildMenuItem('Change Password', () {
                            try {
                              Get.to(() => ChangePasswordScreen());
                            } catch (e, stackTrace) {
                              // ignore: avoid_print
                              print('Navigation failed: $e');
                              // ignore: avoid_print
                              print(stackTrace);
                            }
                          }),
                          buildMenuItem('Privacy Policy', () {
                            Get.to(PrivacyPolicyScreen());
                          }),
                          buildMenuItem('Logout', () {
                            _showLogoutDialog(context);
                          }),
                          15.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                  50.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///
///
///
Widget buildEvent(String number, String label) {
  return Column(
    children: [
      Center(child: Text(number, style: style18)),
      const SizedBox(height: 5),
      Text(label, style: style12.copyWith(color: blackColor)),
    ],
  );
}

////
///
///
Widget buildMenuItem(String title, VoidCallback onTap) {
  return ListTile(
    title: Text(title, style: style14B),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: onTap, // Add your navigation logic here
  );
}

///
///
///

Widget buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10, left: 15),
    child: Text(title, style: style12.copyWith()),
  );
}

const Color containerColor = Color(0xffF7F7F7);

///
///     bottom sheet
///
void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Logout", style: style18),
              SizedBox(height: 10),
              Text("Are you sure you want to logout?", style: style12),
              SizedBox(height: 20),
              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "Logout",
                    style: style14.copyWith(color: whiteColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                ),
              ),
              SizedBox(height: 10),
              // Back Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "Back",
                    style: style14.copyWith(color: whiteColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Just close the dialog
                  },
                ),
              ),
            ],
          ),
        ),
  );
}
