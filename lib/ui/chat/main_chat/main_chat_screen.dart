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
                                child: ListView.builder(
                                  itemCount: model.chatsList.length,
                                  itemBuilder: (context, index) {
                                    final user = model.chatsList[index];
                                    return MainChatItem(
                                      chat: user,
                                      onTap: () {
                                        Get.to(
                                          ChangeNotifierProvider(
                                            create:
                                                (ctx) => ChatViewModel(
                                                  chatTitle: user.name,
                                                  chatImageUrl: user.imageUrl,
                                                  receiverId: user.id!,
                                                  isGroupChat:
                                                      false, // Now passing the actual user ID
                                                ),
                                            child: ChatScreen(
                                              chatTitle: user.name ?? "",
                                              chatImageUrl: user.imageUrl ?? "",
                                              isGroupChat: false,
                                            ),
                                          ),
                                        );
                                        print("user name: ${user.name}");

                                        print("user name. ${user.id}");
                                      },
                                    );
                                  },
                                ),
                              ),
                          // Groups Tab
                          // Update your ListView.builder in the People tab:
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
                                    return MainChatItem(
                                      chat: UserModel(
                                        id: group['id'],
                                        name: group['name'],
                                        imageUrl: group['imageUrl'],
                                        message: group['lastMessage'] ?? "",
                                        time:
                                            (group['lastMessageTime']
                                                    as Timestamp?)
                                                ?.toDate(),

                                        // Optionally add message and time if you want
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
