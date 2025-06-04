import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/ui/add_event/add_event_view_model.dart';
import 'package:provider/provider.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  //late EventViewModel _eventViewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventViewModel(),
      child: Consumer<EventViewModel>(
        builder:
            (context, model, child) => Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    model.clearEventForm(); // Clear form on back press
                    Navigator.pop(context);
                  },
                ),
                title: const Text('Share your event'),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await model.pickImage();
                      },
                      child: Container(
                        height: 150.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                          image:
                              model.selectedImage != null
                                  ? DecorationImage(
                                    image: FileImage(
                                      File(model.selectedImage!.path),
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                  : null,
                        ),
                        child:
                            model.selectedImage == null
                                ? const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 8),
                                      Text('Tap to add image'),
                                    ],
                                  ),
                                )
                                : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topCenter,
                      child: const Text(
                        'Event Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    ///
                    /// event name
                    ///
                    Text("Enter Event Name", style: style16B.copyWith()),
                    5.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: blackColor.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: model.eventNameController,
                        decoration: CustomEventAuthField.copyWith(
                          hintText: "Enter Event Name",
                        ),
                      ),
                    ),
                    10.verticalSpace,

                    ///
                    /// event location
                    ///
                    Text("Enter Location", style: style16B.copyWith()),
                    5.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: blackColor.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: model.locationController,
                        decoration: CustomEventAuthField.copyWith(
                          hintText: "Enter Location",
                        ),
                      ),
                    ),
                    10.verticalSpace,

                    ///
                    ///    enter date of event
                    ///
                    Text("Date", style: style16B.copyWith()),
                    5.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: blackColor.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: model.dateController,
                        decoration: CustomEventAuthField.copyWith(
                          hintText: ' Date (DD-MM-YYYY)',
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              model.dateController.text =
                                  "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                            });
                          }
                        },
                      ),
                    ),
                    10.verticalSpace,

                    ///
                    ///     enter start time of event
                    ///
                    Text("Start time", style: style16B.copyWith()),
                    5.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: blackColor.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller:
                            model
                                .startTimeController, // Use the initialized ViewModel
                        decoration: CustomEventAuthField.copyWith(
                          hintText: "Start Time",
                        ),
                        readOnly: true,
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              // Update controller text within setState
                              model.startTimeController.text = pickedTime
                                  .format(context);
                            });
                          }
                        },
                      ),
                    ),
                    10.verticalSpace,

                    ///
                    ///      interest category
                    ///
                    Text("Enter Location", style: style16B.copyWith()),
                    5.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: blackColor.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField<String>(
                        value: model.selectedCategory,
                        decoration: CustomEventAuthField.copyWith(
                          hintText: "Select Category",
                        ),
                        items:
                            <String>[
                              'Sports',
                              'Music',
                              'Arts',
                              'Technology',
                              'Food',
                              'Other',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          // No need for setState here if eventViewModel.selectedCategory
                          // is updated directly and only used by this widget's value.
                          // If other widgets also depend on selectedCategory, notifyListeners()
                          // would be needed in the ViewModel.
                          model.selectedCategory = newValue;
                        },
                      ),
                    ),
                    10.verticalSpace,

                    const SizedBox(height: 30),
                    Center(
                      child: CustomButton(
                        onTap: () {
                          model.addEvent();
                          Navigator.pop(context);
                        },
                        text: 'Add Event',
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

////
///
///
///
final InputDecoration CustomEventAuthField = InputDecoration(
  hintText: 'Hint Text',
  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.transparent),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.transparent),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.transparent),
  ),
  filled: true,
  fillColor: Colors.white,
  hintStyle: style14B.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: ternaryColor,
  ),
  prefixStyle: style20B.copyWith(
    fontWeight: FontWeight.w400,
    color: Colors.grey.shade400,
  ),
  isDense: true,
);

///
///
///
///
