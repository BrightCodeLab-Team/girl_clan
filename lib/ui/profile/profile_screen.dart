import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/ui/profile/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String userName = "Emma";
    final String userEmail = "emmaa@gmail.com";
    final String profileName = "Emma";
    final String profileLocation = "Ireland";
    final String profileEmail = "emmaa@name.com";
    final String profilePhoneNumber = "+12345678901";

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: blackColor),
          onPressed: () {
            Get.back(); // Use GetX for navigation
          },
        ),
        title: Text('Profile', style: TextStyle(color: blackColor)),
        backgroundColor: whiteColor,
        elevation: 0,
        centerTitle: true, // Center the title as per image
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Profile Section
            Row(
              children: [
                CircleAvatar(
                  radius: 40.r, // Adjust size with screenutil
                  backgroundColor: lightGreyColor, // Placeholder color
                  child: Icon(Icons.person, size: 50.r, color: whiteColor),
                ),
                8.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: style20B.copyWith(color: blackColor),
                    ), // Using style20B
                    5.verticalSpace,
                    Text(
                      userEmail,
                      style: style16.copyWith(color: Colors.grey.shade700),
                    ), // Using style16
                  ],
                ),
              ],
            ),
            20.verticalSpace,
            GestureDetector(
              onTap: () {
                // Navigate to the edit profile screen
                Get.to(
                  () => EditProfileScreen(
                    initialName: profileName,
                    initialLocation: profileLocation,
                    initialEmail: profileEmail,
                    initialPhoneNumber: profilePhoneNumber,
                  ),
                );
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Edit',
                  style: style16.copyWith(
                    color: darkGreyColor,
                  ), // Assuming primaryColor for "Edit" link
                ),
              ),
            ),
            5.verticalSpacingDiagonal,
            // Profile Information Card
            Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: whiteColor, // White background for the card
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: style16B.copyWith(color: blackColor),
                    ), // Using style16
                    5.verticalSpace,
                    _buildInfoBox(profileName),
                    10.verticalSpace,

                    Text(
                      'Location',
                      style: style16B.copyWith(color: blackColor),
                    ),
                    5.verticalSpace,
                    _buildInfoBox(profileLocation),
                    10.verticalSpace,

                    Text('Email', style: style16B.copyWith(color: blackColor)),
                    5.verticalSpace,
                    _buildInfoBox(
                      profileEmail,
                      isEmail: true,
                    ), // Special handling for email link
                    10.verticalSpace,

                    Text(
                      'Phone Number',
                      style: style16B.copyWith(color: blackColor),
                    ),
                    5.verticalSpace,
                    _buildInfoBox(profilePhoneNumber), 10.verticalSpace,
                  ],
                ),
              ),
            ),
            40.verticalSpace, // Space at the bottom
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String text, {bool isEmail = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            spreadRadius: 0,
            blurRadius: 7,
            offset: Offset(0, 4),
          ),
        ],
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        text,
        style:
            isEmail
                ? style14.copyWith(color: blackColor, fontSize: 12)
                : style14.copyWith(color: blackColor, fontSize: 12),
      ),
    );
  }
}
