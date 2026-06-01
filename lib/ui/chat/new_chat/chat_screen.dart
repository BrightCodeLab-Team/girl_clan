// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/utils/app_messenger.dart';
import 'package:girl_clan/custom_widget/moderation/report_content_sheet.dart';
import 'package:girl_clan/ui/chat/new_chat/chat_view_model.dart';
import 'package:girl_clan/ui/chat/new_chat/message_bubble.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String chatTitle;
  final String chatImageUrl;
  final bool isGroupChat;

  const ChatScreen({
    Key? key,
    required this.chatTitle,
    required this.chatImageUrl,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  late ChatViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<ChatViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundImage: NetworkImage(widget.chatImageUrl),
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatTitle,
                    style: style16B,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      5.horizontalSpace,
                      Text(
                        widget.isGroupChat ? 'Group' : 'Online',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Consumer<ChatViewModel>(
            builder: (context, model, _) {
              return PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.black),
                onSelected: (value) async {
                  if (value == 'report') {
                    final contentId =
                        widget.isGroupChat
                            ? (model.groupId ?? widget.chatTitle)
                            : (model.receiverId ?? '');
                    showReportContentSheet(
                      context,
                      contentType:
                          widget.isGroupChat ? 'group_chat' : 'message',
                      contentId: contentId,
                      reportedUserId:
                          widget.isGroupChat ? null : model.receiverId,
                      title:
                          widget.isGroupChat
                              ? 'Report Group Chat'
                              : 'Report User',
                      blockUserId:
                          widget.isGroupChat ? null : model.receiverId,
                      blockUserLabel: widget.chatTitle,
                      onBlocked: () => Get.back(),
                    );
                  }
                },
                itemBuilder:
                    (_) => [
                      const PopupMenuItem(
                        value: 'report',
                        child: Text('Report'),
                      ),
                    ],
              );
            },
          ),
        ],
      ),
      body: Consumer<ChatViewModel>(
        builder: (context, model, child) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _scrollToBottom(),
          );

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
                      key: ValueKey(model.messages[index].timestamp),
                      message: model.messages[index],
                      showProfilePic: widget.isGroupChat,
                    );
                  },
                ),
              ),
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
                            hintText: 'Type your message...',
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 12.h,
                            ),
                          ),
                          onChanged: (text) {
                            model.isTyping = text.trim().isNotEmpty;
                          },
                          onSubmitted: (value) async {
                            final err = await model.sendMessage();
                            if (err != null && context.mounted) {
                              AppMessenger.show(context, err, isError: true);
                            }
                          },
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                    GestureDetector(
                      onTap:
                          model.isTyping
                              ? () async {
                                final err = await model.sendMessage();
                                if (err != null && context.mounted) {
                                  AppMessenger.show(context, err, isError: true);
                                }
                              }
                              : null,
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
