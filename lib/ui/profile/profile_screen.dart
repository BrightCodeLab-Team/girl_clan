// ignore_for_file: use_key_in_widget_constructors, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/ui/home/home_view_model.dart';
import 'package:girl_clan/ui/interests/interest_screen.dart';
import 'package:girl_clan/ui/notification_screen/notification_screen.dart';
import 'package:girl_clan/ui/password/Change_Password_Screen.dart';
import 'package:girl_clan/ui/password/privacy_policy_screen.dart';
import 'package:girl_clan/ui/profile/my_profile_screen.dart';
import 'package:girl_clan/ui/profile/profile_view_model.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeViewModel, ProfileViewModel>(
      builder:
          (context, homeModel, profileModel, child) => Scaffold(
            backgroundColor: whiteColor,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder(
                    stream:
                        homeModel.currentUser != null
                            ? FirebaseFirestore.instance
                                .collection("app-user")
                                .doc(homeModel.currentUser.currentUser!.uid)
                                .snapshots()
                            : null,

                    builder: (context, snapshot) {
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return Center(child: Text(''));
                      }
                      final data = snapshot.data!.data()!;
                      final firstName = data['firstName'] ?? '';
                      final surName = data['surName'] ?? '';
                      final email = data['email'] ?? 'set email';
                      return Container(
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
                              '$firstName $surName',
                              style: style18B.copyWith(color: whiteColor),
                            ),
                            Text(
                              '$email',
                              style: style12.copyWith(color: whiteColor),
                            ),
                          ],
                        ),
                      );
                    },
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
                                buildEvent(
                                  "${homeModel.currentUserEventsList.length}",
                                  'My events',
                                ),
                                VerticalDivider(),
                                buildEvent(
                                  homeModel.upcomingEventsList.length
                                      .toString(),
                                  'Upcoming events',
                                ),
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
                                  Get.to(() => InterestSelectionScreen());
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
                                  _showLogoutDialog(context, profileModel);
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
void _showLogoutDialog(BuildContext context, ProfileViewModel model) {
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
                    model.logoutUser();
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
