import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/ui/home/home_screen.dart';

class TellUsMoreScreen extends StatefulWidget {
  @override
  _TellUsMoreScreenState createState() => _TellUsMoreScreenState();
}

class _TellUsMoreScreenState extends State<TellUsMoreScreen> {
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();

  @override
  void dispose() {
    _dateOfBirthController.dispose();
    _nationalityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: blackColor),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text('Tell Us More', style: TextStyle(color: blackColor)),
        backgroundColor: whiteColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            TextFormField(
              controller: _dateOfBirthController,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2002, 12, 12),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    _dateOfBirthController.text =
                        '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Date Of Birth',
                hintText: '12/12/2002',
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
            SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: lightGreyColor),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: DropdownButtonFormField<String>(
                value: 'Ireland',
                decoration: InputDecoration(
                  labelText: 'Nationality',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                ),
                icon: Icon(Icons.keyboard_arrow_down),
                items:
                    <String>[
                      'Ireland',
                      'United States',
                      'Canada',
                      'United Kingdom',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _nationalityController.text = newValue ?? '';
                  });
                },
              ),
            ),
            SizedBox(height: 30),

            RichText(
              text: TextSpan(
                style: style14.copyWith(fontSize: 14, color: blackColor),
                children: [
                  TextSpan(
                    text: 'By Selecting Agree and continue, I agree to our ',
                  ),
                  TextSpan(
                    text: 'Terms of Service, ',
                    style: style14.copyWith(
                      color: darkBlueColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: 'Payments Terms of Service ',
                    style: style14.copyWith(
                      color: darkBlueColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(text: 'and \n'),
                  TextSpan(
                    text: 'Nondiscrimination Policy ',
                    style: style14.copyWith(
                      color: darkBlueColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(text: 'and acknowledge the \n'),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: style14.copyWith(
                      color: darkBlueColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            Center(
              child: CustomButton(
                onTap: () {
                  Get.to(() => HomeScreen());
                },
                text: "Agree and continue",
                backgroundColor: secondaryColor,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
