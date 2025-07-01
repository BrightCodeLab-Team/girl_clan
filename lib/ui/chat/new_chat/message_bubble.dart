import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/model/new_user_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool showProfilePic; // Re-added this crucial property

  const MessageBubble({
    Key? key,
    required this.message,
    this.showProfilePic = true, // Default to true for group chat behavior
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.isTypingIndicator) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 8.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Only show profile pic for typing indicator if showProfilePic is true
                if (showProfilePic) ...[
                  CircleAvatar(
                    radius: 15.r,
                    backgroundImage: AssetImage(message.senderImageUrl),
                  ),
                  10.horizontalSpace,
                ],
                Text(
                  message.content,
                  style: TextStyle(fontSize: 16.sp, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // For regular messages
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment
                  .end, // Changed back to end for proper alignment
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile picture for incoming messages (left side)
            // Show only if not 'isMe' and showProfilePic is true
            if (!message.isMe && showProfilePic) ...[
              CircleAvatar(
                radius: 18.r,
                backgroundImage: AssetImage(message.senderImageUrl),
              ),
              10.horizontalSpace,
            ],
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: message.isMe ? primaryColor : Colors.grey.shade200,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(message.isMe ? 20.r : 0),
                    topRight: Radius.circular(message.isMe ? 0 : 20.r),
                    bottomLeft: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      message.isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                  children: [
                    // Sender name only for incoming messages AND if profile pic is NOT shown (one-to-one)
                    if (!message.isMe && !showProfilePic)
                      Text(
                        message.senderName,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    if (!message.isMe && !showProfilePic)
                      5.verticalSpace, // Add space if name is shown
                    Text(
                      message.content,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: message.isMe ? Colors.white : Colors.black,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      message.timestamp,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: message.isMe ? Colors.white70 : Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Profile picture for outgoing messages (right side)
            // Show only if 'isMe' and showProfilePic is true
            if (message.isMe && showProfilePic) ...[
              10.horizontalSpace,
              CircleAvatar(
                radius: 18.r,
                backgroundImage: AssetImage(message.senderImageUrl),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
