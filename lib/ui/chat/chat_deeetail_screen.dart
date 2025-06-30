// import 'package:flutter/material.dart';
// import 'package:girl_clan/core/constants/colors.dart';
// import 'package:girl_clan/ui/chat/chat_view_model.dart';
// import 'package:provider/provider.dart';

// class ChatDetailScreen extends StatefulWidget {
//   final String? otherUserId;
//   final String? groupId;

//   const ChatDetailScreen({super.key, this.otherUserId, this.groupId})
//     : assert(otherUserId != null || groupId != null);

//   @override
//   State<ChatDetailScreen> createState() => _ChatDetailScreenState();
// }

// class _ChatDetailScreenState extends State<ChatDetailScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     final viewModel = Provider.of<ChatViewModel>(context, listen: false);
//     viewModel.clearMessages();

//     if (widget.groupId != null) {
//       viewModel.loadMessages(groupId: widget.groupId);
//     } else if (widget.otherUserId != null) {
//       viewModel.loadMessages(otherUserId: widget.otherUserId);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<ChatViewModel>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.groupId != null
//               ? 'Group Chat'
//               : 'Chat with User ${widget.otherUserId?.substring(0, 6)}',
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               reverse: true,
//               itemCount: viewModel.messages.length,
//               itemBuilder: (context, index) {
//                 final message = viewModel.messages[index];
//                 final isMe = message.senderId == viewModel.currentUserId;

//                 return Align(
//                   alignment:
//                       isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(
//                       vertical: 4,
//                       horizontal: 8,
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 8,
//                       horizontal: 12,
//                     ),
//                     decoration: BoxDecoration(
//                       color: isMe ? primaryColor : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (widget.groupId != null && !isMe)
//                           Text(
//                             'User ${message.senderId.substring(0, 6)}',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: isMe ? Colors.white70 : Colors.black54,
//                             ),
//                           ),
//                         Text(
//                           message.message,
//                           style: TextStyle(
//                             color: isMe ? Colors.white : Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Type a message...',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send, color: primaryColor),
//                   onPressed: () {
//                     if (_messageController.text.isNotEmpty) {
//                       viewModel.sendMessage(
//                         otherUserId: widget.otherUserId,
//                         groupId: widget.groupId,
//                         message: _messageController.text,
//                       );
//                       _messageController.clear();
//                       _scrollController.animateTo(
//                         0,
//                         duration: const Duration(milliseconds: 300),
//                         curve: Curves.easeOut,
//                       );
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
