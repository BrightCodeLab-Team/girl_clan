import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girl_clan/custom_widget/app_bar.dart';
import 'package:girl_clan/ui/interests/edit_interest_screen.dart';

class InterestScreen extends StatelessWidget {
  final List<String> selected;

  const InterestScreen({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Interest Screen',
        showEdit: true,
        onEditTap: () {
          Get.to(EditInterestScreen());
        },
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
