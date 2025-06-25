import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';

import 'package:girl_clan/core/constants/app_assets.dart' show AppAssets;

import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/model/event_model.dart';
import 'package:girl_clan/custom_widget/app_bar.dart';
import 'package:girl_clan/ui/home/home_view_model.dart';

import 'package:girl_clan/ui/profile/edit_profile_screen.dart';
import 'package:girl_clan/ui/profile/profile_view_model.dart';
import 'package:provider/provider.dart';

class MyProfileScreen extends StatelessWidget {
  MyProfileScreen({super.key});

  ///
  ///.  data base services
  ///
  final currentUser = FirebaseAuth.instance.currentUser;

  /*
   addEventsToDataBase(EventModel eventModel) async {
    try {
      await _db
          .collection('events')
          .add(eventModel.toJson())
          .then((value) => debugPrint('user registered successfully'));
    } catch (e, s) {
      debugPrint('Exception @DatabaseService/addEvent');
      debugPrint(s.toString());
      return false;
    }
  }
  */

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder:
          (context, model, child) => Scaffold(
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
                child: StreamBuilder(
                  stream:
                      currentUser != null
                          ? FirebaseFirestore.instance
                              .collection("app-user")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .snapshots()
                          : null,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Center(child: Text('No user profile found.'));
                    }
                    final data = snapshot.data!.data()!;
                    final firstName = data['firstName'] ?? '';
                    final surName = data['surName'] ?? '';
                    final email = data['email'] ?? 'set email';
                    final phoneNumber =
                        data['phoneNumber'] ?? 'set phone number';
                    final location = data['location'] ?? 'set location';
                    // Default widget if none of the above conditions are met
                    return Column(
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
                              Text(
                                '${firstName + surName}' ?? 'set username',
                                style: style16B,
                              ),
                              SizedBox(height: 16),

                              Text('Email', style: style12.copyWith()),
                              SizedBox(height: 4),
                              Text(
                                //  'Mateocrus912@gmail.com'
                                '$email' ?? 'set email',
                                style: style16B,
                              ),
                              SizedBox(height: 16),

                              Text('Phone Number', style: style12.copyWith()),
                              SizedBox(height: 4),
                              Text(
                                //'+101 887755779'
                                '$phoneNumber',
                                style: style16B,
                              ),
                              SizedBox(height: 16),

                              Text('Location', style: style12.copyWith()),
                              SizedBox(height: 4),
                              Text(
                                //'Byron Bay, New South Wales',
                                '$location' ?? 'set location',

                                style: style16B,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
    );
  }
}
/*
 Column(
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
                */