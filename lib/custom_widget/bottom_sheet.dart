import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';

///
///  bottom sheet
///

class CustomFilterBottomSheet extends StatefulWidget {
  const CustomFilterBottomSheet({super.key});

  @override
  State<CustomFilterBottomSheet> createState() =>
      _CustomFilterBottomSheetState();
}

class _CustomFilterBottomSheetState extends State<CustomFilterBottomSheet> {
  String? _selectedCategory;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 25.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 50.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          20.verticalSpace,

          // Category Field
          Text(
            'Category',
            style: style14B.copyWith(fontSize: 16, color: blackColor),
          ),
          10.verticalSpace,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(99.r),
              border: Border.all(color: borderColor),
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
                    _categories.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: style14.copyWith(fontSize: 14),
                        ),
                      );
                    }).toList(),
                padding: EdgeInsets.symmetric(), // Match vertical padding
              ),
            ),
          ),
          20.verticalSpace,

          // Date Field
          Text(
            'Date',
            style: style14B.copyWith(fontSize: 16, color: blackColor),
          ),
          10.verticalSpace,
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(99.r),
              border: Border.all(color: borderColor),
            ),
            child: TextFormField(
              controller: _dateController,
              readOnly: true,
              onTap: () => _selectDate(context),
              style: style14.copyWith(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Select Date',
                hintStyle: style14.copyWith(fontSize: 12),
                border: InputBorder.none, // Remove border
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 5.w,
                  vertical: 10.h,
                ), // Adjust padding
                suffixIcon: Icon(
                  Icons.calendar_month,
                  color: Colors.grey.shade900,
                ),
              ),
            ),
          ),
          20.verticalSpace,

          // Location Field
          Text(
            'Location',
            style: style14B.copyWith(fontSize: 16, color: blackColor),
          ),
          10.verticalSpace,
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(99.r),
              border: Border.all(color: borderColor),
            ),
            child: TextFormField(
              controller: _locationController,
              style: style14.copyWith(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Type location or select ',
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
                  child: Icon(Icons.map_outlined, color: Colors.grey.shade900),
                ),
              ),
            ),
          ),

          40.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: GestureDetector(
                  child: CustomButton(
                    onTap: () {
                      _selectedCategory = null;
                      _dateController.clear();
                      _locationController.clear();
                      setState(() {});
                      Navigator.pop(context);
                    },
                    text: 'Reset',
                    backgroundColor: secondaryColor,
                  ),
                ),
              ),
              5.horizontalSpace,
              Expanded(
                child: CustomButton(
                  onTap: () {
                    print('Selected Category: $_selectedCategory');
                    print('Selected Date: ${_dateController.text}');
                    print('Location: ${_locationController.text}');
                    Navigator.pop(context);
                  },
                  text: 'Apply',
                  backgroundColor: primaryColor,
                ),
              ),
            ],
          ),

          MediaQuery.of(context).viewInsets.bottom == 0
              ? 0.verticalSpace
              : 20.verticalSpace,
        ],
      ),
    );
  }
}
