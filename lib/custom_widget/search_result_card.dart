// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/model/event_model.dart';

class CustomSearchResultCard extends StatelessWidget {
  final EventModel eventModel;
  CustomSearchResultCard({required this.eventModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: thinGreyColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: thinGreyColor,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            height: 105.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage("${eventModel.imageUrl}"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // title
                    Text(
                      eventModel.eventName ?? '',
                      style: style14B.copyWith(fontSize: 12),
                    ),
                    // joining people
                    Text(
                      // upComingEventsCardModel.ratio,
                      "${eventModel.availablePeople ?? ''}/${eventModel.joiningPeople ?? ''}",
                      style: style14B.copyWith(
                        color: primaryColor,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                5.verticalSpace,
                Text(
                  //date
                  eventModel.date ?? '',
                  style: style14.copyWith(fontSize: 10),
                ),
                5.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, color: blackColor, size: 15.h),

                    Expanded(
                      child: Text(
                        //location
                        eventModel.location ?? '',
                        style: style14.copyWith(fontSize: 10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
