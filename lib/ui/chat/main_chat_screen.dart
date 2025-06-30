// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/route_manager.dart';
// import 'package:girl_clan/core/constants/app_assets.dart';
// import 'package:girl_clan/core/constants/auth_text_feild.dart';
// import 'package:girl_clan/core/constants/colors.dart';
// import 'package:girl_clan/core/constants/text_style.dart';
// import 'package:girl_clan/ui/chat/chat_deeetail_screen.dart';
// import 'package:girl_clan/ui/chat/chat_view_model.dart';
// import 'package:girl_clan/ui/chat/creat_group_screen.dart';
// import 'package:girl_clan/ui/chat/user_search_screen.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class MainChatScreen extends StatefulWidget {
//   const MainChatScreen({super.key});

//   @override
//   State<MainChatScreen> createState() => _MainChatScreenState();
// }

// class _MainChatScreenState extends State<MainChatScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   bool _showSearch = false;

//   @override
//   void initState() {
//     super.initState();
//     final viewModel = Provider.of<ChatViewModel>(context, listen: false);
//     viewModel.loadConversations();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           automaticallyImplyLeading: false,
//           elevation: 0,
//           title:
//           // _showSearch
//           //     ? TextField(
//           //       controller: _searchController,
//           //       autofocus: true,
//           //       decoration: const InputDecoration(
//           //         hintText: 'Search users...',
//           //         border: InputBorder.none,
//           //       ),
//           //       onChanged: (value) {
//           //         if (value.isNotEmpty) {
//           //           Navigator.push(
//           //             context,
//           //             MaterialPageRoute(
//           //               builder:
//           //                   (context) =>
//           //                       UserSearchScreen(searchQuery: value),
//           //             ),
//           //           );
//           //           _searchController.clear();
//           //           setState(() => _showSearch = false);
//           //         }
//           //       },
//           //     )
//           //     :
//           Padding(
//             padding: const EdgeInsets.only(left: 4.0),
//             child: Text(
//               'Messages',
//               style: TextStyle(
//                 fontSize: 30,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           // actions: [
//           //   IconButton(
//           //     icon: Icon(_showSearch ? Icons.close : Icons.search),
//           //     onPressed: () {
//           //       setState(() => _showSearch = !_showSearch);
//           //       if (!_showSearch) _searchController.clear();
//           //     },
//           //   ),
//           // ],
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(100),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                 child: Column(
//                   children: [
//                     TabBar(
//                       indicatorSize: TabBarIndicatorSize.tab,
//                       isScrollable: false,
//                       labelColor: primaryColor,
//                       unselectedLabelColor: Colors.black54,
//                       indicatorColor: primaryColor,
//                       labelStyle: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                       ),
//                       tabs: const [Tab(text: 'People'), Tab(text: 'Groups')],
//                     ),
//                     10.verticalSpace,

//                     ///
//                     ///
//                     ///
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 15),
//                       child: TextFormField(
//                         controller: _searchController,
//                         autofocus: true,
//                         decoration: customHomeAuthField.copyWith(
//                           prefixIcon: Icon(Icons.search),
//                         ),
//                         onChanged: (value) {
//                           if (value.isNotEmpty) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder:
//                                     (context) =>
//                                         UserSearchScreen(searchQuery: value),
//                               ),
//                             );
//                             _searchController.clear();
//                             setState(() => _showSearch = false);
//                           }
//                         },
//                         onFieldSubmitted: (value) {
//                           setState(() => _showSearch = !_showSearch);
//                           if (!_showSearch) _searchController.clear();
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),

//         body: TabBarView(
//           children: [
//             _buildConversationsList(isGroup: false),
//             _buildConversationsList(isGroup: true),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildConversationsList({required bool isGroup}) {
//     return Consumer<ChatViewModel>(
//       builder: (context, viewModel, child) {
//         if (viewModel.isLoading && viewModel.conversations.isEmpty) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final conversations =
//             viewModel.conversations.where((c) => c.isGroup == isGroup).toList();

//         if (conversations.isEmpty) {
//           return Center(
//             child: Text(
//               isGroup ? 'No group chats yet' : 'No conversations yet',
//               style: style16.copyWith(color: Colors.grey),
//             ),
//           );
//         }

//         return ListView.builder(
//           itemCount: conversations.length,
//           itemBuilder: (context, index) {
//             final conversation = conversations[index];
//             return ChatItem(
//               imageUrl: AppAssets().appLogo,
//               name:
//                   conversation.isGroup
//                       ? (conversation.groupName ?? 'Group Chat')
//                       : 'User ${conversation.otherUserId?.substring(0, 6) ?? ''}',
//               message: conversation.lastMessage.message,
//               time: DateFormat(
//                 'hh:mm a',
//               ).format(conversation.lastMessage.timestamp),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder:
//                         (context) => ChatDetailScreen(
//                           otherUserId:
//                               conversation.isGroup
//                                   ? null
//                                   : conversation.otherUserId,
//                           groupId:
//                               conversation.isGroup ? conversation.id : null,
//                         ),
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }

// class ChatItem extends StatelessWidget {
//   final String imageUrl;
//   final String name;
//   final String message;
//   final String time;
//   final VoidCallback? onTap;

//   const ChatItem({
//     super.key,
//     required this.imageUrl,
//     required this.name,
//     required this.message,
//     required this.time,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         child: ListTile(
//           leading: CircleAvatar(
//             radius: 24,
//             backgroundImage: AssetImage(imageUrl),
//           ),
//           title: Text(name, style: style14B),
//           subtitle: Text(
//             message,
//             style: style12.copyWith(color: blackColor.withOpacity(0.4)),
//           ),
//           trailing: Text(time, style: style12.copyWith()),
//         ),
//       ),
//     );
//   }
// }
