// ignore_for_file: prefer_initializing_formals

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/core/model/message_model.dart';
import 'package:girl_clan/core/model/user_model.dart';
import 'package:girl_clan/core/others/base_view_model.dart';
import 'package:girl_clan/core/services/data_base_services.dart';
import 'package:girl_clan/locator.dart';
import 'package:intl/intl.dart';

class ChatViewModel extends BaseViewModel {
  final DatabaseServices _db = locator<DatabaseServices>();
  bool isLoading = true;
  final String? chatTitle;
  final String? chatImageUrl;
  final bool? isGroupChat;
  final String? receiverId;

  final TextEditingController messageController = TextEditingController();
  final List<MessageModel> _messages = [];
  List<UserModel> chatsList = [];

  List<MessageModel> get messages => _messages;

  StreamSubscription? _messagesSubscription;

  ChatViewModel({
    this.chatTitle,
    this.chatImageUrl,
    this.isGroupChat,
    this.receiverId,
  }) {
    initMessagesStream();
    loadUsers();
  }

  /// Initializes Firestore message stream
  initMessagesStream() {
    _messagesSubscription = _db.getMessagesStream(receiverId ?? "").listen((
      snapshot,
    ) {
      _messages.clear();
      _messages.addAll(
        snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return _parseMessage(data);
        }),
      );
      notifyListeners();
    });
  }

  /// Converts Firestore document into a MessageModel
  MessageModel _parseMessage(Map<String, dynamic> data) {
    final isMe = data['senderId'] == _db.currentUserId;
    return MessageModel(
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      senderName: isMe ? 'You' : chatTitle ?? "",
      senderImageUrl:
          isMe ? 'assets/images/current_user_profile.png' : chatImageUrl ?? "",
      content: data['text'] ?? '',
      timestamp: _formatTimestamp(data['timestamp']),
      isMe: isMe,
    );
  }

  /// Formats Firebase timestamp to readable time
  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Just now';
    final date = (timestamp as Timestamp).toDate();
    return DateFormat('h:mm a').format(date);
  }

  /// Loads user list (optional usage for UI)
  /// Loads user list (optional usage for UI)
  Future<void> loadUsers() async {
    try {
      setState(ViewState.busy);
      isLoading = true;
      notifyListeners(); // Inform UI shimmer or loader

      chatsList = await _db.getAllChatUsers();
      debugPrint("Loaded chat users: ${chatsList.length}");

      for (var user in chatsList) {
        debugPrint("User: ${user.name}, ${user.imageUrl}");
      }
    } catch (e) {
      debugPrint('Error loading users: $e');
    } finally {
      isLoading = false;
      notifyListeners(); // Final UI update
      setState(ViewState.idle);
    }
  }

  /// Sends a message
  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || receiverId == null || receiverId!.isEmpty) {
      debugPrint('Cannot send message. Text or receiverId is invalid.');
      return;
    }

    try {
      await _db.sendMessage(receiverId: receiverId!, text: text);
      messageController.clear();
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    messageController.dispose();
    super.dispose();
  }
}
