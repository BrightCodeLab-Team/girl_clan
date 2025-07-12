// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/core/model/event_model.dart';
import 'package:girl_clan/core/others/base_view_model.dart';
import 'package:girl_clan/core/services/data_base_services.dart';
import 'package:girl_clan/locator.dart';
import 'package:girl_clan/ui/root_screen/root_screen.dart';

class AddEventViewModel extends BaseViewModel {
  EventModel eventModel = EventModel();
  //List
  final db = locator<DatabaseServices>();

  TimeOfDay? selectedTime;

  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light(
              primary: primaryColor, // header & selection color
              onPrimary: Colors.white, // text on header
              onSurface: Colors.black, // default text color
            ),

            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    primaryColor, // text color of buttons (e.g., CANCEL, OK)
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedTime = picked;

      // Save formatted time (e.g., 10:30 AM) into eventModel.startTime
      eventModel.startTime = picked.format(context);

      notifyListeners();
    }
  }

  ///
  ///. add event to database
  ///
  addEvent(hostName) async {
    setState(ViewState.busy);
    try {
      setState(ViewState.busy);
      await db.addEventsToDataBase(eventModel, hostName);

      Get.snackbar('Success', "Add Event Successfully");
      Get.offAll(() => RootScreen());
      setState(ViewState.idle);
    } catch (e) {
      Get.snackbar('Error', "Failed to add event: $e");
    } finally {
      setState(ViewState.idle);
    }
    setState(ViewState.idle);
  }

  ///
  /// validation of all fields
  ///
  ///
  ///  validate event name
  ///
  String? validateEventName(String? value) {
    if (value!.trim().isEmpty) {
      return 'Enter event name';
    }

    return null;
  }

  ///
  ///  validate date
  ///
  String? validateDate(String? value) {
    if (value!.trim().isEmpty) {
      return 'Enter date';
    }

    return null;
  }

  ///
  ///  validate time
  ///
  String? validateEmail(String? value) {
    if (value!.trim().isEmpty) {
      return 'Enter time';
    }

    return null;
  }

  ///
  ///  validate capacity
  ///
  String? validateCapacity(String? value) {
    if (value!.trim().isEmpty) {
      return 'Enter capacity';
    }
    return null;
  }

  ///
  ///  validate category
  ///
  String? validateCategory(String? value) {
    if (value!.trim().isEmpty) {
      return 'Enter category';
    }

    return null;
  }

  ///
  ///  validate  location
  ///
  String? validateLocation(String? value) {
    if (value!.trim().isEmpty) {
      return 'Enter location';
    }

    return null;
  }

  ///
  ///  validate description
  ///
  String? validateDescription(String? value) {
    if (value!.trim().isEmpty) {
      return 'Enter description';
    }

    return null;
  }

  String? validateSelectedTime() {
    if (selectedTime == null) {
      return 'Please select start time';
    }
    return null;
  }
}
