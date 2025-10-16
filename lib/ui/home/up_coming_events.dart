// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/search_result_card.dart';
import 'package:girl_clan/ui/home/events_details_screen.dart';
import 'package:girl_clan/ui/home/home_view_model.dart';
import 'package:provider/provider.dart';

class UpComingEventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder:
          (context, model, child) => Scaffold(
            ///
            /// App Bar
            ///
            appBar: appBar(context),

            ///
            /// Start Body
            ///
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  10.verticalSpace,
                  Expanded(
                    child:
                        model.upcomingEventsList.isEmpty
                            ? Center(
                              child: Text(
                                'No Upcoming Events',
                                style: style18B.copyWith(),
                              ),
                            )
                            : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.71,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),

                              ///
                              ///  changes here
                              ///
                              itemCount:
                                  model
                                      .upcomingEventsList
                                      .length, //in this line
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,

                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      EventsDetailsScreen(
                                        eventModel:
                                            model.upcomingEventsList[index],
                                      ),
                                    );
                                  },
                                  child: CustomSearchResultCard(
                                    eventModel:
                                        model
                                            .upcomingEventsList[index], //in this line
                                  ),
                                );
                              },
                            ),
                  ),

                  //  search result
                  // FutureBuilder(
                  //   future:
                  //       model.upcomingEventsList.isEmpty
                  //           ? model.upComingEvents()
                  //           : Future.value(),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return Center(child: CircularProgressIndicator());
                  //     }
                  //     return ;
                  //   },
                  // ),
                ],
              ),
            ),
          ),
    );
  }
}

AppBar appBar(BuildContext context) {
  return AppBar(
    leading: Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: CircleAvatar(
        backgroundColor: thinGreyColor,
        child: GestureDetector(
          onTap: () {
            navigator!.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
    ),
    title: Text('UpComing Events', style: style25B.copyWith(fontSize: 22)),
  );
}
