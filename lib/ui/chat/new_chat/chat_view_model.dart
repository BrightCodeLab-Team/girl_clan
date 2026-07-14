// ignore_for_file: prefer_initializing_formals

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/core/model/message_model.dart';
import 'package:girl_clan/core/model/user_model.dart';
import 'package:girl_clan/core/others/base_view_model.dart';
import 'package:girl_clan/core/services/data_base_services.dart';
import 'package:girl_clan/core/services/moderation_service.dart';
import 'package:girl_clan/core/utils/content_filter.dart';
import 'package:girl_clan/locator.dart';
import 'package:intl/intl.dart';

class ChatViewModel extends BaseViewModel {
  final DatabaseServices _db = locator<DatabaseServices>();
  final ModerationService _moderation = locator<ModerationService>();
  bool isLoading = true;
  final String? chatTitle;
  final String? chatImageUrl;
  final bool? isGroupChat;
  final String? receiverId;
  final String? groupId;
  List<Map<String, dynamic>> groupsList = [];
  final searchController = TextEditingController();
  String searchQuery = '';

  final TextEditingController messageController = TextEditingController();
  bool isTyping = false;

  final List<MessageModel> _messages = [];
  List<UserModel> chatsList = [];
  List<UserModel> allChatsList = [];

  List<Map<String, dynamic>> allGroupsList = [];
  List<Map<String, dynamic>> filteredGroupsList = [];

  List<MessageModel> get messages => _messages;

  StreamSubscription? _messagesSubscription;
  VoidCallback? _moderationListener;

  ChatViewModel({
    this.chatTitle,
    this.chatImageUrl,
    this.isGroupChat,
    this.receiverId,
    this.groupId,
  }) {
    _moderationListener = _onModerationChanged;
    _moderation.addListener(_moderationListener!);
    initMessagesStream();
    loadUsers();
    loadGroups();
    messageController.addListener(_onTyping);
  }

  void _onModerationChanged() {
    _applyMessageFilters();
    chatsList =
        allChatsList.where((u) => !_moderation.isUserBlocked(u.id ?? '')).toList();
    notifyListeners();
  }

  void _applyMessageFilters() {
    _messages.removeWhere((m) => !_isMessageVisible(m));
  }

  String? get chatIdForModeration {
    if (isGroupChat == true && groupId != null) return groupId;
    if (receiverId != null) {
      final a = _db.currentUserId;
      final b = receiverId!;
      return a.hashCode <= b.hashCode ? '${a}_$b' : '${b}_$a';
    }
    return null;
  }

  void replyToMessage(MessageModel message) {
    messageController.text = 'Replying to "${message.content}": ';
    messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: messageController.text.length),
    );
    notifyListeners();
  }

  Future<String?> blockUser(String userId) async {
    final error = await _moderation.blockUser(userId);
    if (error == null) {
      _applyMessageFilters();
      await loadUsers();
      notifyListeners();
    }
    return error;
  }

  void _onTyping() {
    final hasText = messageController.text.trim().isNotEmpty;
    if (hasText != isTyping) {
      isTyping = hasText;
      notifyListeners();
    }
  }

  void updateSearchQuery(String query) {
    searchQuery = query.toLowerCase();

    // Filter users
    chatsList =
        allChatsList.where((user) {
          if (_moderation.isUserBlocked(user.id ?? '')) return false;
          return user.name!.toLowerCase().contains(searchQuery);
        }).toList();

    // Filter groups
    filteredGroupsList =
        allGroupsList.where((group) {
          final groupName = (group['name'] ?? '').toString().toLowerCase();
          return groupName.contains(searchQuery);
        }).toList();

    notifyListeners();
  }

  initMessagesStream() {
    if (isGroupChat == true && groupId != null) {
      // group chat stream
      _messagesSubscription = _db.getGroupMessagesStream(groupId!).listen((
        snapshot,
      ) {
        _messages.clear();
        _messages.addAll(
          snapshot.docs
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return _parseGroupMessage(data, doc.id);
              })
              .where(_isMessageVisible)
              .toList(),
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
          snapshot.docs
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return _parseMessage(data, doc.id);
              })
              .where(_isMessageVisible)
              .toList(),
        );
        notifyListeners();
      });
    }
  }

  bool _isMessageVisible(MessageModel message) {
    if (message.isMe) return true;
    if (_moderation.isMessageHidden(message.messageId)) return false;
    if (_moderation.isUserContentHidden(message.senderId)) return false;
    final senderId = message.senderId;
    if (senderId.isEmpty) return true;
    return !_moderation.isUserBlocked(senderId);
  }

  MessageModel _parseGroupMessage(Map<String, dynamic> data, String docId) {
    final isMe = data['senderId'] == _db.currentUserId;
    return MessageModel(
      messageId: docId,
      senderId: data['senderId'] ?? '',
      receiverId: groupId ?? "",
      senderName: isMe ? 'You' : (data['senderName'] ?? 'Unknown User'),
      senderImageUrl: data['senderImageUrl'] ?? '',
      content: data['text'] ?? '',
      timestamp: _formatTimestamp(data['timestamp']),
      isMe: isMe,
    );
  }

  MessageModel _parseMessage(Map<String, dynamic> data, String docId) {
    final isMe = data['senderId'] == _db.currentUserId;
    return MessageModel(
      messageId: docId,
      senderId: data['senderId'] ?? '',
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
      notifyListeners();

      await locator<ModerationService>().refreshBlockedUsers();

      // Fetch all users
      allChatsList = await _db.getAllChatUsers();

      chatsList =
          allChatsList
              .where((u) => !_moderation.isUserBlocked(u.id ?? ''))
              .toList();

      debugPrint("Loaded chat users: ${chatsList.length}");
    } catch (e) {
      debugPrint('Error loading users: $e');
    } finally {
      isLoading = false;
      notifyListeners();
      setState(ViewState.idle);
    }
  }

  Future<void> loadGroups() async {
    try {
      setState(ViewState.busy);
      isLoading = true;
      notifyListeners();

      // Fetch groups from DB
      allGroupsList = await _db.getUserGroups();

      // Initially show all
      filteredGroupsList = List.from(allGroupsList);

      debugPrint("Loaded groups: ${filteredGroupsList.length}");
    } catch (e) {
      debugPrint('Error loading groups: $e');
    } finally {
      isLoading = false;
      notifyListeners();
      setState(ViewState.idle);
    }
  }

  /// Sends a message
  Future<String?> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return null;

    final filterError = ContentFilter.validationError(text);
    if (filterError != null) return filterError;

    if (receiverId != null) {
      if (await _moderation.isEitherUserBlocked(receiverId!)) {
        return 'You cannot message this user.';
      }
    }

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
      return null;
    } catch (e) {
      debugPrint('Error sending message: $e');
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  @override
  void dispose() {
    if (_moderationListener != null) {
      _moderation.removeListener(_moderationListener!);
    }
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
