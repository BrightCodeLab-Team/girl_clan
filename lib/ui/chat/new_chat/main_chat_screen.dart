import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/custom_widget/new_chat.dart';
import 'package:girl_clan/ui/chat/new_chat/chat_detail_screen.dart';
import 'package:girl_clan/ui/chat/new_chat/chat_view_model.dart';
import 'package:provider/provider.dart';

class NewMainChatScreen extends StatelessWidget {
  const NewMainChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // People & Groups
      child: Consumer<NewChatViewModel>(
        builder:
            (context, model, child) => Scaffold(
              appBar: AppBar(
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
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        tabs: const [Tab(text: 'People'), Tab(text: 'Groups')],
                      ),
                    ),
                  ),
                ),
              ),
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
                        // People Tab
                        ListView.builder(
                          itemCount: model.chatsList.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            final chatItem =
                                model
                                    .chatsList[index]; // Get the specific chat item
                            return mainChatItem(
                              chat: chatItem,
                              onTap: () {
                                // Navigate to ChatScreen for one-to-one chat
                                Get.to(
                                  ChangeNotifierProvider(
                                    // Provide ChatScreenViewModel specific to THIS one-to-one chat
                                    create:
                                        (ctx) => NewChatViewModel(
                                          chatTitle: chatItem.name,
                                          chatImageUrl: chatItem.imageUrl,
                                          isGroupChat:
                                              false, // It's a person/one-to-one
                                        ),
                                    child: ChatScreen(
                                      chatTitle: chatItem.name,
                                      chatImageUrl: chatItem.imageUrl,
                                      isGroupChat:
                                          false, // Pass arguments to ChatScreen's constructor
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        // Groups Tab
                        ListView.builder(
                          itemCount: model.groupsList.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            final groupItem =
                                model
                                    .groupsList[index]; // Get the specific group item
                            return mainChatItem(
                              chat: groupItem,
                              onTap: () {
                                // Navigate to ChatScreen for group chat
                                Get.to(
                                  ChangeNotifierProvider(
                                    // Provide ChatScreenViewModel specific to THIS group chat
                                    create:
                                        (ctx) => NewChatViewModel(
                                          chatTitle: groupItem.name,
                                          chatImageUrl: groupItem.imageUrl,
                                          isGroupChat: true, // It's a group
                                        ),
                                    child: ChatScreen(
                                      chatTitle: groupItem.name,
                                      chatImageUrl: groupItem.imageUrl,
                                      isGroupChat:
                                          true, // Pass arguments to ChatScreen's constructor
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
