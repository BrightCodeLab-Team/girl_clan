// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/app_bar.dart';
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
                      return Center(child: Text(''));
                    }
                    final data = snapshot.data!.data()!;
                    final firstName = data['firstName'] ?? '';
                    final surName = data['surName'] ?? '';
                    final email = data['email'] ?? 'set email';
                    final phoneNumber =
                        data['phoneNumber'] ?? 'set phone number';
                    final location = data['location'] ?? 'set location';
                    final imgUrl = data['imgUrl'] ?? 'set location';
                    // Default widget if none of the above conditions are met
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Center(
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage:
                                model.image != null
                                    ? FileImage(model.image!)
                                    : model.webImage != null
                                    ? MemoryImage(model.webImage!)
                                    : (data['imgUrl'] != null &&
                                        data['imgUrl'].isNotEmpty)
                                    ? NetworkImage(data['imgUrl'])
                                    : null,

                            child:
                                model.image == null &&
                                        model.webImage == null &&
                                        data['imgUrl'] == null
                                    ? Icon(
                                      Icons.person,
                                      size: 70,
                                      color: blackColor,
                                    )
                                    : null,
                          ),
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
                              Text('$firstName $surName', style: style16B),
                              SizedBox(height: 16),

                              Text('Email', style: style12.copyWith()),
                              SizedBox(height: 4),
                              Text(
                                //  'Mateocrus912@gmail.com'
                                '$email',
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
                                '$location',

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
