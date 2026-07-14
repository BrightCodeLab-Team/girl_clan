import 'package:flutter/material.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/model/message_model.dart';
import 'package:girl_clan/custom_widget/moderation/block_user_dialog.dart';
import 'package:girl_clan/custom_widget/moderation/report_content_sheet.dart';

/// Long-press menu: Reply, Report, Block (Guideline 1.2).
void showMessageModerationMenu(
  BuildContext context, {
  required MessageModel message,
  required bool isGroupChat,
  required VoidCallback onReply,
  VoidCallback? onBlocked,
  String? chatId,
}) {
  if (message.isMe) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (ctx) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.reply),
                  title: const Text('Reply'),
                  onTap: () {
                    Navigator.pop(ctx);
                    onReply();
                  },
                ),
              ],
            ),
          ),
    );
    return;
  }

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder:
        (ctx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.reply),
                title: const Text('Reply'),
                onTap: () {
                  Navigator.pop(ctx);
                  onReply();
                },
              ),
              ListTile(
                leading: Icon(Icons.flag_outlined, color: primaryColor),
                title: const Text('Report Message'),
                onTap: () {
                  Navigator.pop(ctx);
                  showReportContentSheet(
                    context,
                    contentType: 'message',
                    contentId: message.messageId,
                    reportedUserId: message.senderId,
                    messageId: message.messageId,
                    chatId: chatId,
                    title: 'Report Message',
                    blockUserId: message.senderId,
                    blockUserLabel: message.senderName,
                    hideOnReport: true,
                    onBlocked: onBlocked,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text('Block User'),
                onTap: () async {
                  Navigator.pop(ctx);
                  await confirmAndBlockUser(
                    context,
                    userId: message.senderId,
                    userLabel: message.senderName,
                    details: 'Blocked from chat message',
                    onBlocked: onBlocked,
                  );
                },
              ),
            ],
          ),
        ),
  );
}

void showUserModerationMenu(
  BuildContext context, {
  required String userId,
  required String userName,
  VoidCallback? onBlocked,
  VoidCallback? onDeleteChat,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder:
        (ctx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.flag_outlined, color: primaryColor),
                title: Text('Report $userName'),
                onTap: () {
                  Navigator.pop(ctx);
                  showReportContentSheet(
                    context,
                    contentType: 'user',
                    contentId: userId,
                    reportedUserId: userId,
                    title: 'Report User',
                    blockUserId: userId,
                    blockUserLabel: userName,
                    hideOnReport: true,
                    onBlocked: onBlocked,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text('Block User'),
                onTap: () async {
                  Navigator.pop(ctx);
                  await confirmAndBlockUser(
                    context,
                    userId: userId,
                    userLabel: userName,
                    details: 'Blocked from chat list',
                    onBlocked: onBlocked,
                  );
                },
              ),
              if (onDeleteChat != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text('Delete Chat'),
                  onTap: () {
                    Navigator.pop(ctx);
                    onDeleteChat();
                  },
                ),
            ],
          ),
        ),
  );
}
