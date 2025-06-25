import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/app_bar.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/ui/profile/profile_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  Uint8List? _webImage; // for web

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      } else {
        setState(() {
          _webImage = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder:
          (context, model, child) => Scaffold(
            appBar: CustomAppBar(title: 'My Profile'),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: FutureBuilder(
                      future:
                          model.currentUser != null
                              ? FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(model.currentUser!.uid)
                                  .get()
                              : null,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData) {
                          return Center(child: Text('No data found'));
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 70,
                                    backgroundColor: Colors.grey.shade200,
                                    backgroundImage:
                                        _image != null
                                            ? FileImage(_image!)
                                            : _webImage != null
                                            ? MemoryImage(_webImage!)
                                            : null,
                                    child:
                                        (_image == null && _webImage == null)
                                            ? Icon(
                                              Icons.person,
                                              size: 70,
                                              color: Colors.grey,
                                            )
                                            : null,
                                  ),

                                  InkWell(
                                    onTap: _pickImage,
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: primaryColor,
                                      child: Image.asset(
                                        AppAssets().editIcon,
                                        scale: 4,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text('first name', style: style12),
                            5.verticalSpace,
                            TextFormField(
                              decoration: EditProfileFieldDecoration.copyWith(
                                hintText: "Enter first name",
                              ),
                              validator: model.validateFirstName,
                              controller: model.firstNameController,
                            ),
                            20.verticalSpace,
                            Text('sur name', style: style12),
                            5.verticalSpace,
                            TextFormField(
                              decoration: EditProfileFieldDecoration.copyWith(
                                hintText: "Enter sur name",
                              ),
                              validator: model.validateSurName,
                              controller: model.surNameController,
                            ),
                            20.verticalSpace,
                            Text('Location', style: style12),
                            5.verticalSpace,
                            TextFormField(
                              decoration: EditProfileFieldDecoration.copyWith(
                                hintText: "Location",
                              ),
                              validator: model.validateLocation,
                              controller: model.locationController,
                            ),
                            20.verticalSpace,
                            Text('Email', style: style12),
                            5.verticalSpace,
                            TextFormField(
                              decoration: EditProfileFieldDecoration.copyWith(
                                hintText: "Enter your email",
                              ),
                              validator: model.validateEmail,
                              controller: model.emailController,
                            ),
                            20.verticalSpace,
                            Text('Phone Number', style: style12),
                            5.verticalSpace,
                            TextFormField(
                              decoration: EditProfileFieldDecoration.copyWith(
                                hintText: "+101 234567890",
                              ),
                              validator: model.validatePhoneNumber,
                              controller: model.phoneController,
                            ),
                            40.verticalSpace,
                            Center(
                              child: CustomButton(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      model.updateUserProfileInformation();
                                      Get.back();
                                      Get.snackbar(
                                        'Profile Updated',
                                        'Your profile changes have been saved.',
                                        snackPosition: SnackPosition.TOP,
                                        backgroundColor: primaryColor,
                                        colorText: whiteColor,
                                      );
                                    } catch (e) {
                                      Get.snackbar(
                                        'Error',
                                        'Error while updating profile: $e',
                                        snackPosition: SnackPosition.TOP,
                                        backgroundColor: secondaryColor,
                                        colorText: Colors.white,
                                      );
                                    }
                                  }
                                },
                                text: "Save Changes",
                                backgroundColor: primaryColor,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
/*
 future: currentUser != null
                ? FirebaseFirestore.instance
                    .collection('user')
                    .doc(currentUser!.uid)
                    .get()
                : null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                return Center(child: Text('No data found'));
              }
              */


              /*
////
///
///
///
///

              Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 70,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage:
                                    _image != null
                                        ? FileImage(_image!)
                                        : _webImage != null
                                        ? MemoryImage(_webImage!)
                                        : null,
                                child:
                                    (_image == null && _webImage == null)
                                        ? Icon(
                                          Icons.person,
                                          size: 70,
                                          color: Colors.grey,
                                        )
                                        : null,
                              ),

                              InkWell(
                                onTap: _pickImage,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: primaryColor,
                                  child: Image.asset(
                                    AppAssets().editIcon,
                                    scale: 4,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text('first name', style: style12),
                        5.verticalSpace,
                        TextFormField(
                          decoration: EditProfileFieldDecoration.copyWith(
                            hintText: "Enter first name",
                          ),
                          validator: model.validateFirstName,
                          controller: model.firstNameController,
                        ),
                        20.verticalSpace,
                        Text('sur name', style: style12),
                        5.verticalSpace,
                        TextFormField(
                          decoration: EditProfileFieldDecoration.copyWith(
                            hintText: "Enter sur name",
                          ),
                          validator: model.validateSurName,
                          controller: model.surNameController,
                        ),
                        20.verticalSpace,
                        Text('Location', style: style12),
                        5.verticalSpace,
                        TextFormField(
                          decoration: EditProfileFieldDecoration.copyWith(
                            hintText: "Location",
                          ),
                          validator: model.validateLocation,
                          controller: model.locationController,
                        ),
                        20.verticalSpace,
                        Text('Email', style: style12),
                        5.verticalSpace,
                        TextFormField(
                          decoration: EditProfileFieldDecoration.copyWith(
                            hintText: "Enter your email",
                          ),
                          validator: model.validateEmail,
                          controller: model.emailController,
                        ),
                        20.verticalSpace,
                        Text('Phone Number', style: style12),
                        5.verticalSpace,
                        TextFormField(
                          decoration: EditProfileFieldDecoration.copyWith(
                            hintText: "+101 234567890",
                          ),
                          validator: model.validatePhoneNumber,
                          controller: model.phoneController,
                        ),
                        40.verticalSpace,
                        Center(
                          child: CustomButton(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  model.updateUserProfileInformation();
                                  Get.back();
                                  Get.snackbar(
                                    'Profile Updated',
                                    'Your profile changes have been saved.',
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: primaryColor,
                                    colorText: whiteColor,
                                  );
                                } catch (e) {
                                  Get.snackbar(
                                    'Error',
                                    'Error while updating profile: $e',
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: secondaryColor,
                                    colorText: Colors.white,
                                  );
                                }
                              }
                            },
                            text: "Save Changes",
                            backgroundColor: primaryColor,
                          ),
                        ),
                      ],
                    ),



                    */