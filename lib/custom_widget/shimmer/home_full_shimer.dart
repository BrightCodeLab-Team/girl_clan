import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/custom_widget/shimmer/all_events_shimmer.dart';
import 'package:girl_clan/custom_widget/shimmer/up_coming_events.dart';
import 'package:shimmer/shimmer.dart';

class HomeFullScreenShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      children: [
        10.verticalSpace,
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(height: 40.h, width: double.infinity, color: Colors.white),
        ),
        20.verticalSpace,
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(height: 20.h, width: 150.w, color: Colors.white),
        ),
        10.verticalSpace,
        UpcomingEventsShimmer(),
        20.verticalSpace,
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(height: 20.h, width: 150.w, color: Colors.white),
        ),
        10.verticalSpace,
        TopPicksShimmer(),
      ],
    );
  }
}
