// ignore_for_file: use_key_in_widget_constructors, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/custom_widget/custom_groups_cards.dart';
import 'package:girl_clan/custom_widget/home_top_pick_events.dart';
import 'package:girl_clan/custom_widget/home_up_coming_events.dart';
import 'package:girl_clan/custom_widget/shimmer/all_events_shimmer.dart';
import 'package:girl_clan/custom_widget/shimmer/up_coming_events.dart';
import 'package:girl_clan/ui/Event/create_tab_screen.dart';
import 'package:girl_clan/ui/home/events_details_screen.dart';
import 'package:girl_clan/ui/home/group_details_screen.dart';
import 'package:girl_clan/ui/home/group_screen.dart/group_screen.dart';
import 'package:girl_clan/ui/home/home_view_model.dart';
import 'package:girl_clan/ui/home/popular_events.dart';
import 'package:girl_clan/ui/home/search_result_screen.dart' as search_result;
import 'package:girl_clan/ui/home/up_coming_events.dart';
import 'package:girl_clan/ui/root_screen/root_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder:
          (context, model, child) => RefreshIndicator(
            onRefresh: () async {
              await model.upComingEvents();
              await model.getAllEvent(
                model.tabs[model.selectedTabIndex]['text'],
              );
              await model.groupsData();
              await model.getCurrentUserEvents();
            },

            child: Scaffold(
              ///
              /// App Bar
              ///
              appBar: _appBar(model),

              ///
              /// Body
              ///
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: ListView(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [
                    10.verticalSpace,
                    TextFormField(
                      autofocus: true,
                      readOnly: true,
                      decoration: customHomeAuthField.copyWith(
                        prefixIcon: Icon(
                          Icons.search,
                          color: ternaryColor,
                          size: 24,
                        ),

                        prefixStyle: style20B.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade400,
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8.0),

                          child: GestureDetector(
                            onTap: () {
                              // showModalBottomSheet(
                              //   context: context,
                              //   isScrollControlled: true,
                              //   backgroundColor: Colors.transparent,
                              //   builder: (BuildContext context) {
                              //     return search_result.CustomFilterBottomSheet(
                              //       onApply: (category, date, location) {
                              //         model.applyFilter(
                              //           category: category,
                              //           date: date,
                              //           location: location,
                              //         );
                              //       },
                              //     );
                              //   },
                              // );
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
                            Get.to(() => UpComingEventsScreen());
                          },
                          child: Text(
                            'View All',
                            style: style14.copyWith(
                              fontSize: 13,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: primaryColor,
                          size: 15,
                        ),
                      ],
                    ),
                    10.verticalSpace,

                    ///
                    ///     up coming events
                    ///
                    SizedBox(
                      height: 88.h,
                      child:
                          model.state == ViewState.busy
                              ? UpcomingEventsShimmer()
                              : model.upcomingEventsList.isEmpty &&
                                  model.upcomingEventsList == null
                              ? Center(child: Text('No Upcoming Events '))
                              : ListView.builder(
                                shrinkWrap: true,
                                physics: AlwaysScrollableScrollPhysics(),
                                // itemCount: model.UpComingEventsList.length,
                                itemCount:
                                    model.upcomingEventsList.length > 6
                                        ? 6
                                        : model.upcomingEventsList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 5.w),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          EventsDetailsScreen(
                                            eventModel:
                                                model.upcomingEventsList[index],
                                          ),
                                        );
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

                    20.verticalSpace,
                    Row(
                      children: [
                        Text('Groups', style: style14B),
                        Spacer(),
                        TextButton(
                          onPressed: () async {
                            Get.to(() => GroupScreen());
                          },
                          child: Text(
                            'View All',
                            style: style14.copyWith(
                              fontSize: 13,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: primaryColor,
                          size: 15,
                        ),
                      ],
                    ),
                    10.verticalSpace,

                    ///
                    ///     up coming events
                    ///
                    SizedBox(
                      height: 88.h,
                      child:
                          model.state == ViewState.busy
                              ? UpcomingEventsShimmer()
                              : model.groupsList.isEmpty &&
                                  model.groupsList == null
                              ? Center(child: Text('No Groups'))
                              : ListView.builder(
                                shrinkWrap: true,
                                physics: AlwaysScrollableScrollPhysics(),
                                // itemCount: model.UpComingEventsList.length,
                                itemCount:
                                    model.groupsList.length > 6
                                        ? 6
                                        : model.groupsList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 5.w),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          GroupDetailsScreen(
                                            groupsModel:
                                                model.groupsList[index],
                                          ),
                                        );
                                        print(
                                          "GroupModel: ${model.groupsList[index]}",
                                        );
                                        print(
                                          "GroupModel ID: ${model.groupsList[index].id}",
                                        );
                                      },
                                      child: CustomGroupsCards(
                                        groupsModal: model.groupsList[index],
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
                        Icon(
                          Icons.arrow_forward,
                          color: primaryColor,
                          size: 15,
                        ),
                      ],
                    ),
                    10.verticalSpace,

                    ///
                    ///     top picks tabs
                    ///
                    ///
                    SizedBox(
                      height: 40.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: model.tabs.length,
                        itemBuilder: (context, index) {
                          final tab = model.tabs[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              right: 5.w,
                            ), // spacing between tabs
                            child: CustomTabWidget(
                              icon: tab['icon'],
                              text: tab['text'],
                              isSelected: model.selectedTabIndex == index,
                              onTap: () => model.selectedTabFunction(index),
                            ),
                          );
                        },
                      ),
                    ),

                    20.verticalSpace, //
                    ///
                    ///    top picks card
                    ///
                    ///.   All tabs
                    model.state == ViewState.busy
                        ? TopPicksShimmer()
                        : model.allEventsList.isEmpty
                        ? Center(
                          child: Text(
                            'No Events found',
                            style: style18B.copyWith(),
                          ),
                        )
                        : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                              model.allEventsList.length > 6
                                  ? 6
                                  : model.allEventsList.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(
                                    EventsDetailsScreen(
                                      eventModel: model.allEventsList[index],
                                    ),
                                  );
                                },
                                child: CustomHomeTopPickEventsCard(
                                  eventModel: model.allEventsList[index],
                                ),
                              ),
                            );
                          },
                        ),
                  ],
                ),
              ),

              ///
              /// Floating Action Button
              ///
              floatingActionButton: FloatingActionButton(
                backgroundColor: primaryColor,
                onPressed: () async {
                  final result = await Get.to(() => CreateTabScreen());
                  if (result == true) {
                    // Refresh all event data
                    Provider.of<HomeViewModel>(
                      // ignore: use_build_context_synchronously
                      context,
                      listen: false,
                    ).refreshAllEvents();
                  }
                },

                child: Icon(Icons.add, color: whiteColor),
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

  // ignore: use_super_parameters
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
        margin: EdgeInsets.only(left: 10),
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

_appBar(HomeViewModel model) {
  return AppBar(
    leading: GestureDetector(
      onTap: () {
        Get.offAll(() => RootScreen(selectedScreen: 2));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream:
              model.currentUser != null
                  ? FirebaseFirestore.instance
                      .collection("app-user")
                      .doc(model.currentUser.currentUser!.uid)
                      .snapshots()
                  : null,
          builder: (context, snapshot) {
            if (!snapshot.hasData || !snapshot.data!.exists) {
              // Agar user data hi nahi mila to default asset icon
              return CircleAvatar(
                radius: 25.r,
                child: Image.asset(AppAssets().profileIcon, scale: 3),
              );
            }

            final data = snapshot.data!.data() as Map<String, dynamic>?;

            // Agar profileImageUrl null ya empty hai to bhi default asset
            final profileImageUrl = data?['imgUrl'] as String?;

            if (profileImageUrl == null || profileImageUrl.isEmpty) {
              return CircleAvatar(
                radius: 25.r,
                child: Image.asset(AppAssets().profileIcon, scale: 3),
              );
            } else {
              // Agar profileImageUrl mila to network image dikhaye
              return CircleAvatar(
                radius: 25.r,
                backgroundImage: NetworkImage(profileImageUrl),
              );
            }
          },
        ),
      ),
    ),

    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder(
          stream:
              model.currentUser != null
                  ? FirebaseFirestore.instance
                      .collection("app-user")
                      .doc(model.currentUser.currentUser!.uid)
                      .snapshots()
                  : null,

          builder: (context, snapshot) {
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text(''));
            }
            final data = snapshot.data!.data()!;
            final firstName = data['firstName'] ?? '';
            final surName = data['surName'] ?? '';
            final location = data['location'] ?? '';

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$firstName  $surName',
                  style: style14B,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 13),
                    3.horizontalSpace,
                    Text(
                      '$location',
                      style: style12N,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    ),
    // actions: [
    //   GestureDetector(
    //     onTap: () {
    //       Get.to(() => NotificationScreen());
    //     },
    //     child: Padding(
    //       padding: const EdgeInsets.only(right: 15.0),
    //       child: CircleAvatar(
    //         radius: 20,
    //         backgroundColor: primaryColor,
    //         child: Icon(Icons.notifications, color: whiteColor),
    //       ),
    //     ),
    //   ),
    // ],
  );
}
