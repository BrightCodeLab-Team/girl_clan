// Dummy Chat Item Widget (for simplicity)
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/model/user_model.dart';

class mainChatItem extends StatefulWidget {
  // final String imageUrl;
  // final String name;
  // final String message;
  // final String time;
  final UserModel chat;
  final VoidCallback onTap;

  const mainChatItem({
    super.key,
    required this.chat,
    required this.onTap,
    // required this.imageUrl,
    // required this.name,
    // required this.message,
    // required this.time,
  });

  @override
  State<mainChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<mainChatItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        onTap: widget.onTap,
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage(widget.chat.imageUrl),
        ),
        title: Text(widget.chat.name, style: style14B),
        subtitle: Text(
          widget.chat.message,
          style: style12.copyWith(color: blackColor.withOpacity(0.4)),
        ),

        trailing: Text(widget.chat.time, style: style12.copyWith()),
      ),
    );
  }
}
