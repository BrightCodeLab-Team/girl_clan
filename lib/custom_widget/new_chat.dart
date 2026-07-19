// Dummy Chat Item Widget (for simplicity)
// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/strings.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/model/user_model.dart';
import 'package:intl/intl.dart';

class MainChatItem extends StatelessWidget {
  final UserModel chat;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  MainChatItem({
    required this.chat,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final hasUnread = chat.unreadCount > 0;
    final unreadLabel =
        chat.unreadCount > 99 ? '99+' : '${chat.unreadCount}';

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage:
                  (chat.imageUrl != null && chat.imageUrl!.isNotEmpty)
                      ? NetworkImage(chat.imageUrl!)
                      : const AssetImage('$staticAssets/logo.png'),
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name ?? '',
                    style: style14B.copyWith(
                      fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  2.verticalSpace,
                  Text(
                    chat.message ?? '',
                    style: style12.copyWith(
                      color: hasUnread
                          ? blackColor.withOpacity(0.75)
                          : blackColor.withOpacity(0.4),
                      fontWeight:
                          hasUnread ? FontWeight.w600 : FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            8.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chat.time != null
                      ? DateFormat('h:mm a').format(chat.time!)
                      : '',
                  style: style12.copyWith(
                    color: hasUnread ? primaryColor : blackColor,
                    fontWeight:
                        hasUnread ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                if (hasUnread) ...[
                  6.verticalSpace,
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: chat.unreadCount > 9 ? 6 : 5,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      unreadLabel,
                      style: style12.copyWith(
                        color: whiteColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
