import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/strings.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/model/groups_model.dart';

class CustomGroupsCards extends StatelessWidget {
  //final UpComingEventsCardModel groupsModal;
  final GroupsModel groupsModal;
  const CustomGroupsCards({required this.groupsModal});

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
                    (groupsModal.imageUrl != null &&
                            groupsModal.imageUrl!.isNotEmpty)
                        ? NetworkImage(groupsModal.imageUrl!)
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  groupsModal.title ?? '',
                  style: style16B,
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
                      // or Flexible
                      child: Text(
                        groupsModal.location ?? '',
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
