// ignore_for_file: use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/model/user_model.dart';
import 'package:girl_clan/custom_widget/new_chat.dart';
import 'package:girl_clan/custom_widget/shimmer/chat_shimmer.dart';
import 'package:girl_clan/ui/chat/new_chat/chat_screen.dart';
import 'package:girl_clan/ui/chat/new_chat/chat_view_model.dart';
import 'package:provider/provider.dart';

class MainChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // People & Groups
      child: Consumer<ChatViewModel>(
        builder:
            (context, model, child) => RefreshIndicator(
              onRefresh: () async {
                await model.loadUsers();
                await model.loadGroups();
                await model.initMessagesStream();
              },
              child: Scaffold(
                ///
                /// App Bar
                ///
                appBar: _appBar(),

                ///
                /// Start Body
                ///
                body: Column(
                  children: [
                    10.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        decoration: customHomeAuthField.copyWith(
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    15.verticalSpace,
                    // Tab Views
                    Expanded(
                      child: TabBarView(
                        children: [
                          model.isLoading
                              ? const ChatShimmerLoader()
                              : // People Tab
                              RefreshIndicator(
                                onRefresh: () async {
                                  model.loadUsers();
                                  model.initMessagesStream();
                                },
                                child: Consumer<ChatViewModel>(
                                  builder: (context, model, child) {
                                    return ListView.builder(
                                      itemCount: model.chatsList.length,
                                      itemBuilder: (context, index) {
                                        final user = model.chatsList[index];
                                        return MainChatItem(
                                          chat: user,
                                          onLongPress: () {
                                            _showDeleteDialog(
                                              context: context,
                                              model: model,
                                              chatId: user.id!,
                                              isGroup: false,
                                            );
                                          },
                                          onTap: () {
                                            Get.to(
                                              ChangeNotifierProvider(
                                                create:
                                                    (ctx) => ChatViewModel(
                                                      chatTitle: user.name,
                                                      chatImageUrl:
                                                          user.imageUrl,
                                                      receiverId: user.id!,
                                                      isGroupChat: false,
                                                    ),
                                                child: ChatScreen(
                                                  chatTitle: user.name ?? "",
                                                  chatImageUrl:
                                                      user.imageUrl ?? "",
                                                  isGroupChat: false,
                                                ),
                                              ),
                                            );
                                            print("user name: ${user.name}");
                                            print("user name. ${user.id}");
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                          // Groups Tab
                          model.isLoading
                              ? const ChatShimmerLoader()
                              : RefreshIndicator(
                                onRefresh: () async {
                                  await model.loadGroups();
                                  model.initMessagesStream();
                                },
                                child: ListView.builder(
                                  itemCount: model.groupsList.length,
                                  itemBuilder: (context, index) {
                                    final group = model.groupsList[index];

                                    // Get last message info
                                    final lastMessage =
                                        group['lastMessage']?.toString() ??
                                        "No messages yet";
                                    final senderName =
                                        group['lastMessageSenderName']
                                            ?.toString() ??
                                        "";
                                    final lastMessageTime =
                                        (group['lastMessageTime'] as Timestamp?)
                                            ?.toDate();

                                    // Format the message preview
                                    String messagePreview;
                                    if (senderName.isNotEmpty) {
                                      messagePreview =
                                          '$senderName: $lastMessage';
                                    } else {
                                      messagePreview = lastMessage;
                                    }

                                    return MainChatItem(
                                      chat: UserModel(
                                        id: group['id'],
                                        name: group['name'],
                                        imageUrl: group['imageUrl'],
                                        message: messagePreview,
                                        time: lastMessageTime,
                                      ),
                                      onTap: () {
                                        Get.to(
                                          ChangeNotifierProvider(
                                            create:
                                                (ctx) => ChatViewModel(
                                                  chatTitle: group['name'],
                                                  chatImageUrl:
                                                      group['imageUrl'],
                                                  isGroupChat: true,
                                                  groupId: group['id'],
                                                ),
                                            child: ChatScreen(
                                              chatTitle: group['name'],
                                              chatImageUrl: group['imageUrl'],
                                              isGroupChat: true,
                                            ),
                                          ),
                                        );
                                        print("Group name: ${group['name']}");
                                        print("Group id: ${group['id']}");
                                      },
                                      onLongPress: () {
                                        _showDeleteDialog(
                                          context: context,
                                          model: model,
                                          chatId: group['id'],
                                          isGroup: true,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  // Moved inside the MainChatScreen class
  void _showDeleteDialog({
    required BuildContext context,
    required ChatViewModel model,
    required String chatId,
    required bool isGroup,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Chat'),
            content: Text('Are you sure you want to delete this chat?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  print("both working");
                  Navigator.pop(context);
                  if (isGroup) {
                    await model.deleteGroupChat(chatId);
                    print("working deleteGroupChat");
                  } else {
                    print("working deleteIndividualChat");
                    await model.deleteIndividualChat(chatId);
                  }
                },
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}

///
/// App Bar
///
_appBar() {
  return AppBar(
    backgroundColor: Colors.white,
    automaticallyImplyLeading: false,
    elevation: 0,
    title: Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        'Messages',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ),
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            isScrollable: false,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.black54,
            indicatorColor: primaryColor,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            tabs: const [Tab(text: 'People'), Tab(text: 'Groups')],
          ),
        ),
      ),
    ),
  );
}
