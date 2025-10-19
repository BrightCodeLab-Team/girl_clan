// create_group_view_model.dart

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:girl_clan/ui/root_screen/root_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:girl_clan/core/model/groups_model.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/core/others/base_view_model.dart';

class CreateGroupViewModel extends BaseViewModel {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  String? selectedCategory;
  File? pickedImage;
  Uint8List? webImage;
  GroupsModel groupsModel = GroupsModel();
  final List<String> categories = ['Study', 'Fun', 'Meetup', 'Workshop'];

  void setCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

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

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      if (kIsWeb) {
        webImage = await picked.readAsBytes();
        pickedImage = null;
      } else {
        pickedImage = File(picked.path);
        webImage = null;
      }
      notifyListeners();
    }
  }

  Future<String?> uploadImage() async {
    try {
      final ref = FirebaseStorage.instance.ref().child(
        "groups/${DateTime.now().millisecondsSinceEpoch}",
      );

      UploadTask uploadTask;

      if (kIsWeb && webImage != null) {
        uploadTask = ref.putData(
          webImage!,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else if (pickedImage != null) {
        uploadTask = ref.putFile(pickedImage!);
      } else {
        return null;
      }

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint("Upload Error: $e");
      return null;
    }
  }

  Future<void> createGroup(
    BuildContext context,
    String hostUserId,
    String hostName,
    String hostImage,
  ) async {
    setState(ViewState.busy);

    try {
      // 1. Upload group image
      final imageUrl = await uploadImage();

      // 2. Create a new document reference for atomic writes
      final groupDocRef =
          FirebaseFirestore.instance.collection('events_groups').doc();

      // 3. Prepare group data with host as admin and first member
      final groupData = GroupsModel(
        id: groupDocRef.id, // Use the auto-generated document ID
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        category: selectedCategory ?? '',
        location: locationController.text.trim(),
        imageUrl: imageUrl ?? '',
        createdAt: DateTime.now().toIso8601String(),
        hostUserId: hostUserId,
        hostName: hostName,
        hostImage: hostImage,
        locationLat: groupsModel.locationLat,
        locationLng: groupsModel.locationLng,
        joinedUsers: [hostUserId], // Automatically add host as first member
        adminIds: [hostUserId], // Explicit admin tracking
      );

      // 4. Batch write for atomic operations
      final batch = FirebaseFirestore.instance.batch();

      // 4a. Create the group
      batch.set(groupDocRef, groupData.toJson());

      // 4b. Update user's groups list
      final userRef = FirebaseFirestore.instance
          .collection('app-user')
          .doc(hostUserId);
      batch.update(userRef, {
        'createdGroups': FieldValue.arrayUnion([groupDocRef.id]),
        'joinedGroups': FieldValue.arrayUnion([groupDocRef.id]),
      });

      // 5. Commit the batch
      await batch.commit();

      // 6. Show success and navigate
      Get.snackbar('Success', 'Group Created Successfully');
      Get.offAll(() => RootScreen());
      clearForm();
    } catch (e) {
      Get.snackbar('Error', 'Failed to create group: ${e.toString()}');
      debugPrint("Create Group Error: $e");
    } finally {
      setState(ViewState.idle);
    }
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    locationController.clear();
    pickedImage = null;
    webImage = null;
    selectedCategory = null;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }
}
