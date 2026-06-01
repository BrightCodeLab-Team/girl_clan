// ignore_for_file: use_build_context_synchronously, deprecated_member_use, prefer_final_fields, strict_top_level_inference, avoid_print

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/core/model/event_model.dart';
import 'package:girl_clan/core/others/base_view_model.dart';
import 'package:girl_clan/core/utils/content_filter.dart';
import 'package:girl_clan/core/services/data_base_services.dart';
import 'package:girl_clan/locator.dart';
import 'package:image_picker/image_picker.dart';

class AddEventViewModel extends BaseViewModel {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  /// Opciones para el dropdown de estados
  List<String> stateOptions = [
    "Coffee & Chats",
    "Dinner & Drinks",
    "Run",
    "Water sports",
    "Book Club",
    "Games",
    "Mommy & Baby",
    "Sport",
    "Art & Cultural",
    "Health & Wellbeing",
    "Career & Business",
    "Hobbies & Passions",
    "Dance",
    'Concert',
    'Travel',
    'Festival',
    'Hiking',
    'Food & Drinks',
    'Beach Day',
    'Road Trip',
    'Camping',
    'Workshop',
  ]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

  final picker = ImagePicker();
  File? pickedImageFile;
  Uint8List? webImage;

  String? selectedCategory;
  TimeOfDay? selectedTime;

  bool _dropDown = false;
  String _dropDownText = '';

  String get dropDownText => _dropDownText;

  bool get dropDown => _dropDown;

  bool dropDown4Error = false;
  bool dropDown5Error = false;

  String _dropDownText5 = '';

  String get dropDownText5 => _dropDownText5;

  void setDropDownText(String value) {
    _dropDownText = value;
    notifyListeners();
  }

  void toggleDropDown() {
    _dropDown = !_dropDown;
    notifyListeners();
  }

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

  String? selectedRecurrence;

  void selectRecurrence(String value) {
    selectedRecurrence = value;
    eventModel.recurrence = value;
    notifyListeners();
  }

  /// Returns `null` on success, or an error message for the UI.
  Future<String?> addEventToDB(EventModel event, String hostName) async {
    for (final field in [
      event.eventName,
      event.description,
      event.location,
    ]) {
      final err = ContentFilter.validationError(field);
      if (err != null) return err;
    }

    setState(ViewState.busy);
    try {
      final imageUrl = await uploadImage();
      if (imageUrl != null) {
        event.imageUrl = imageUrl;
      }

      final res = await db.addEventsToDataBase(event, hostName);
      if (res != null) return null;
      return 'Failed to add event. Please try again.';
    } catch (e) {
      return 'Failed to add event: $e';
    } finally {
      setState(ViewState.idle);
    }
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

  void clearEventModel() {
    eventModel = EventModel(); // fresh model create
    selectedTime = null;
    selectedRecurrence = "None";
    notifyListeners();
  }
}
