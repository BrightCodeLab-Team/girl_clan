import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/app_bar.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/ui/add_event/add_event_view_model.dart';
import 'package:girl_clan/ui/home/home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
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

  ///
  ///
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
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
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.toLocal()}".split(' ')[0]; // Format date
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddEventViewModel(),
      child: Consumer<AddEventViewModel>(
        builder:
            (context, model, child) => Scaffold(
              appBar: CustomAppBar(title: 'Add Events'),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: SingleChildScrollView(
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
                          hintText: 'Enter Your Name',
                        ),
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
                        decoration: EditProfileFieldDecoration.copyWith(
                          hintText: 'MM/HH',
                        ),
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
                        decoration: EditProfileFieldDecoration.copyWith(
                          hintText: 'e.g 20 People',
                        ),
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
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(99.r),
                          border: Border.all(
                            color: borderColor.withOpacity(0.4),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
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
                            padding:
                                EdgeInsets.symmetric(), // Match vertical padding
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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(99.r),
                          border: Border.all(
                            color: borderColor.withOpacity(0.4),
                          ),
                        ),
                        child: TextFormField(
                          controller: _locationController,
                          style: style14.copyWith(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Enter location ',
                            hintStyle: style14.copyWith(fontSize: 12),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 10.h,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                Get.to(() {
                                  // Get.to(LocationPickerScreen());
                                });
                              },
                              child: Icon(
                                Icons.map_outlined,
                                color: Colors.grey.shade900,
                              ),
                            ),
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

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              16.r,
                            ), // Your custom radius
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
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
                      CustomButton(
                        onTap: () {
                          Get.to(HomeScreen());
                        },
                        text: 'Add Event',
                        backgroundColor: primaryColor,
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
