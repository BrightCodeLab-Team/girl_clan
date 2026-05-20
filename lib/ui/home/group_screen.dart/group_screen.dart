// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/group_cards.dart';
import 'package:girl_clan/ui/home/group_details_screen.dart';
import 'package:girl_clan/ui/home/home_view_model.dart';
import 'package:provider/provider.dart';

class GroupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder:
          (context, model, child) => Scaffold(
            appBar: AppBar(
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
              title: Text('Groups', style: style25B.copyWith(fontSize: 22)),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  10.verticalSpace,

                  //  search result
                  FutureBuilder(
                    future:
                        model.groupsList.isEmpty
                            ? model.groupsData()
                            : Future.value(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Expanded(
                        child:
                            model.groupsList.isEmpty
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
                                      model.groupsList.length, //in this line
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,

                                  itemBuilder: (
                                    BuildContext context,
                                    int index,
                                  ) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          GroupDetailsScreen(
                                            groupsModel:
                                                model.groupsList[index],
                                          ),
                                        );
                                      },
                                      child: GroupCards(
                                        groupsModel:
                                            model
                                                .groupsList[index], //in this line
                                      ),
                                    );
                                  },
                                ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
