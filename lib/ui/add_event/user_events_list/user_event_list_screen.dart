import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/app_assest.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';

import 'package:girl_clan/custom_widget/user_event_list_card.dart';
import 'package:girl_clan/ui/add_event/add_event_screen.dart';
import 'package:girl_clan/ui/add_event/add_event_view_model.dart';
import 'package:girl_clan/ui/add_event/user_events_list/user_events_view_model.dart';
import 'package:girl_clan/ui/profile/profile_screen.dart';
import 'package:provider/provider.dart';

class UserEventListScreen extends StatelessWidget {
  const UserEventListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserEventsViewModel(),
      child: Consumer<UserEventsViewModel>(
        builder:
            (context, model, child) => Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                centerTitle: true,
                title: Container(
                  height: 35.h,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    decoration: CustomEventAuthField.copyWith(
                      hintText: "Search events",
                      suffixIcon: const Icon(
                        Icons.search,
                        color: blackColor,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(ProfileScreen());
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: Image(
                          image: AssetImage(AppAssets().appLogo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Your Event List',
                      style: style16.copyWith(color: primaryColor),
                    ),
                  ),
                  Expanded(
                    ///
                    ///    list of user events
                    ///
                    child:
                        model.UserEventsList.isEmpty
                            ? const Center(
                              child: Text(
                                'No events created yet.',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                            : ListView.builder(
                              shrinkWrap: true,

                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),

                              itemCount: model.UserEventsList.length,
                              itemBuilder: (context, index) {
                                // final event = model.events[index];
                                //return EventListItem(event: event);
                                return CustomEventListItem(
                                  userEvents: model.UserEventsList[index],
                                );
                              },
                            ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateEventScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Add Event',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
