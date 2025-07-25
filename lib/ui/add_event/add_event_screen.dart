// ignore_for_file: deprecated_member_use, body_might_complete_normally_nullable

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/app_bar.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/custom_widget/loaders/add_event_laoder.dart';
import 'package:girl_clan/ui/add_event/add_event_view_model.dart';
import 'package:girl_clan/ui/add_event/location_picker_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _pickedImageFile;
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
          _pickedImageFile = null;
        });
      } else {
        setState(() {
          _pickedImageFile = File(pickedFile.path);
          _webImage = null;
        });
      }
    }
  }

  final currentUser = FirebaseAuth.instance.currentUser;

  ///
  ///
  final TextEditingController _dateController = TextEditingController();

  String? _selectedCategory;
  final List<String> _categories = [
    'Concert',
    'Hiking',
    'Party',
    'Workshop',
    'Sports',
    'Art Exhibition',
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            // background color
            dialogBackgroundColor: Colors.white,

            colorScheme: ColorScheme.light(
              primary: primaryColor, // header background & selection color
              onPrimary: Colors.white, // text color on primary (e.g., year)
              onSurface: Colors.black, // default text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = "${picked.year}/${picked.month}/${picked.day}";
      setState(() {
        _dateController.text = formattedDate;
      });
      Provider.of<AddEventViewModel>(context, listen: false).eventModel.date =
          formattedDate;
    }
  }

  @override
  void dispose() {
    _dateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddEventViewModel>(
      builder:
          (context, model, child) => Scaffold(
            appBar: CustomAppBar(title: 'Add Events'),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      10.verticalSpace,

                      ///
                      /// name
                      ///
                      Text(
                        'Name',
                        style: style12.copyWith(
                          color: blackColor.withOpacity(0.5),
                        ),
                      ),
                      5.verticalSpace,
                      // text form field
                      TextFormField(
                        decoration: EditProfileFieldDecoration.copyWith(
                          hintText: 'Enter Event Name',
                        ),
                        onChanged: (value) {
                          model.eventModel.eventName = value;
                        },
                        validator: model.validateEventName,
                      ),
                      10.verticalSpace,

                      ///
                      ///  date
                      ///

                      // Date Field
                      Text(
                        'Date',
                        style: style12.copyWith(
                          color: blackColor.withOpacity(0.5),
                        ),
                      ),
                      10.verticalSpace,
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        style: style14.copyWith(fontSize: 14),
                        decoration: EditProfileFieldDecoration.copyWith(
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_month_rounded),
                        ),
                        // onChanged: (value) {
                        //   model.eventModel.date = value;
                        // },
                        validator: model.validateDate,
                      ),
                      10.verticalSpace,

                      ///
                      ///   start time
                      ///
                      Text(
                        'Start Time',
                        style: style12.copyWith(
                          color: blackColor.withOpacity(0.5),
                        ),
                      ),

                      5.verticalSpace,
                      TextFormField(
                        readOnly: true,
                        decoration: EditProfileFieldDecoration.copyWith(
                          hintText:
                              model.selectedTime != null
                                  ? model.selectedTime!.format(
                                    context,
                                  ) // shows e.g., 10:30 AM
                                  : 'Select Time',
                        ),
                        onTap: () {
                          model.pickTime(context);
                        },
                        onChanged: (value) {
                          model.eventModel.startTime = value;
                        },
                        validator: (val) {
                          model.validateSelectedTime();
                        },
                      ),
                      10.verticalSpace,

                      ///
                      ///  capacity
                      ///
                      Text(
                        'Capacity',
                        style: style12.copyWith(
                          color: blackColor.withOpacity(0.5),
                        ),
                      ),
                      5.verticalSpace,
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: EditProfileFieldDecoration.copyWith(
                          hintText: 'e.g 20 People',
                        ),
                        onChanged: (value) {
                          model.eventModel.capacity = value;
                        },
                        validator: model.validateCapacity,
                      ),
                      10.verticalSpace,

                      ///
                      ///  category
                      ///
                      Text(
                        'Category',
                        style: style12.copyWith(
                          color: blackColor.withOpacity(0.5),
                        ),
                      ),
                      5.verticalSpace,
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // dropdown background
                          borderRadius: BorderRadius.circular(99.r),
                          border: Border.all(
                            color: borderColor.withOpacity(0.4),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                          ), // outer left-right padding
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              dropdownColor: whiteColor,
                              borderRadius: BorderRadius.circular(10),
                              isExpanded: true,
                              hint: Text(
                                'Select Category',
                                style: style14.copyWith(fontSize: 12),
                              ),
                              value: _selectedCategory,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey.shade900,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCategory = newValue;
                                });
                                model.eventModel.category = newValue;
                              },
                              items:
                                  _categories.map<DropdownMenuItem<String>>((
                                    String value,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: style14.copyWith(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                      ),
                      10.verticalSpace,

                      ///
                      ///  location
                      ///
                      Text(
                        'Location',
                        style: style12.copyWith(
                          color: blackColor.withOpacity(0.5),
                        ),
                      ),
                      10.verticalSpace,
                      TextFormField(
                        readOnly: true,
                        controller: model.locationController,
                        onTap: () async {
                          final selectedLocation = await Get.to(
                            () => LocationPickerScreen(),
                          );
                          if (selectedLocation != null) {
                            model.locationController.text =
                                selectedLocation['address'];
                            model.eventModel.location =
                                selectedLocation['address'];
                            model.eventModel.locationLat =
                                selectedLocation['lat'];
                            model.eventModel.locationLng =
                                selectedLocation['lng'];
                          }

                          // if (selectedLocation != null) {
                          //   model.locationController.text = selectedLocation;
                          //   model.eventModel.location = selectedLocation;
                          // }
                        },
                        validator: model.validateLocation,
                        decoration: EditProfileFieldDecoration.copyWith(
                          hintText: 'Select Location',
                          suffixIcon: Icon(
                            Icons.map_outlined,
                            color: Colors.grey.shade900,
                          ),
                        ),
                      ),
                      10.verticalSpace,

                      ///
                      ///  description
                      ///
                      Text(
                        'Description',
                        style: style12.copyWith(
                          color: blackColor.withOpacity(0.5),
                        ),
                      ),
                      5.verticalSpace,
                      TextFormField(
                        maxLines: 6,

                        onChanged: (value) {
                          model.eventModel.description = value;
                        },
                        decoration: EditProfileFieldDecoration.copyWith(
                          hintText: 'e.g Under the stars or around ...',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              16.r,
                            ), // Your custom radius

                            borderSide: BorderSide(
                              color: borderColor.withOpacity(0.4),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              16.r,
                            ), // Your custom radius
                            borderSide: BorderSide(color: Colors.grey),
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              16.r,
                            ), // Your custom radius
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        validator: model.validateDescription,
                      ),
                      10.verticalSpace,

                      ///
                      ///  image
                      ///
                      Text(
                        'image',
                        style: style12.copyWith(
                          color: blackColor.withOpacity(0.5),
                        ),
                      ),
                      5.verticalSpace,
                      // add image here
                      GestureDetector(
                        onTap: _pickImage,
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
                                _pickedImageFile != null || _webImage != null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(16.r),
                                      child:
                                          kIsWeb
                                              ? Image.memory(
                                                _webImage!,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              )
                                              : Image.file(
                                                _pickedImageFile!,
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
                                            color: Colors.black,
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

                      StreamBuilder(
                        stream:
                            currentUser != null
                                ? FirebaseFirestore.instance
                                    .collection("app-user")
                                    .doc(currentUser!.uid)
                                    .snapshots()
                                : null,

                        builder: (context, snapshot) {
                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            return Center(child: Text(''));
                          }
                          final data = snapshot.data!.data()!;
                          final firstName = data['firstName'] ?? '';
                          final surName = data['surName'] ?? '';

                          return CustomButton(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                // Assign dropdown and date
                                if (_selectedCategory != null) {
                                  model.eventModel.category =
                                      _selectedCategory!;
                                }
                                if (_dateController.text.isNotEmpty) {
                                  model.eventModel.date = _dateController.text;
                                }

                                // ✅ Assign current user info
                                final user = FirebaseAuth.instance.currentUser;
                                if (user != null) {
                                  model.eventModel.hostUserId = user.uid;
                                  model.eventModel.hostName =
                                      user.displayName ?? '';
                                  model.eventModel.hostImage =
                                      user.photoURL ?? '';
                                } else {
                                  Get.snackbar('Error', 'User not logged in');
                                  return;
                                }

                                // 👇 Loader screen pe jaye aur wait kare
                                Get.to(
                                  () => AddEventLoader(
                                    addEventCall:
                                        () => model.addEvent(
                                          "${firstName + surName}",
                                        ),
                                    eventName: "${model.eventModel.eventName}",
                                    eventTime: "${model.eventModel.startTime}",
                                  ),
                                );

                                // try {
                                //   await model.addEvent(
                                //     "${firstName + surName}",
                                //   );
                                //   // Success → go to success screen
                                //   Get.off(
                                //     () => SuccessScreen(
                                //       eventName:
                                //           "${model.eventModel.eventName}",
                                //       eventTime:
                                //           "${model.eventModel.startTime}",
                                //     ),
                                //   );
                                // } catch (error) {
                                //   // Failure → go to error screen
                                //   Get.off(() => const ErrorScreen());
                                //   Get.snackbar(
                                //     'Error',
                                //     'Failed to add event: $error',
                                //     colorText: blackColor,
                                //     backgroundColor: secondaryColor,
                                //   );
                                // }
                              } else {
                                Get.snackbar(
                                  'Validation Error',
                                  'Please fill all required fields correctly.',
                                  snackPosition: SnackPosition.TOP,
                                );
                              }
                            },

                            text: 'Add Event',
                            backgroundColor: primaryColor,
                          );
                        },
                      ),

                      50.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
