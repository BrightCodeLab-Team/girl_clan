import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/ui/interests/edit_interest_screen.dart';
import 'package:girl_clan/ui/profile/profile_screen.dart';

class InterestScreen extends StatelessWidget {
  final List<String> selected;

  const InterestScreen({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: GestureDetector(
              onTap: () {
                //  Navigator.pop(context);
                Get.to(ProfileScreen());
              },
              child: const Icon(Icons.arrow_back_ios_outlined),
            ),
          ),
        ),
        centerTitle: false,
        title: Text('Interest', style: style25B.copyWith(fontSize: 22)),
        actions: [
          IconButton(
            icon: Image.asset(
              AppAssets().editIcon,
              scale: 4,
              color: Colors.blue, // Replace with primaryColor
            ),
            onPressed: () {
              Get.to(EditInterestScreen());
            },
          ),
        ],
      ),
      //  CustomAppBar(
      //   title: 'Interest Screen',
      //   showEdit: true,
      //   onEditTap: () {
      //     Get.to(EditInterestScreen());
      //   },
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children:
              selected.map((interest) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Text(
                    interest,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
