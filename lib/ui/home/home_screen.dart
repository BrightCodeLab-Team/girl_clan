import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/home_top_pick_events.dart';
import 'package:girl_clan/custom_widget/home_up_coming_events.dart';
import 'package:girl_clan/ui/home/events_details_screen.dart';
import 'package:girl_clan/ui/home/home_view_model.dart';
import 'package:girl_clan/ui/home/popular_events.dart';
import 'package:girl_clan/ui/home/search_result_screen.dart' as search_result;
import 'package:girl_clan/ui/home/search_screen.dart';
import 'package:girl_clan/ui/home/up_coming_events.dart';
import 'package:girl_clan/ui/notification_screen/notification_screen.dart';
import 'package:girl_clan/ui/profile/profile_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder:
            (context, model, child) => Scaffold(
              appBar: AppBar(
                leading: GestureDetector(
                  onTap: () {
                    Get.to(ProfileScreen());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: CircleAvatar(
                      radius: 25.r,
                      child: Image.asset(
                        AppAssets().appLogo,
                        fit: BoxFit.cover,
                      ),
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
                                  return const CustomFilterBottomSheet();
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
                      onFieldSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          Get.to(() => search_result.SearchResultScreen());
                        }
                      },
                    ),

                    20.verticalSpace,
                    Row(
                      children: [
                        Text('Upcoming Events', style: style14B),
                        Spacer(),
                        TextButton(
                          onPressed: () {
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
                      child: ListView.builder(
                        itemCount: model.UpComingEventsList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 5.w),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(EventsDetailsScreen());
                              },
                              child: CustomUpComingEventsCard(
                                eventMOdel: model.UpComingEventsList[index],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    10.verticalSpace,

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
                            text: 'Cinema',
                            isSelected: model.selectedTabIndex == 3,
                            onTap: () => model.selectedTabFunction(3),
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
                          child: ListView.builder(
                            itemCount: model.TopPickEventsList.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(EventsDetailsScreen());
                                  },
                                  child: CustomHomeTopPickEventsCard(
                                    topPickModel:
                                        model.TopPickEventsList[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                        : model.selectedTabIndex == 1
                        ? Text('Content for Hiking Tab')
                        : model.selectedTabIndex == 2
                        ? Text('Content for concert Tab')
                        : model.selectedTabIndex == 3
                        ? Text('Content for cinema Tab')
                        : Text('no data found'),
                  ],
                ),
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
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
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
