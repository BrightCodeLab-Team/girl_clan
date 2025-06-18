import 'package:flutter/material.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/app_bar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // Dummy notification data
  final List<Map<String, String>> recent = const [
    {
      "title": "You're in!",
      "message": "You've successfully joined Sunset Beach Party.",
      "time": "03:45 AM",
      "image": "assets/dynamic_assets/snowfall.png",
    },
    {
      "title": "Just Announced:",
      "message": "City Beats Concert drops this Friday!",
      "time": "03:45 AM",
      "image": "assets/dynamic_assets/music.png",
    },
    {
      "title": "Don't be late!",
      "message": "Foodie Festival kicks off in 30 minutes.",
      "time": "03:45 AM",
      "image": "assets/dynamic_assets/height.png",
    },
  ];

  final List<Map<String, String>> todays = const [
    {
      "title": "You're in!",
      "message": "You've successfully joined Sunset Beach Party.",
      "time": "03:45 AM",
      "image": "assets/dynamic_assets/snowfall.png",
    },
    {
      "title": "Just Announced:",
      "message": "City Beats Concert drops this Friday!",
      "time": "03:45 AM",
      "image": "assets/dynamic_assets/music.png",
    },
    {
      "title": "Don't be late!",
      "message": "Foodie Festival kicks off in 30 minutes.",
      "time": "03:45 AM",
      "image": "assets/dynamic_assets/height.png",
    },
    {
      "title": "Don't be late!",
      "message": "Foodie Festival kicks off in 30 minutes.",
      "time": "03:45 AM",
      "image": "assets/dynamic_assets/height.png",
    },
    {
      "title": "Don't be late!",
      "message": "Foodie Festival kicks off in 30 minutes.",
      "time": "03:45 AM",
      "image": "assets/dynamic_assets/height.png",
    },
  ];

  final List<Map<String, String>> thursday = const [
    {
      "title": "You're in!",
      "message": "You've successfully joined Sunset Beach Party.",
      "time": "03:45 AM",
      "image": "assets/dynamic_assets/snowfall.png",
    },
    {
      "title": "Just Announced:",
      "message": "City Beats Concert drops this Friday!",
      "time": "03:45 AM",
      "image": "assets/dynamic_assets/music.png",
    },
  ];

  Widget buildNotificationItem(Map<String, String> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage(AppAssets().appLogo),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title']!,
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item['message']!,
                  style: style14.copyWith(color: blackColor.withOpacity(0.4)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item['time']!,
            style: style12.copyWith(color: blackColor.withOpacity(0.4)),
          ),
        ],
      ),
    );
  }

  Widget buildSection(String title, List<Map<String, String>> data) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: style12),
          const SizedBox(height: 10),
          ...data.map(buildNotificationItem).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Notifications'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSection("Recent", recent),
            buildSection("Today's", todays),
            buildSection("Thursday's", thursday),
          ],
        ),
      ),
    );
  }
}
