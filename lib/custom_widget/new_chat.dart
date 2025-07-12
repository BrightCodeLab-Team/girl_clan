// Dummy Chat Item Widget (for simplicity)
// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/model/user_model.dart';
import 'package:intl/intl.dart';

class MainChatItem extends StatelessWidget {
  final UserModel chat;
  final VoidCallback onTap;

  MainChatItem({required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(chat.imageUrl ?? ""),
                ),
                10.horizontalSpace,
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(chat.name ?? "", style: style14B),
                    Text(
                      chat.message ?? "",
                      style: style12.copyWith(
                        color: blackColor.withOpacity(0.4),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),

            Text(
              chat.time != null ? DateFormat('h:mm a').format(chat.time!) : '',
              style: style12.copyWith(),
            ),
          ],
        ),
      ),
    );
  }
}
