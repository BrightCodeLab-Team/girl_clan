// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/core/model/event_model.dart';
import 'package:girl_clan/core/others/base_view_model.dart';
import 'package:girl_clan/core/services/data_base_services.dart';
import 'package:girl_clan/locator.dart';
import 'package:girl_clan/ui/root_screen/root_screen.dart';
import 'package:image_picker/image_picker.dart';

class AddEventViewModel extends BaseViewModel {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final picker = ImagePicker();
  File? pickedImageFile;
  Uint8List? webImage;

  String? selectedCategory;
  TimeOfDay? selectedTime;

  EventModel eventModel = EventModel();
  final db = locator<DatabaseServices>();

  // Pick Image
  Future<void> pickImage() async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      if (kIsWeb) {
        webImage = await pickedFile.readAsBytes();
        pickedImageFile = null;
      } else {
        pickedImageFile = File(pickedFile.path);
        webImage = null;
      }
      notifyListeners();
    }
  }

  // Upload Image
  Future<String?> uploadImage() async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageName = 'events/${DateTime.now().millisecondsSinceEpoch}';
      final imageRef = storageRef.child(imageName);
      UploadTask uploadTask;

      if (kIsWeb && webImage != null) {
        final metadata = SettableMetadata(contentType: 'image/jpeg');
        uploadTask = imageRef.putData(webImage!, metadata);
      } else if (pickedImageFile != null) {
        uploadTask = imageRef.putFile(pickedImageFile!);
      } else {
        return null;
      }

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Image upload error: $e');
      return null;
    }
  }

  // Select Date
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final formattedDate = "${picked.year}/${picked.month}/${picked.day}";
      dateController.text = formattedDate;
      eventModel.date = formattedDate;
      notifyListeners();
    }
  }

  // Select Time
  Future<void> pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      selectedTime = picked;
      eventModel.startTime = picked.format(context);
      notifyListeners();
    }
  }

  // Handle Category
  void selectCategory(String value) {
    selectedCategory = value;
    eventModel.category = value;
    notifyListeners();
  }

  // Add Event
  Future<void> addEventToDB(eventModel, hostName) async {
    setState(ViewState.busy);
    try {
      final imageUrl = await uploadImage();
      if (imageUrl != null) {
        eventModel.imageUrl = imageUrl;
      }

      final res = await db.addEventsToDataBase(eventModel, hostName);
      if (res != null) {
        Get.offAll(() => RootScreen(selectedScreen: 0));
        Get.snackbar('Sucess', 'Your Data is Added SucessFully');
      } else {
        Get.snackbar('Error', 'Failed to add event');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed: $e');
    } finally {
      setState(ViewState.idle);
    }
    setState(ViewState.idle);
  }

  /// VALIDATIONS...
  String? validateEventName(String? value) {
    if (value!.isEmpty) return 'Enter event name';
    return null;
  }

  String? validateDate(String? value) {
    if (value!.isEmpty) return 'Enter date';
    return null;
  }

  String? validateCapacity(String? value) {
    if (value!.isEmpty) return 'Enter capacity';
    return null;
  }

  String? validateLocation(String? value) {
    if (value!.isEmpty) return 'Enter location';
    return null;
  }

  String? validateDescription(String? value) {
    if (value!.isEmpty) return 'Enter description';
    return null;
  }

  String? validateSelectedTime() {
    if (selectedTime == null) return 'Select start time';
    return null;
  }
}
