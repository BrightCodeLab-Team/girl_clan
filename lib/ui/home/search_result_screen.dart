import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/custom_widget/search_result_card.dart';
import 'package:girl_clan/ui/home/search_screen.dart';

import 'package:girl_clan/ui/home/events_details_screen.dart';
import 'package:girl_clan/ui/home/home_view_model.dart';
import 'package:provider/provider.dart';

class SearchResultScreen extends StatelessWidget {
  const SearchResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder:
            (context, model, child) => Scaffold(
              appBar: AppBar(
                leading: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: CircleAvatar(
                    backgroundColor: thinGreyColor,
                    child: GestureDetector(
                      onTap: () {
                        navigator!.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios_new_outlined),
                    ),
                  ),
                ),
                title: TextFormField(
                  decoration: customHomeAuthField.copyWith(
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(10),
                      child: CircleAvatar(
                        backgroundColor: whiteColor,
                        child: IconButton(
                          icon: Icon(Icons.tune),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext context) {
                                return CustomFilterBottomSheet();
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.verticalSpace,
                    // search found
                    Row(
                      children: [
                        Text(
                          'search found:',
                          style: style14.copyWith(fontSize: 12),
                        ),
                        2.horizontalSpace,
                        Text(
                          ///
                          ///. changes here in first 3 lines
                          ///
                          model.upcomingEventsList.length <= 9
                              ? '0${model.upcomingEventsList.length}'
                              : model.upcomingEventsList.length.toString(),
                          style: style14B.copyWith(
                            fontSize: 13,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    10.verticalSpace,

                    //  search result
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),

                        ///
                        ///
                        ///
                        itemCount: model.upcomingEventsList.length,

                        /// in this line
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,

                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(EventsDetailsScreen());
                            },
                            child: CustomSearchResultCard(
                              eventModel:
                                  model
                                      .upcomingEventsList[index], // in this line
                            ),
                          );
                        },
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light(
              primary: primaryColor, // header background
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
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
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  ///
  ///. snack bar
  ///
  void showTopSnackBar(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.redAccent,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(message, style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 2)).then((value) => overlayEntry.remove());
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
            child: Container(
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: whiteColor, // White dropdown background
                  borderRadius: BorderRadius.circular(20), // Rounded corners
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
                ),
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
                hintText: 'Type location or select from map',
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
            children: [
              Expanded(
                child: CustomButton(
                  onTap: () {
                    setState(() {
                      _selectedCategory = null;
                      _dateController.clear();
                      _locationController.clear();
                    });
                  },
                  text: 'Reset',
                  backgroundColor: secondaryColor,
                  textColor: whiteColor,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: CustomButton(
                  onTap: () {
                    if (_selectedCategory == null ||
                        _dateController.text.isEmpty ||
                        _locationController.text.isEmpty) {
                      showTopSnackBar(context, 'Please fill all fields');
                    } else {
                      Navigator.pop(context); // Close bottom sheet
                      showTopSnackBar(
                        context,
                        'Filter applied',
                        backgroundColor: primaryColor,
                      );
                    }
                  },

                  text: 'Apply',
                  backgroundColor: primaryColor,
                  textColor: whiteColor,
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
