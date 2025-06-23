import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/model/event_model.dart';

class CustomSearchResultCard extends StatelessWidget {
  // final UpComingEventsCardModel upComingEventsCardModel;
  final EventModel eventModel;
  const CustomSearchResultCard({
    super.key,
    //  required this.upComingEventsCardModel,
    required this.eventModel,
  });

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                // image
                eventModel.imageUrl ?? '',
                height: 105.h,
                width: double.infinity,
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
