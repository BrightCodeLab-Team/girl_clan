import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/custom_widget/new_chat.dart';
import 'package:girl_clan/ui/chat/new_chat/chat_screen.dart';
import 'package:girl_clan/ui/chat/new_chat/chat_view_model.dart';
import 'package:provider/provider.dart';

class MainChatScreen extends StatelessWidget {
  const MainChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // People & Groups
      child: Consumer<ChatViewModel>(
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
                          itemBuilder: (context, index) {
                            final user = model.chatsList[index];
                            return mainChatItem(
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
                                      chatTitle: user.name,
                                      chatImageUrl: user.imageUrl,
                                      isGroupChat: false,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        // Groups Tab
                        // Update your ListView.builder in the People tab:
                        ListView.builder(
                          itemCount: model.chatsList.length,
                          itemBuilder: (context, index) {
                            final user = model.chatsList[index];
                            return mainChatItem(
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
                                      chatTitle: user.name,
                                      chatImageUrl: user.imageUrl,
                                      isGroupChat: false,
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
