import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/custom_button.dart'; // Assuming you have a custom button

///
///
///     change this when using firebase by yourself
///
class EditProfileScreen extends StatefulWidget {
  final String initialName;
  final String initialLocation;
  final String initialEmail;
  final String initialPhoneNumber;

  const EditProfileScreen({
    Key? key,
    required this.initialName,
    required this.initialLocation,
    required this.initialEmail,
    required this.initialPhoneNumber,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _locationController = TextEditingController(text: widget.initialLocation);
    _emailController = TextEditingController(text: widget.initialEmail);
    _phoneNumberController = TextEditingController(
      text: widget.initialPhoneNumber,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: blackColor),
          onPressed: () {
            Get.back(); // Go back to ProfileScreen
          },
        ),
        title: Text('Edit Profile', style: TextStyle(color: blackColor)),
        backgroundColor: whiteColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name', style: style16.copyWith(color: Colors.grey.shade700)),
            5.verticalSpace,
            _buildTextField(_nameController, 'Enter your name'),
            20.verticalSpace,

            Text(
              'Location',
              style: style16.copyWith(color: Colors.grey.shade700),
            ),
            5.verticalSpace,
            _buildTextField(_locationController, 'Enter your location'),
            20.verticalSpace,

            Text('Email', style: style16.copyWith(color: Colors.grey.shade700)),
            5.verticalSpace,
            _buildTextField(
              _emailController,
              'Enter your email',
              keyboardType: TextInputType.emailAddress,
            ),
            20.verticalSpace,

            Text(
              'Phone Number',
              style: style16.copyWith(color: Colors.grey.shade700),
            ),
            5.verticalSpace,
            _buildTextField(
              _phoneNumberController,
              'Enter your phone number',
              keyboardType: TextInputType.phone,
            ),
            40.verticalSpace,

            CustomButton(
              onTap: () {
                // In a real app, you would save the updated data:
                // String updatedName = _nameController.text;
                // String updatedLocation = _locationController.text;
                // String updatedEmail = _emailController.text;
                // String updatedPhoneNumber = _phoneNumberController.text;
                // Call a viewmodel/service to save this data
                // Then navigate back:
                Get.back(); // Go back to ProfileScreen after saving
                Get.snackbar(
                  'Profile Updated',
                  'Your profile changes have been saved.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: primaryColor,
                  colorText: whiteColor,
                );
              },
              text: "Save Changes",
              backgroundColor:
                  primaryColor, // Use your primary color for the save button
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: lightGreyColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: lightGreyColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: primaryColor), // Focus border color
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
      ),
      style: style16.copyWith(color: blackColor),
    );
  }
}
