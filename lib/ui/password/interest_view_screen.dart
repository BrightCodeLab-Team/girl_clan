import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/ui/interests/interest_screen.dart';

class InterestsViewScreen extends StatelessWidget {
  final List<String> selected;

  const InterestsViewScreen({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Interests", style: style25B.copyWith(fontSize: 22)),
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.only(left: 15),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: thinGreyColor,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_sharp),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(InterestScreen(selected: []));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Image.asset(
                AppAssets().editIcon,
                scale: 4,
                color: primaryColor,
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
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
