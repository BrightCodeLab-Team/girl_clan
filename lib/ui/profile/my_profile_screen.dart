import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';

import 'package:girl_clan/core/constants/app_assets.dart' show AppAssets;

import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/app_bar.dart';

import 'package:girl_clan/ui/profile/edit_profile_screen.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Profile',
        showEdit: true,
        onEditTap: () {
          Get.to(EditProfileScreen());
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(AppAssets().appLogo),
              ),
              20.verticalSpace,
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Username', style: style12.copyWith()),
                    SizedBox(height: 4),
                    Text('Mateo Crus', style: style16B),
                    SizedBox(height: 16),

                    Text('Email', style: style12.copyWith()),
                    SizedBox(height: 4),
                    Text('Mateocrus912@gmail.com', style: style16B),
                    SizedBox(height: 16),

                    Text('Phone Number', style: style12.copyWith()),
                    SizedBox(height: 4),
                    Text('+101 887755779', style: style16B),
                    SizedBox(height: 16),

                    Text('Location', style: style12.copyWith()),
                    SizedBox(height: 4),
                    Text('Byron Bay, New South Wales', style: style16B),
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
