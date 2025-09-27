import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/strings.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/model/event_model.dart';

class CustomHomeTopPickEventsCard extends StatelessWidget {
  final EventModel eventModel;
  const CustomHomeTopPickEventsCard({super.key, required this.eventModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190.h,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image:
              eventModel.imageUrl != null && eventModel.imageUrl!.isNotEmpty
                  ? NetworkImage("${eventModel.imageUrl}")
                  : const AssetImage("$staticAssets/SplashScreenImage.png"),
          fit: BoxFit.cover,
        ),

        color: thinGreyColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        Text(
                          "${eventModel.joiningPeople}/${eventModel.capacity} Joined",
                          style: style14.copyWith(
                            fontSize: 13,
                            color: whiteColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4), // small space
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          // ✅ Expanded forces this child to use remaining width safely
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: whiteColor,
                                size: 16.h,
                              ),
                              2.horizontalSpace,
                              Flexible(
                                child: Text(
                                  eventModel.location ?? '',
                                  style: style14.copyWith(
                                    fontSize: 13,
                                    color: whiteColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
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
