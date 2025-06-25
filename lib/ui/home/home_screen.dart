import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/home_top_pick_events.dart';
import 'package:girl_clan/custom_widget/home_up_coming_events.dart';
import 'package:girl_clan/ui/add_event/add_event_screen.dart';
import 'package:girl_clan/ui/home/events_details_screen.dart';
import 'package:girl_clan/ui/home/home_view_model.dart';
import 'package:girl_clan/ui/home/popular_events.dart';
import 'package:girl_clan/ui/home/search_result_screen.dart' as search_result;
import 'package:girl_clan/ui/home/up_coming_events.dart';
import 'package:girl_clan/ui/notification_screen/notification_screen.dart';
import 'package:girl_clan/ui/profile/profile_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder:
          (context, model, child) => Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () async {
                final result = await Get.to(() => const AddEventScreen());
                if (result == true) {
                  // Refresh all event data
                  Provider.of<HomeViewModel>(
                    context,
                    listen: false,
                  ).refreshAllEvents();
                }
              },

              child: Icon(Icons.add, color: whiteColor),
            ),
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () {
                  Get.to(ProfileScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: CircleAvatar(
                    radius: 25.r,
                    child: Image.asset(AppAssets().appLogo, fit: BoxFit.cover),
                  ),
                ),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('shayan zahid', style: style14.copyWith(fontSize: 12)),
                  2.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: blackColor,
                        size: 15.h,
                      ),
                      1.horizontalSpace,
                      Text(
                        'District Mardan tehsil K..',
                        style: style14B.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    Get.to(NotificationScreen());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: thinGreyColor,
                      child: Icon(Icons.notifications),
                    ),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  10.verticalSpace,
                  TextFormField(
                    autofocus: true,
                    decoration: customHomeAuthField.copyWith(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 8.0),

                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext context) {
                                return const search_result.CustomFilterBottomSheet();
                              },
                            );
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.tune,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    onTap: () {
                      Get.to(() => search_result.SearchResultScreen());
                    },
                  ),

                  20.verticalSpace,
                  Row(
                    children: [
                      Text('Upcoming Events', style: style14B),
                      Spacer(),
                      TextButton(
                        onPressed: () async {
                          Get.to(UpComingEventsScreen());
                        },
                        child: Text(
                          'View All',
                          style: style14.copyWith(
                            fontSize: 13,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward, color: primaryColor, size: 15),
                    ],
                  ),
                  10.verticalSpace,

                  ///
                  ///     up coming events
                  ///
                  SizedBox(
                    height: 88.h,
                    child:
                        model.upcomingEventsList.isEmpty
                            ? Center(child: Text('No Upcoming Events '))
                            : ListView.builder(
                              // itemCount: model.UpComingEventsList.length,
                              itemCount: model.upcomingEventsList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 5.w),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(EventsDetailsScreen());
                                    },
                                    child: CustomUpComingEventsCard(
                                      eventModel:
                                          model.upcomingEventsList[index],
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                  10.verticalSpace,

                  ///
                  ///. top picks
                  ///
                  Row(
                    children: [
                      Text('Top Picks', style: style14B),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          Get.to(PopularEventsScreen());
                        },
                        child: Text(
                          'View All',
                          style: style14.copyWith(
                            fontSize: 13,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward, color: primaryColor, size: 15),
                    ],
                  ),
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

                  20.verticalSpace, //
                  ///
                  ///    top picks card
                  ///
                  ///.   All tabs
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

///
///      top picks tabs
///

class CustomTabWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomTabWidget({
    Key? key,
    required this.icon,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : thinGreyColor,
          borderRadius: BorderRadius.circular(50.r),
          border:
              isSelected ? Border.all(color: primaryColor, width: 2.w) : null,
        ),
        child: Row(
          //  mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : blackColor,
              size: 20.h,
            ),
            4.horizontalSpace,
            Text(
              text,
              style: style14B.copyWith(
                fontSize: 14,
                color: isSelected ? Colors.white : blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
