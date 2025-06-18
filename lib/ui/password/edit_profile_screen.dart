import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/app_bar.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _image;
  Uint8List? _webImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
          _image = null; // Clear file image
        });
      } else {
        setState(() {
          _image = File(pickedFile.path);
          _webImage = null; // Clear web image
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Edit Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
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
                Text('User name', style: style12),
                5.verticalSpace,
                TextFormField(
                  decoration: EditProfileFieldDecoration.copyWith(
                    hintText: "Enter your name",
                  ),
                ),
                20.verticalSpace,
                Text('Location', style: style12),
                5.verticalSpace,
                TextFormField(
                  decoration: EditProfileFieldDecoration.copyWith(
                    hintText: "Location",
                  ),
                ),
                20.verticalSpace,
                Text('Email', style: style12),
                5.verticalSpace,
                TextFormField(
                  decoration: EditProfileFieldDecoration.copyWith(
                    hintText: "Enter your email",
                  ),
                ),
                20.verticalSpace,
                Text('Phone Number', style: style12),
                5.verticalSpace,
                TextFormField(
                  decoration: EditProfileFieldDecoration.copyWith(
                    hintText: "+101 234567890",
                  ),
                ),
                40.verticalSpace,
                Center(
                  child: CustomButton(
                    onTap: () {
                      Get.back();
                      Get.snackbar(
                        'Profile Updated',
                        'Your profile changes have been saved.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: secondaryColor,
                        colorText: whiteColor,
                      );
                    },
                    text: "Save Changes",
                    backgroundColor: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
