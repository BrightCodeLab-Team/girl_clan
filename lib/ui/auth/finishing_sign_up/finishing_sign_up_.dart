import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/ui/home/home_view_model.dart';

class FinishingSignUpScreen extends StatefulWidget {
  @override
  _FinishingSignUpScreenState createState() => _FinishingSignUpScreenState();
}

class _FinishingSignUpScreenState extends State<FinishingSignUpScreen> {
  final TextEditingController _countryRegionController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _showPassword = false;

  @override
  void dispose() {
    _countryRegionController.dispose();
    _phoneNumberController.dispose();
    _birthdayController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: blackColor),
          onPressed: () {
            // Handle back button press
          },
        ),
        title: Text('Finish signing up', style: TextStyle(color: blackColor)),
        backgroundColor: whiteColor,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country/Region & Phone Number
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: lightGreyColor),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _countryRegionController,
                    decoration: InputDecoration(
                      labelText: 'Country/Region',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                    ),
                  ),
                  Divider(height: 1, thickness: 1, color: lightGreyColor),
                  TextField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone number',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Make sure it matches the name on your government ID.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            SizedBox(height: 20),

            // Birthday
            TextFormField(
              controller: _birthdayController,
              readOnly: true, // Make it read-only to show a date picker
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    _birthdayController.text =
                        '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Birthday (dd/mm/yyyy)',
                suffixIcon: Icon(Icons.keyboard_arrow_down),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: lightGreyColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: lightGreyColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.grey.shade600),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'To sign up, you need to be at least 18. Your birthday won\'t be shared with other people who use Airbnb.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            SizedBox(height: 20),

            // Email
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Clare@gmail.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.grey.shade600),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'We\'ll email you trip confirmations and receipts',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            SizedBox(height: 20),

            // Password
            TextField(
              controller: _passwordController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0, top: 15),
                    child: Text(
                      _showPassword ? 'Hide' : 'Show',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: lightGreyColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: lightGreyColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: secondaryColor),
                ),
              ),
            ),
            SizedBox(height: 30),

            Center(
              child: CustomButton(
                onTap: () {
                  Get.to(HomeScreen());
                },
                text: "Continue",
                backgroundColor: secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
