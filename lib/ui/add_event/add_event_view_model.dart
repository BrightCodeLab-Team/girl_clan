import 'dart:io';
import 'package:flutter/material.dart';
import 'package:girl_clan/core/model/add_event_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class EventViewModel extends ChangeNotifier {
  final List<Event> _events = [];
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  TextEditingController eventNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();

  String? selectedCategory;

  List<Event> get events => _events;
  XFile? get selectedImage => _selectedImage; // Getter for XFile

  void addEvent() {
    if (eventNameController.text.isEmpty ||
        locationController.text.isEmpty ||
        dateController.text.isEmpty ||
        startTimeController.text.isEmpty) {
      print("Please fill all required fields.");
      return;
    }

    ///
    ///  create a new event with the provided details
    ///
    const uuid = Uuid();
    final newEvent = Event(
      id: uuid.v4(),
      eventName: eventNameController.text,
      location: locationController.text,
      date: dateController.text,
      startTime: startTimeController.text,
      category: selectedCategory,
      imageUrl: _selectedImage?.path, // Storing the path of the XFile
      joiningPeople: 10,
      availablePeople: 5,
    );
    _events.add(newEvent);
    clearEventForm();
    notifyListeners();
  }

  ///
  /// image picker
  ///
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _selectedImage = image;
      notifyListeners();
    }
  }

  void clearImage() {
    _selectedImage = null;
    notifyListeners();
  }

  ///
  ///
  ///
  void clearEventForm() {
    eventNameController.clear();
    locationController.clear();
    dateController.clear();
    startTimeController.clear();
    selectedCategory = null;
    _selectedImage = null;
  }

  @override
  void dispose() {
    eventNameController.dispose();
    locationController.dispose();
    dateController.dispose();
    startTimeController.dispose();
    super.dispose();
  }
}
