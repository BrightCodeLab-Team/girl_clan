// import 'package:flutter/material.dart';
// import 'package:girl_clan/core/constants/app_assets.dart';
// import 'package:girl_clan/core/constants/auth_text_feild.dart';
// import 'package:girl_clan/core/constants/colors.dart';
// import 'package:girl_clan/core/constants/text_style.dart';
// import 'package:girl_clan/ui/chat/chat_deeetail_screen.dart';
// import 'package:girl_clan/ui/chat/chat_view_model.dart';
// import 'package:provider/provider.dart';

// class UserSearchScreen extends StatefulWidget {
//   final String searchQuery;

//   const UserSearchScreen({super.key, required this.searchQuery});

//   @override
//   State<UserSearchScreen> createState() => _UserSearchScreenState();
// }

// class _UserSearchScreenState extends State<UserSearchScreen> {
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _searchController.text = widget.searchQuery;
//     if (widget.searchQuery.isNotEmpty) {
//       final viewModel = Provider.of<ChatViewModel>(context, listen: false);
//       viewModel.searchUsers(widget.searchQuery);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<ChatViewModel>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: TextField(
//           controller: _searchController,
//           autofocus: true,
//           decoration: customHomeAuthField.copyWith(),
//           onChanged: (value) {
//             if (value.isNotEmpty) {
//               viewModel.searchUsers(value);
//             } else {
//               viewModel.searchResults; // This is correct
//             }
//           },
//         ),
//       ),
//       body:
//           viewModel.searchResults.isEmpty
//               ? Center(
//                 child: Text(
//                   widget.searchQuery.isEmpty
//                       ? 'Start typing to search users'
//                       : 'No users found',
//                   style: style16.copyWith(color: Colors.grey),
//                 ),
//               )
//               : ListView.builder(
//                 itemCount: viewModel.searchResults.length,
//                 itemBuilder: (context, index) {
//                   final user = viewModel.searchResults[index];
//                   return ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage:
//                           user['photoUrl'] != null
//                               ? NetworkImage(user['photoUrl'] as String)
//                               : AssetImage(AppAssets().appLogo)
//                                   as ImageProvider,
//                     ),
//                     title: Text(user['username'] as String, style: style14B),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder:
//                               (context) => ChatDetailScreen(
//                                 otherUserId: user['id'] as String,
//                               ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//     );
//   }
// }
