// ignore_for_file: deprecated_member_use, body_might_complete_normally_nullable, unused_local_variable

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/ui/add_event/create_events.dart/create_event_view_model.dart';
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

  Future<String?> uploadImage() async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageName = 'events/${DateTime.now().millisecondsSinceEpoch}';
      final imageRef = storageRef.child(imageName);

      UploadTask uploadTask;
      if (kIsWeb && _webImage != null) {
        final metadata = SettableMetadata(contentType: 'image/jpeg');
        uploadTask = imageRef.putData(_webImage!, metadata);
      } else if (_pickedImageFile != null) {
        uploadTask = imageRef.putFile(_pickedImageFile!);
      } else {
        return null; // no image
      }

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Image upload error: $e');
      return null;
    }
  }

  final currentUser = FirebaseAuth.instance.currentUser;

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
            dialogBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = "${picked.day}/${picked.month}/${picked.year}";
      setState(() => _dateController.text = formattedDate);
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
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.verticalSpace,
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Name",
                          style: style12.copyWith(
                            color: blackColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                      5.verticalSpace,
                      TextFormField(
                        decoration: EditProfileFieldDecoration.copyWith(
                          hintText: 'Enter Event Name',
                        ),
                        onChanged:
                            (value) => model.eventModel.eventName = value,
                        validator: model.validateEventName,
                      ),
                      10.verticalSpace,

                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Date",
                          style: style12.copyWith(
                            color: blackColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                      5.verticalSpace,
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        decoration: EditProfileFieldDecoration.copyWith(
                          suffixIcon: Icon(Icons.calendar_month_rounded),
                        ),
                        validator: model.validateDate,
                      ),
                      10.verticalSpace,

                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Start Time",
                          style: style12.copyWith(
                            color: blackColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                      5.verticalSpace,
                      TextFormField(
                        readOnly: true,
                        decoration: EditProfileFieldDecoration.copyWith(
                          hintText:
                              model.selectedTime != null
                                  ? model.selectedTime!.format(context)
                                  : 'Select Time',
                        ),
                        onTap: () => model.pickTime(context),
                        validator: (val) => model.validateSelectedTime(),
                      ),
                      10.verticalSpace,

                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Repeat",
                          style: style12.copyWith(
                            color: blackColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                      5.verticalSpace,
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: model.selectedRecurrence,
                        decoration: EditProfileFieldDecoration.copyWith(
                          hintText: 'Select Repetition (Weekly, Monthly)',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          suffixIcon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey.shade800,
                          ), // 👈 ab ye bilkul end me aayega
                        ),

                        borderRadius: BorderRadius.circular(16),
                        dropdownColor: whiteColor,
                        icon: SizedBox(),
                        items:
                            ["None", "Weekly", "Monthly"].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            model.selectRecurrence(value);
                          }
                        },
                        validator:
                            (val) =>
                                val == null ? "Recurrence is required" : null,
                      ),
                      10.verticalSpace,

                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Capacity",
                          style: style12.copyWith(
                            color: blackColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                      5.verticalSpace,
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: EditProfileFieldDecoration.copyWith(
                          hintText: 'People',
                        ),
                        onChanged: (value) => model.eventModel.capacity = value,
                        validator: model.validateCapacity,
                      ),
                      10.verticalSpace,

                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Category",
                          style: style12.copyWith(
                            color: blackColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                      5.verticalSpace,
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        dropdownColor: whiteColor,
                        borderRadius: BorderRadius.circular(16),
                        isExpanded: true, // 👈 taake dropdown full width le
                        decoration: EditProfileFieldDecoration.copyWith(
                          hintText: "Select Category",
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          suffixIcon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey.shade800,
                          ), // 👈 ye bilkul end me aayega
                        ),
                        icon: SizedBox(),
                        items:
                            _categories.map((e) {
                              return DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              );
                            }).toList(),
                        onChanged: (val) {
                          setState(() => _selectedCategory = val);
                          model.eventModel.category = val;
                        },
                        validator:
                            (val) =>
                                val == null ? "Category is required" : null,
                      ),
                      10.verticalSpace,

                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Location",
                          style: style12.copyWith(
                            color: blackColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                      5.verticalSpace,
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

                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Description",
                          style: style12.copyWith(
                            color: blackColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                      5.verticalSpace,
                      TextFormField(
                        maxLines: 6,
                        onChanged:
                            (value) => model.eventModel.description = value,
                        validator: model.validateDescription,
                        decoration: EditProfileFieldDecoration.copyWith(
                          hintText: 'e.g Under the stars or around ...',
                        ),
                      ),
                      10.verticalSpace,

                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Image",
                          style: style12.copyWith(
                            color: blackColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                      5.verticalSpace,
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
                                    ? (kIsWeb
                                        ? Image.memory(
                                          _webImage!,
                                          fit: BoxFit.cover,
                                        )
                                        : Image.file(
                                          _pickedImageFile!,
                                          fit: BoxFit.cover,
                                        ))
                                    : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.cloud_upload_outlined,
                                          size: 36,
                                          color: Colors.black,
                                        ),
                                        10.verticalSpace,
                                        Text("Upload Photo", style: style14),
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
                            return const SizedBox();
                          }
                          final data = snapshot.data!.data()!;
                          final firstName = data['firstName'] ?? '';
                          final surName = data['surName'] ?? '';

                          return CustomButton(
                            text: "Add Event",
                            backgroundColor: primaryColor,
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                if (_pickedImageFile == null &&
                                    _webImage == null) {
                                  Get.snackbar("Error", "Image is required");
                                  return;
                                }

                                Get.dialog(
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  barrierDismissible: false,
                                );

                                final uploadedUrl = await uploadImage();
                                if (uploadedUrl != null)
                                  model.eventModel.imageUrl = uploadedUrl;

                                model.eventModel.category = _selectedCategory!;
                                model.eventModel.date = _dateController.text;
                                model.eventModel.hostUserId = currentUser?.uid;

                                await model.addEventToDB(
                                  model.eventModel,
                                  "$firstName $surName",
                                );

                                Get.back();
                                Get.snackbar(
                                  "Success",
                                  "Your data has been added successfully.",
                                );

                                // Reset all
                                _formKey.currentState!.reset();
                                _dateController.clear();
                                model.locationController.clear();
                                model.clearEventModel();
                                setState(() {
                                  _pickedImageFile = null;
                                  _webImage = null;
                                  _selectedCategory = null;
                                  model.selectedRecurrence = null;
                                });
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
          ),
    );
  }
}
