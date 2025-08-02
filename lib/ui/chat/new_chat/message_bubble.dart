import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/model/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool showProfilePic;

  const MessageBubble({
    Key? key,
    required this.message,
    this.showProfilePic = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.isTypingIndicator) {
      return _buildTypingIndicator();
    }
    return _buildMessageBubble();
  }

  Widget _buildTypingIndicator() {
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
              if (showProfilePic) ...[
                CircleAvatar(
                  radius: 15.r,
                  backgroundImage: NetworkImage(message.senderImageUrl),
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

  Widget _buildMessageBubble() {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!message.isMe && showProfilePic) _buildSenderAvatar(),
            _buildMessageContent(),
            if (message.isMe && showProfilePic) _buildUserAvatar(),
          ],
        ),
      ),
    );
  }

  Widget _buildSenderAvatar() {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: Column(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundImage: NetworkImage(message.senderImageUrl),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: Column(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundImage: NetworkImage(message.senderImageUrl),
          ),
          5.verticalSpace,
          const Text(
            'You',
            style: TextStyle(fontSize: 10, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    return Flexible(
      child: Column(
        crossAxisAlignment:
            message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (showProfilePic && !message.isMe)
            Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Text(
                message.senderName,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: message.isMe ? primaryColor : Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(message.isMe ? 20.r : 0),
                topRight: Radius.circular(message.isMe ? 0 : 20.r),
                bottomLeft: const Radius.circular(20),
                bottomRight: const Radius.circular(20),
              ),
            ),
            child: Text(
              message.content,
              style: TextStyle(
                fontSize: 16.sp,
                color: message.isMe ? Colors.white : Colors.black,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              message.timestamp,
              style: TextStyle(fontSize: 10.sp, color: Colors.black45),
            ),
          ),
        ],
      ),
    );
  }
}
