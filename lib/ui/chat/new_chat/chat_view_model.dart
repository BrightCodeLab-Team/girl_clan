import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:intl/intl.dart';
import 'package:girl_clan/core/model/message_model.dart';
import 'package:girl_clan/core/model/user_model.dart';
import 'package:girl_clan/core/others/base_view_model.dart';
import 'package:girl_clan/core/services/data_base_services.dart';
import 'package:girl_clan/locator.dart'; // Assuming this exists

class ChatViewModel extends BaseViewModel {
  ///
  ///
  ///

  List<UserModel> chatsList = [
    UserModel(
      name: 'shayan',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
    UserModel(
      name: 'sanan',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
    UserModel(
      name: 'numan',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
    UserModel(
      name: 'awasi',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
    UserModel(
      name: 'jawad',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
    UserModel(
      name: 'umair',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
  ];

  ///
  ///. groups
  ///
  List<UserModel> groupsList = [
    UserModel(
      name: 'Hiking',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
    UserModel(
      name: 'party',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
    UserModel(
      name: 'gathering',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
    UserModel(
      name: 'school friends',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
    UserModel(
      name: 'college friends',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
    UserModel(
      name: 'family',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
  ];

  ///
  ///
  List<MessageModel> _messages = [];
  TextEditingController messageController = TextEditingController();

  List<MessageModel> get messages => _messages;

  String chatTitle = '';
  String chatImageUrl = '';
  bool isGroupChat = false;
  String receiverId = '';

  ChatViewModel({
    required String chatTitle,
    required String chatImageUrl,
    required bool isGroupChat,
    required String receiverId,
  }) {
    this.chatTitle = chatTitle;
    this.chatImageUrl = chatImageUrl;
    this.receiverId = receiverId;
    this.isGroupChat = isGroupChat;
    _initMessagesStream();
    _loadUsers();

    // Initialize with dummy data based on the chat type
    // In a real application, you would fetch messages from a database/API
    // based on an ID passed for this specific chat.
    _messages.clear(); // Ensure it's clear before populating

    if (!isGroupChat && chatTitle == 'Anya') {
      // Specific dummy data for Anya's one-to-one chat
      _messages.addAll([
        MessageModel(
          senderName: 'Anya',
          senderImageUrl: 'assets/images/anya_profile.png',
          content: 'Hey, are you coming to the meetup later?',
          timestamp: '04:56 AM',
          isMe: false,
          senderId: '',
          receiverId: '',
        ),
        MessageModel(
          senderName: 'Current User',
          senderImageUrl: 'assets/images/current_user_profile.png',
          content: 'Yep, I\'ll be there in 15!',
          timestamp: '04:56 AM',
          isMe: true,
        ),
        MessageModel(
          senderName: 'Anya',
          senderImageUrl: 'assets/images/anya_profile.png',
          content: 'Just sent the design files. Let me know if they look okay!',
          timestamp: '04:56 AM',
          isMe: false,
        ),
        MessageModel(
          senderName: 'Anya',
          senderImageUrl: 'assets/images/anya_profile.png',
          content: 'I\'m thinking about changing the color palette a bit.',
          timestamp: '04:56 AM',
          isMe: false,
        ),
        MessageModel(
          senderName: 'Current User',
          senderImageUrl: 'assets/images/current_user_profile.png',
          content: 'Got them. Looks super clean',
          timestamp: '04:56 AM',
          isMe: true,
        ),
        MessageModel(
          senderName: 'Current User',
          senderImageUrl: 'assets/images/current_user_profile.png',
          content:
              'Yeah, maybe something softer. The current one feels a bit harsh.',
          timestamp: '04:56 AM',
          isMe: true,
        ),
        MessageModel(
          senderName: 'Anya',
          senderImageUrl: 'assets/images/anya_profile.png',
          content: '...',
          timestamp: '',
          isMe: false,
          isTypingIndicator: true,
        ),
      ]);
    } else if (isGroupChat && chatTitle == 'Trip Troopers') {
      // Specific dummy data for Trip Troopers group chat
      _messages.addAll([
        MessageModel(
          senderName: 'Alex',
          senderImageUrl: 'assets/images/alex_profile.png',
          content: 'Hey everyone, are we still on for Saturday?',
          timestamp: '04:56 AM',
          isMe: false,
        ),
        MessageModel(
          senderName: 'Jenna',
          senderImageUrl: 'assets/images/jenna_profile.png',
          content: 'Yep! I just booked the Airbnb',
          timestamp: '04:56 AM',
          isMe: false,
        ),
        MessageModel(
          senderName: 'Ryan',
          senderImageUrl: 'assets/images/ryan_profile.png',
          content: 'Nice! Should we bring snacks or just order there?',
          timestamp: '04:56 AM',
          isMe: false,
        ),
        MessageModel(
          senderName: 'Current User',
          senderImageUrl: 'assets/images/current_user_profile.png',
          content:
              'Let\'s order - I\'m not carrying chips across the city again',
          timestamp: '04:56 AM',
          isMe: true,
        ),
        MessageModel(
          senderName: 'Alex',
          senderImageUrl: 'assets/images/alex_profile.png',
          content: 'Fair. I\'ll make the playlist! Any requests?',
          timestamp: '04:56 AM',
          isMe: false,
        ),
        MessageModel(
          senderName: 'Typing Indicator',
          senderImageUrl: 'assets/images/jenna_profile.png',
          content: '...',
          timestamp: '',
          isMe: false,
          isTypingIndicator: true,
        ),
      ]);
    }
    // You can add more 'else if' blocks for other specific chats/groups
    // For any other chat, you might have a default empty list or fetch dynamically.
  }

  final DatabaseServices _db = locator<DatabaseServices>();
  //final TextEditingController messageController = TextEditingController();
  StreamSubscription? _messagesSubscription;

  // List<UserModel> chatsList = [];
  // List<MessageModel> _messages = [];
  // String chatTitle = '';
  // String chatImageUrl = '';

  // List<MessageModel> get messages => _messages;

  // ChatViewModel({
  //   required String chatTitle,
  //   required String chatImageUrl,
  //   required String receiverId,
  // }) {
  //   this.chatTitle = chatTitle;
  //   this.chatImageUrl = chatImageUrl;
  //   this.receiverId = receiverId;

  //   _initMessagesStream();
  //   _loadUsers();
  // }

  void _initMessagesStream() {
    _messagesSubscription = _db.getMessagesStream(receiverId).listen((
      snapshot,
    ) {
      _messages =
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return _parseMessage(data);
          }).toList();
      notifyListeners();
    });
  }

  MessageModel _parseMessage(Map<String, dynamic> data) {
    final isMe = data['senderId'] == _db.currentUserId;
    return MessageModel(
      senderName: isMe ? 'You' : chatTitle,
      senderImageUrl:
          isMe ? 'assets/images/current_user_profile.png' : chatImageUrl,
      content: data['text'] ?? '',
      timestamp: _formatTimestamp(data['timestamp']),
      isMe: isMe,
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Just now';
    final date = (timestamp as Timestamp).toDate();
    return DateFormat('h:mm a').format(date);
  }

  Future<void> _loadUsers() async {
    setState(ViewState.busy);
    try {
      chatsList = await _db.getAllUsers();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading users: $e');
    } finally {
      setState(ViewState.idle);
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    try {
      await _db.sendMessage(receiverId: receiverId, text: text);
      messageController.clear();
    } catch (e) {
      debugPrint('Error sending message: $e');
      // You might want to show an error to the user here
    }
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    messageController.dispose();
    super.dispose();
  }
}
