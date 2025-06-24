import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/app_bar.dart';
import 'package:girl_clan/custom_widget/home_top_pick_events.dart';
import 'package:girl_clan/ui/home/events_details_screen.dart';
import 'package:girl_clan/ui/home/home_screen.dart';
import 'package:girl_clan/ui/home/home_view_model.dart';
import 'package:provider/provider.dart';

class PopularEventsScreen extends StatelessWidget {
  const PopularEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder:
          (context, model, child) => Scaffold(
            appBar: CustomAppBar(title: 'Top Picks'),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.verticalSpace,

                  ///
                  ///     top picks tabs
                  ///
                  ///
                  SizedBox(
                    height: 40.h, // Define a height for the tab bar
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        CustomTabWidget(
                          icon: Icons.apps, // All icon
                          text: 'All',
                          isSelected: model.selectedTabIndex == 0,
                          onTap: () => model.selectedTabFunction(0),
                        ),
                        5.horizontalSpace,
                        CustomTabWidget(
                          icon: Icons.hiking, // Hiking icon
                          text: 'Hiking',
                          isSelected: model.selectedTabIndex == 1,
                          onTap: () => model.selectedTabFunction(1),
                        ),
                        5.horizontalSpace,
                        CustomTabWidget(
                          icon: Icons.music_note, // Concert icon
                          text: 'Concert',
                          isSelected: model.selectedTabIndex == 2,
                          onTap: () => model.selectedTabFunction(2),
                        ),
                        5.horizontalSpace,
                        CustomTabWidget(
                          icon: Icons.music_note, // Concert icon
                          text: 'Party',
                          isSelected: model.selectedTabIndex == 3,
                          onTap: () => model.selectedTabFunction(3),
                        ),

                        CustomTabWidget(
                          icon: Icons.music_note, // Concert icon
                          text: 'Workshop',
                          isSelected: model.selectedTabIndex == 4,
                          onTap: () => model.selectedTabFunction(4),
                        ),
                        CustomTabWidget(
                          icon: Icons.music_note, // Concert icon
                          text: 'Sports',
                          isSelected: model.selectedTabIndex == 5,
                          onTap: () => model.selectedTabFunction(5),
                        ),
                        CustomTabWidget(
                          icon: Icons.music_note, // Concert icon
                          text: 'Art Exhibitions',
                          isSelected: model.selectedTabIndex == 6,
                          onTap: () => model.selectedTabFunction(6),
                        ),
                      ],
                    ),
                  ),

                  20.verticalSpace, // Adjus
                  ///
                  ///    top picks card
                  ///
                  model.selectedTabIndex == 0
                      ? Expanded(
                        child:
                            model.allEventsList.isEmpty
                                ? Center(
                                  child: Text(
                                    'No Events found',
                                    style: style18B.copyWith(),
                                  ),
                                )
                                : ListView.builder(
                                  itemCount: model.allEventsList.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (
                                    BuildContext context,
                                    int index,
                                  ) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(EventsDetailsScreen());
                                        },
                                        child: CustomHomeTopPickEventsCard(
                                          eventModel:
                                              model.allEventsList[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      )
                      ///
                      /// . hiking tab
                      ///
                      : model.selectedTabIndex == 1
                      ? Expanded(
                        child:
                            model.hikingList.isEmpty
                                ? Center(
                                  child: Text(
                                    'No Hiking Events found',
                                    style: style18B.copyWith(),
                                  ),
                                )
                                : ListView.builder(
                                  itemCount: model.hikingList.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (
                                    BuildContext context,
                                    int index,
                                  ) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(EventsDetailsScreen());
                                        },
                                        child: CustomHomeTopPickEventsCard(
                                          eventModel: model.hikingList[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      )
                      ///
                      ///. party tab
                      ///
                      : model.selectedTabIndex == 3
                      ? Expanded(
                        child:
                            model.partyList.isEmpty
                                ? Center(
                                  child: Text(
                                    'No Party Events found',
                                    style: style18B.copyWith(),
                                  ),
                                )
                                : ListView.builder(
                                  itemCount: model.partyList.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (
                                    BuildContext context,
                                    int index,
                                  ) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(EventsDetailsScreen());
                                        },
                                        child: CustomHomeTopPickEventsCard(
                                          eventModel: model.partyList[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      )
                      ///
                      ///.  concert tab
                      ///
                      : model.selectedTabIndex == 2
                      ? Expanded(
                        child:
                            model.concertList.isEmpty
                                ? Center(
                                  child: Text(
                                    'No Concert Events found',
                                    style: style18B.copyWith(),
                                  ),
                                )
                                : ListView.builder(
                                  itemCount: model.concertList.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (
                                    BuildContext context,
                                    int index,
                                  ) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(EventsDetailsScreen());
                                        },
                                        child: CustomHomeTopPickEventsCard(
                                          eventModel: model.concertList[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      )
                      ///
                      ///. workshop tab
                      ///
                      : model.selectedTabIndex == 4
                      ? Expanded(
                        child:
                            model.workshopList.isEmpty
                                ? Center(
                                  child: Text(
                                    'No Workshop Events found',
                                    style: style18B.copyWith(),
                                  ),
                                )
                                : ListView.builder(
                                  itemCount: model.workshopList.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (
                                    BuildContext context,
                                    int index,
                                  ) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(EventsDetailsScreen());
                                        },
                                        child: CustomHomeTopPickEventsCard(
                                          eventModel: model.workshopList[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      )
                      ///
                      ///. sports tab
                      ///
                      : model.selectedTabIndex == 5
                      ? Expanded(
                        child:
                            model.sportsList.isEmpty
                                ? Center(
                                  child: Text(
                                    'No Sports Events found',
                                    style: style18B.copyWith(),
                                  ),
                                )
                                : ListView.builder(
                                  itemCount: model.sportsList.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (
                                    BuildContext context,
                                    int index,
                                  ) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(EventsDetailsScreen());
                                        },
                                        child: CustomHomeTopPickEventsCard(
                                          eventModel: model.sportsList[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      )
                      ///
                      ///. art exhibitions tab
                      ///
                      : model.selectedTabIndex == 6
                      ? Expanded(
                        child:
                            model.artExhibitionsList.isEmpty
                                ? Center(
                                  child: Text(
                                    'No Art Exhibitions Events found',
                                    style: style18B.copyWith(),
                                  ),
                                )
                                : ListView.builder(
                                  itemCount: model.artExhibitionsList.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (
                                    BuildContext context,
                                    int index,
                                  ) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(EventsDetailsScreen());
                                        },
                                        child: CustomHomeTopPickEventsCard(
                                          eventModel:
                                              model.artExhibitionsList[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      )
                      : Expanded(
                        child: Center(
                          child: Text(
                            'No data found',
                            style: style18B.copyWith(),
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
