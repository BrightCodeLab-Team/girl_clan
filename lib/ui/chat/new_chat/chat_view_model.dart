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
  final String? groupId;
  List<Map<String, dynamic>> groupsList = [];

  final TextEditingController messageController = TextEditingController();
  bool isTyping = false;

  final List<MessageModel> _messages = [];
  List<UserModel> chatsList = [];

  List<MessageModel> get messages => _messages;

  StreamSubscription? _messagesSubscription;

  ChatViewModel({
    this.chatTitle,
    this.chatImageUrl,
    this.isGroupChat,
    this.receiverId,
    this.groupId,
  }) {
    initMessagesStream();
    loadUsers();
    loadGroups();
    messageController.addListener(_onTyping);
  }

  void _onTyping() {
    final hasText = messageController.text.trim().isNotEmpty;
    if (hasText != isTyping) {
      isTyping = hasText;
      notifyListeners();
    }
  }

  /// Initializes Firestore message stream
  // initMessagesStream() {
  //   _messagesSubscription = _db.getMessagesStream(receiverId ?? "").listen((
  //     snapshot,
  //   ) {
  //     _messages.clear();
  //     _messages.addAll(
  //       snapshot.docs.map((doc) {
  //         final data = doc.data() as Map<String, dynamic>;
  //         return _parseMessage(data);
  //       }),
  //     );
  //     messageController.addListener(() {
  //       notifyListeners(); // tell UI to update send button
  //     });
  //     notifyListeners();
  //   });
  // }

  initMessagesStream() {
    if (isGroupChat == true && groupId != null) {
      // group chat stream
      _messagesSubscription = _db.getGroupMessagesStream(groupId!).listen((
        snapshot,
      ) {
        _messages.clear();
        _messages.addAll(
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return _parseGroupMessage(data);
          }),
        );
        notifyListeners();
      });
    } else if (receiverId != null) {
      // personal chat stream
      _messagesSubscription = _db.getMessagesStream(receiverId!).listen((
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
  }

  MessageModel _parseGroupMessage(Map<String, dynamic> data) {
    final isMe = data['senderId'] == _db.currentUserId;
    return MessageModel(
      senderId: data['senderId'],
      receiverId: groupId ?? "",
      senderName: isMe ? 'You' : (data['senderName'] ?? chatTitle ?? ""),
      senderImageUrl:
          isMe
              ? 'assets/images/current_user_profile.png'
              : (chatImageUrl ?? ""),
      content: data['text'] ?? '',
      timestamp: _formatTimestamp(data['timestamp']),
      isMe: isMe,
    );
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

  Future<void> loadGroups() async {
    try {
      setState(ViewState.busy);
      isLoading = true;
      notifyListeners();

      groupsList = await _db.getUserGroups();
      debugPrint("Loaded groups: ${groupsList.length}");
    } catch (e) {
      debugPrint('Error loading groups: $e');
    } finally {
      isLoading = false;
      notifyListeners();
      setState(ViewState.idle);
    }
  }

  /// Sends a message
  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    try {
      final localMessage = MessageModel(
        senderId: _db.currentUserId!,
        receiverId: isGroupChat == true ? (groupId ?? '') : (receiverId ?? ''),
        senderName: 'You',
        senderImageUrl: 'assets/images/current_user_profile.png',
        content: text,
        timestamp: DateFormat('h:mm a').format(DateTime.now()),
        isMe: true,
      );

      _messages.add(localMessage);
      notifyListeners();

      messageController.clear();
      isTyping = false;
      notifyListeners();

      if (isGroupChat == true && groupId != null) {
        await _db.sendGroupMessage(groupId: groupId!, text: text);
      } else if (receiverId != null) {
        await _db.sendMessage(receiverId: receiverId!, text: text);
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    _messagesSubscription?.cancel();
    super.dispose();
  }
}
