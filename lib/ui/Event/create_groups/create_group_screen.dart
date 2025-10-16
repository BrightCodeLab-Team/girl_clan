// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/ui/Event/create_groups/creats_view_model.dart';
import 'package:girl_clan/ui/Event/location_picker_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class CreateGroupScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateGroupViewModel(),
      child: Consumer<CreateGroupViewModel>(
        builder: (context, viewModel, _) {
          return ModalProgressHUD(
            inAsyncCall: viewModel.state == ViewState.busy,
            child: Scaffold(
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Group Name
                      Text(
                        'Group Name',
                        style: style12.copyWith(
                          color: blackColor.withOpacity(0.5),
                        ),
                      ),
                      5.verticalSpace,
                      TextFormField(
                        controller: viewModel.titleController,
                        decoration: EditProfileFieldDecoration.copyWith(
                          hintText: 'Enter group name',
                        ),
                        validator: (val) => val!.isEmpty ? 'Required' : null,
                      ),
                      10.verticalSpace,

                      /// Category Dropdown
                      Text(
                        'Category',
                        style: style12.copyWith(
                          color: blackColor.withOpacity(0.5),
                        ),
                      ),
                      5.verticalSpace,
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(99.r),
                          border: Border.all(
                            color: borderColor.withOpacity(0.4),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              dropdownColor: whiteColor,
                              value: viewModel.selectedCategory,
                              hint: Text(
                                'Select category',
                                style: style14.copyWith(fontSize: 12),
                              ),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey.shade900,
                              ),
                              items:
                                  viewModel.categories.map((val) {
                                    return DropdownMenuItem(
                                      value: val,
                                      child: Text(
                                        val,
                                        style: style14.copyWith(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (val) {
                                if (val != null) viewModel.setCategory(val);
                              },
                            ),
                          ),
                        ),
                      ),
                      10.verticalSpace,

                      // /// Location
                      // Text(
                      //   'Location',
                      //   style: style12.copyWith(
                      //     color: blackColor.withOpacity(0.5),
                      //   ),
                      // ),
                      // 5.verticalSpace,
                      // TextFormField(
                      //   controller: viewModel.locationController,
                      //   readOnly: true, // ✅ user type na kare
                      //   onTap: () async {
                      //     final selectedLocation = await Get.to(
                      //       () => LocationPickerScreen(),
                      //     );

                      //     if (selectedLocation != null) {
                      //       viewModel.locationController.text =
                      //           selectedLocation['address'];
                      //       viewModel.groupsModel.location =
                      //           selectedLocation['address'];
                      //       viewModel.groupsModel.locationLat =
                      //           selectedLocation['lat'];
                      //       viewModel.groupsModel.locationLng =
                      //           selectedLocation['lng'];
                      //     }
                      //   },
                      //   decoration: EditProfileFieldDecoration.copyWith(
                      //     hintText: 'Select location',
                      //     suffixIcon: Icon(Icons.location_on_outlined),
                      //   ),
                      //   validator: (val) => val!.isEmpty ? 'Required' : null,
                      // ),
                      10.verticalSpace,

                      /// Description
                      Text(
                        'Description',
                        style: style12.copyWith(
                          color: blackColor.withOpacity(0.5),
                        ),
                      ),
                      5.verticalSpace,
                      TextFormField(
                        controller: viewModel.descriptionController,
                        maxLines: 5,
                        decoration: EditProfileFieldDecoration.copyWith(
                          hintText: 'Enter description',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(
                              color: borderColor.withOpacity(0.4),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        validator: (val) => val!.isEmpty ? 'Required' : null,
                      ),
                      10.verticalSpace,

                      /// Upload Image
                      Text(
                        'Upload Image',
                        style: style12.copyWith(
                          color: blackColor.withOpacity(0.5),
                        ),
                      ),
                      5.verticalSpace,
                      GestureDetector(
                        onTap: viewModel.pickImage,
                        child: Container(
                          width: double.infinity,
                          height: 180.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: borderColor.withOpacity(0.4),
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Center(
                            child:
                                viewModel.pickedImage != null ||
                                        viewModel.webImage != null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(16.r),
                                      child:
                                          kIsWeb
                                              ? Image.memory(
                                                viewModel.webImage!,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              )
                                              : Image.file(
                                                viewModel.pickedImage!,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              ),
                                    )
                                    : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.cloud_upload_outlined,
                                            size: 36,
                                          ),
                                        ),
                                        10.verticalSpace,
                                        Text(
                                          'Upload Photo',
                                          style: style14.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
                        ),
                      ),
                      20.verticalSpace,

                      /// Submit Button
                      StreamBuilder(
                        stream:
                            viewModel.user != null
                                ? FirebaseFirestore.instance
                                    .collection("app-user")
                                    .doc(viewModel.user!.uid)
                                    .snapshots()
                                : null,

                        builder: (context, snapshot) {
                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            return Center(child: Text(''));
                          }
                          final data = snapshot.data!.data()!;
                          final firstName = data['firstName'] ?? '';
                          final surName = data['surName'] ?? '';
                          final imageUrl = data['imageUrl'] ?? '';
                          return CustomButton(
                            text: "Create Group",
                            backgroundColor: primaryColor,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                viewModel.createGroup(
                                  context,
                                  viewModel.user!.uid,
                                  firstName + surName,
                                  imageUrl,
                                );
                              } else {
                                Get.snackbar(
                                  "Validation Error",
                                  "Please fill all required fields.",
                                  snackPosition: SnackPosition.TOP,
                                );
                              }
                            },
                          );
                        },
                      ),
                      50.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
