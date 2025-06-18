import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/model/up_coming_evnts.dart';

class CustomUpComingEventsCard extends StatelessWidget {
  final UpComingEventsCardModel eventMOdel;
  const CustomUpComingEventsCard({super.key, required this.eventMOdel});

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
            width: 67,
            height: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(AppAssets().loginImage, fit: BoxFit.cover),
            ),
          ),
          3.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      eventMOdel.date,
                      style: style14B.copyWith(fontSize: 10),
                    ),
                    Text(
                      eventMOdel.ratio,
                      style: style14B.copyWith(
                        color: primaryColor,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                4.verticalSpace,
                Text(
                  eventMOdel.title,
                  style: style14B.copyWith(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                      child: Text(
                        eventMOdel.location,
                        style: style14B.copyWith(fontSize: 10),
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
