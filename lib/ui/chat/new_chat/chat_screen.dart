// lib/ui/chat_screen/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/ui/chat/new_chat/chat_view_model.dart';
import 'package:girl_clan/ui/chat/new_chat/message_bubble.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String chatTitle;
  final String chatImageUrl;
  final bool isGroupChat;

  const ChatScreen({
    Key? key,
    required this.chatTitle, // Now required
    required this.chatImageUrl, // Now required
    required this.isGroupChat, // Now required
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundImage: AssetImage(widget.chatImageUrl),
            ),
            10.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatTitle,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    5.horizontalSpace,
                    Text(
                      'Online', // Always show online for one-to-one, or "02 Online" for group
                      style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Handle more options
            },
          ),
        ],
      ),
      body: Consumer<ChatViewModel>(
        builder: (context, model, child) {
          _scrollToBottom();
          return Column(
            children: [
              10.verticalSpace,
              // Date Separator
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              10.verticalSpace,
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: model.messages.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                      message: model.messages[index],
                      showProfilePic:
                          widget.isGroupChat, // <-- THIS IS THE KEY!
                    );
                  },
                ),
              ),
              // Message Input Field
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: TextField(
                          controller: model.messageController,
                          decoration: InputDecoration(
                            hintText: 'Type your message ...',
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 12.h,
                            ),
                            // suffixIcon: Padding(
                            //   padding: EdgeInsets.only(right: 10.w),
                            //   child: Row(
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: [
                            //       Icon(Icons.mic_none, color: Colors.grey),
                            //       10.horizontalSpace,
                            //       Icon(
                            //         Icons.camera_alt_outlined,
                            //         color: Colors.grey,
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ),
                          onSubmitted: (value) => model.sendMessage(),
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                    GestureDetector(
                      onTap: () {
                        if (model.isTyping) {
                          model.sendMessage();
                        }
                      },
                      child: CircleAvatar(
                        radius: 25.r,

                        backgroundColor:
                            model.isTyping
                                ? primaryColor
                                : primaryColor.withOpacity(0.20),

                        child: Icon(Icons.send, color: whiteColor, size: 20.r),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
