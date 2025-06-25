import 'package:flutter/material.dart';
import 'package:girl_clan/custom_widget/app_bar.dart';
import 'package:girl_clan/ui/interests/interest_screen.dart';

class EditInterestScreen extends StatefulWidget {
  const EditInterestScreen({super.key});

  @override
  State<EditInterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<EditInterestScreen> {
  List<String> interests = [
    'Party',
    'Concert',
    'Travel',
    'Festival',
    'Hiking',
    'Food & Drinks',
    'Beach Day',
    'Road Trip',
    'Camping',
    'Workshop',
  ];

  Set<String> selectedInterests = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Edit Interests', showEdit: false),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 3,
          children:
              interests.map((interest) {
                final isSelected = selectedInterests.contains(interest);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedInterests.remove(interest);
                      } else {
                        selectedInterests.add(interest);
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          isSelected ? const Color(0xFF30D1CC) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Text(
                      interest,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF30D1CC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => InterestScreen(selected: selectedInterests.toList()),
              ),
            );
          },
          child: const Text(
            'Edit Interests',
            style: TextStyle(fontSize: 16, fontFamily: 'Quicksand'),
          ),
        ),
      ),
    );
  }
}
