import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/strings.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/model/event_model.dart';

class CustomUpComingEventsCard extends StatelessWidget {
  //final UpComingEventsCardModel eventMOdel;
  final EventModel eventModel;
  const CustomUpComingEventsCard({super.key, required this.eventModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.8,
      height: 85.h,
      decoration: BoxDecoration(
        color: thinGreyColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image:
                    (eventModel.imageUrl != null &&
                            eventModel.imageUrl!.isNotEmpty)
                        ? NetworkImage(eventModel.imageUrl!)
                        : const AssetImage(
                          "$staticAssets/SplashScreenImage.png",
                        ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          7.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      eventModel.eventName ?? '',
                      style: style16B,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${eventModel.availablePeople}/${eventModel.joiningPeople}",
                      style: style14B.copyWith(
                        color: primaryColor,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                4.verticalSpace,

                Text(
                  eventModel.date ?? '',
                  style: style14B.copyWith(fontSize: 10),
                ),
                4.verticalSpace,

                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.grey.shade600,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      // or Flexible
                      child: Text(
                        eventModel.location ?? '',
                        style: style14B.copyWith(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
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
