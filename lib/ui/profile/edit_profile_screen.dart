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
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/custom_widget/app_bar.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/ui/auth/sign_up/location_screen.dart';
import 'package:girl_clan/ui/profile/profile_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
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
  Future<DocumentSnapshot>? _userFuture; // 👈 add this
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
          _image = null; // clear native file if web is used
        });
      } else {
        setState(() {
          _image = File(pickedFile.path);
          _webImage = null; // clear web image if file is used
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData();
  }

  void _loadUserData() {
    final model = Provider.of<ProfileViewModel>(context, listen: false);
    if (model.currentUser != null) {
      _userFuture =
          FirebaseFirestore.instance
              .collection('app-user')
              .doc(model.currentUser!.uid)
              .get();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder:
          (context, model, child) => ModalProgressHUD(
            inAsyncCall: ViewState.busy == model.state,
            child: Scaffold(
              appBar: CustomAppBar(title: 'Edit Profile'),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: FutureBuilder(
                    future: _userFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData ||
                          !snapshot.data!.exists ||
                          snapshot.data!.data() == null) {
                        return Center(child: Text("No user data available"));
                      }

                      final userData =
                          snapshot.data!.data() as Map<String, dynamic>;

                      // set controllers only if empty (so it doesn't overwrite user typing)
                      if (model.firstNameController.text.isEmpty) {
                        model.firstNameController.text =
                            userData['firstName'] ?? '';
                      }
                      if (model.surNameController.text.isEmpty) {
                        model.surNameController.text =
                            userData['surName'] ?? '';
                      }
                      if (model.locationController.text.isEmpty) {
                        model.locationController.text =
                            userData['location'] ?? '';
                      }
                      if (model.phoneController.text.isEmpty) {
                        model.phoneController.text =
                            userData['phoneNumber'] ?? '';
                      }

                      // same if you have emailController
                      // model.emailController.text = userData['email'] ?? '';
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
                                          : (userData['imgUrl'] != null &&
                                              userData['imgUrl'].isNotEmpty)
                                          ? NetworkImage(userData['imgUrl'])
                                          : null,

                                  child:
                                      _image == null &&
                                              _webImage == null &&
                                              userData['imgUrl'] == null
                                          ? Icon(
                                            Icons.person,
                                            size: 70,
                                            color: blackColor,
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
                          Text('First name', style: style12),
                          5.verticalSpace,
                          TextFormField(
                            decoration: EditProfileFieldDecoration.copyWith(
                              hintText: "Enter first name",
                            ),
                            validator: model.validateFirstName,
                            controller: model.firstNameController,
                          ),
                          20.verticalSpace,
                          Text('SurName', style: style12),
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
                                decoration: EditProfileFieldDecoration.copyWith(
                                  hintText: "City / Area",
                                ),
                                controller: model.locationController,
                                // validator: (value) {
                                //   if (value == null || value.trim().isEmpty) {
                                //     return 'Please enter your location';
                                //   }
                                //   return null;
                                // },
                              ),
                            ),
                          ),
                          20.verticalSpace,
                          Text('Email', style: style12),
                          5.verticalSpace,
                          TextFormField(
                            decoration: EditProfileFieldDecoration.copyWith(
                              hintText: "Enter your email",
                            ),
                            readOnly: true,
                            // validator: model.validateEmail,
                            // controller: model.emailController,
                          ),
                          20.verticalSpace,
                          Text('Phone Number', style: style12),
                          5.verticalSpace,
                          TextFormField(
                            decoration: EditProfileFieldDecoration.copyWith(
                              hintText: "+101 234567890",
                            ),
                            // validator: model.validatePhoneNumber,
                            controller: model.phoneController,
                          ),
                          40.verticalSpace,
                          Center(
                            child: CustomButton(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    await model.updateUserProfileInformation(
                                      image: _image,
                                      webImage: _webImage,
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
    );
  }
}
