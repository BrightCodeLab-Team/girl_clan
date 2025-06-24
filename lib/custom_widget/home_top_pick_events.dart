import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/model/event_model.dart';
import '../core/model/event_model.dart' show EventModel;

class CustomHomeTopPickEventsCard extends StatelessWidget {
  //final TopPicksCardModel topPickModel;
  final EventModel eventModel;
  const CustomHomeTopPickEventsCard({super.key, required this.eventModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190.h,
      width: double.infinity, // Take full width
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(eventModel.imageUrl ?? ""),
          fit: BoxFit.cover,
        ),
        color: thinGreyColor, // Background color
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        // Use Stack to layer the gradient and content
        children: [
          // Gradient Overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, blackColor.withOpacity(0.9)],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      eventModel.category ?? "",
                      style: style14B.copyWith(fontSize: 12, color: whiteColor),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          eventModel.eventName ?? " ",
                          style: style16B.copyWith(
                            fontSize: 18,
                            color: whiteColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        8.verticalSpace,
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: whiteColor,
                              size: 16.h,
                            ),
                            2.horizontalSpace,
                            Text(
                              eventModel.location ?? '',
                              style: style14.copyWith(
                                fontSize: 13,
                                color: whiteColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${eventModel.availablePeople}/${eventModel.joiningPeople}",
                          style: style14.copyWith(
                            fontSize: 13,
                            color: whiteColor,
                          ),
                        ),
                        10.verticalSpace,
                        Text(
                          eventModel.date ?? '',
                          style: style14B.copyWith(
                            fontSize: 13,
                            color: whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
