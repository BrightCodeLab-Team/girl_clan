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

  String _getLastMessagePreview(Map<String, dynamic> group) {
    final lastMessage = group['lastMessage'];
    final senderName = group['lastMessageSenderName'] ?? '';

    if (lastMessage == null || lastMessage.isEmpty) {
      return 'No messages yet';
    }

    // For groups, show "Sender: Message" format
    return senderName.isNotEmpty ? '$senderName: $lastMessage' : lastMessage;
  }

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

  // Update _parseGroupMessage to ensure proper name handling
  MessageModel _parseGroupMessage(Map<String, dynamic> data) {
    final isMe = data['senderId'] == _db.currentUserId;
    return MessageModel(
      senderId: data['senderId'],
      receiverId: groupId ?? "",
      senderName: isMe ? 'You' : (data['senderName'] ?? 'Unknown User'),
      senderImageUrl: data['senderImageUrl'] ?? '',
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
      senderImageUrl: isMe ? '' : chatImageUrl ?? "",
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

      // Debug print to verify last messages are being loaded
      for (var group in groupsList) {
        print('Group: ${group['name']}');
        print('Last message: ${group['lastMessage']}');
        print('Last message time: ${group['lastMessageTime']}');
      }
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
      // Get current user data first
      final currentUser = await _db.getCurrentUserData();
      final currentUserName = currentUser['firstName'] ?? 'You';
      final currentUserImageUrl = currentUser['imgUrl'] ?? '';

      // Create local message with actual user data
      final localMessage = MessageModel(
        senderId: _db.currentUserId,
        receiverId: isGroupChat == true ? (groupId ?? '') : (receiverId ?? ''),
        senderName: currentUserName,
        senderImageUrl: currentUserImageUrl,
        content: text,
        timestamp: _formatTimestamp(Timestamp.now()),
        isMe: true,
      );

      // Update UI immediately
      _messages.add(localMessage);
      messageController.clear();
      isTyping = false;
      notifyListeners();

      // Send to backend
      if (isGroupChat == true && groupId != null) {
        await _db.sendGroupMessage(
          groupId: groupId!,
          text: text,
          senderName: currentUserName,
          senderImageUrl: currentUserImageUrl,
        );
      } else if (receiverId != null) {
        await _db.sendMessage(
          receiverId: receiverId!,
          text: text,
          senderName: currentUserName,
          senderImageUrl: currentUserImageUrl,
        );
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
      // Consider showing error to user
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    _messagesSubscription?.cancel();
    super.dispose();
  }

  ///
  /// Delete chats and groups individual
  ///

  // For individual chats
  Future<void> deleteIndividualChat(String chatId) async {
    setState(ViewState.busy);
    try {
      print('Deleting chat with ID: $chatId');

      // Get references to both sides of the chat
      final currentUserId = _db.currentUserId;
      final chatDocRef = FirebaseFirestore.instance
          .collection('chats')
          .doc('${currentUserId}_$chatId');

      final otherUserChatDocRef = FirebaseFirestore.instance
          .collection('chats')
          .doc('${chatId}_$currentUserId');

      // Delete both documents in a batch
      final batch = FirebaseFirestore.instance.batch();
      batch.delete(chatDocRef);
      batch.delete(otherUserChatDocRef);
      await batch.commit();

      // Update local state
      chatsList.removeWhere((user) => user.id == chatId);
      notifyListeners();
    } catch (e) {
      print('Error deleting chat: $e');
      rethrow; // Let the caller handle the error
    } finally {
      setState(ViewState.idle);
    }
  }

  // For group chats
  Future<void> deleteGroupChat(String groupId) async {
    setState(ViewState.busy);
    try {
      // Delete the group from Firestore
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .delete();

      // Remove from local list
      groupsList.removeWhere((group) => group['id'] == groupId);
      notifyListeners();
    } catch (e) {
      print('Error deleting group: $e');
      // You might want to show an error message to the user
    }
    setState(ViewState.idle);
  }
}
