import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/app_assest.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';

class EventsDetailsScreen extends StatelessWidget {
  const EventsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 275.h,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(AppAssets().detailImage, fit: BoxFit.cover),
              ),
            ),
            10.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text('Vibe Elevation', style: style18B.copyWith()),
                      Spacer(),
                      Row(
                        children: [
                          Text(
                            '06/24',
                            style: style14B.copyWith(color: primaryColor),
                          ),
                          1.horizontalSpace,
                          5.verticalSpace,
                          Text(
                            'Available',
                            style: style14B.copyWith(fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  Row(
                    children: [
                      Text(
                        '03/23/2025',
                        style: style14.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      1.horizontalSpace,
                      Container(height: 10.h, width: 0.5.w, color: blackColor),
                      1.horizontalSpace,
                      Text(
                        '09:00 PM',
                        style: style14.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 27.h,
                        width: 72,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Center(
                          child: Text(
                            'Party',
                            style: style14B.copyWith(color: whiteColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,

                  ///
                  ///  location
                  ///
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_outlined, size: 15.h),
                      1.horizontalSpace,
                      Text(
                        'Waterton Lakes National Park, Alberta',
                        style: style14.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                  20.verticalSpacingRadius,
                  Text('About Event', style: style16B.copyWith()),
                  10.verticalSpace,
                  Text(
                    'Step into a world of style, sound, and celebration.Dress the part, live the moment.',
                    style: style14.copyWith(fontSize: 13),
                  ),
                  20.verticalSpace,
                  Text('Location', style: style16B.copyWith()),
                  10.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
