import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/app_assest.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/main.dart';
import 'package:girl_clan/ui/home/home_view_model.dart';
import 'package:latlong2/latlong.dart';
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
                leading: CircleAvatar(
                  radius: 25.r,
                  child: Image.asset(AppAssets().appLogo, fit: BoxFit.cover),
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
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: thinGreyColor,
                    child: Icon(Icons.notifications),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    10.verticalSpace,
                    TextFormField(decoration: customHomeAuthField),
                    20.verticalSpace,
                    Row(
                      children: [
                        Text('Upcoming Events', style: style14B),
                        Spacer(),
                        TextButton(
                          onPressed: () {},
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

                    SizedBox(
                      height: 88.h,
                      child: ListView.builder(
                        itemCount: 4,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 5.w),
                            child: CustomUpComingEventsCard(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}

class CustomUpComingEventsCard extends StatelessWidget {
  const CustomUpComingEventsCard({super.key});

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
                    Text('12/08/2024', style: style14B.copyWith(fontSize: 10)),
                    Text(
                      '06/10',
                      style: style14B.copyWith(
                        color: primaryColor,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                4.verticalSpace,
                Text(
                  'Wanderlight Festival',
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
                        'Tofino, British Co ...',
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

class UpComingEventsCardModel {
  final String imageUrl;
  final String date;
  final String title;
  final String location;
  final String ratio;
  UpComingEventsCardModel({
    required this.date,
    required this.imageUrl,
    required this.location,
    required this.ratio,
    required this.title,
  });
}
