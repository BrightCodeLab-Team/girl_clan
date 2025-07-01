import 'package:flutter/material.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/model/new_user_model.dart';
import 'package:girl_clan/core/others/base_view_model.dart'; // Assuming this exists

class NewChatViewModel extends BaseViewModel {
  ///
  ///
  ///

  List<NewUserModel> chatsList = [
    NewUserModel(
      name: 'Alice',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
    NewUserModel(
      name: 'Alice',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
    NewUserModel(
      name: 'Alice',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
    NewUserModel(
      name: 'Alice',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
    NewUserModel(
      name: 'Alice',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
    NewUserModel(
      name: 'Alice',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
  ];

  ///
  ///. groups
  ///
  List<NewUserModel> groupsList = [
    NewUserModel(
      name: 'Hiking',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
    NewUserModel(
      name: 'party',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
    NewUserModel(
      name: 'gathering',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
    NewUserModel(
      name: 'school friends',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
    NewUserModel(
      name: 'college friends',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
    NewUserModel(
      name: 'family',
      imageUrl: AppAssets().appLogo,
      message: 'Hey, how are you?',
      time: '10:30 AM',
    ),
  ];

  ///
  ///
  final List<MessageModel> _messages = [];
  TextEditingController messageController = TextEditingController();

  List<MessageModel> get messages => _messages;

  String chatTitle = '';
  String chatImageUrl = '';
  bool isGroupChat = false;

  NewChatViewModel({
    required String chatTitle,
    required String chatImageUrl,
    required bool isGroupChat,
  }) {
    this.chatTitle = chatTitle;
    this.chatImageUrl = chatImageUrl;
    this.isGroupChat = isGroupChat;

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

  void sendMessage() {
    String messageContent = messageController.text.trim();
    if (messageContent.isNotEmpty) {
      _messages.add(
        MessageModel(
          senderName: 'Current User', // Use actual user's name
          senderImageUrl:
              'assets/images/current_user_profile.png', // Use actual path for current user
          content: messageContent,
          timestamp: _getCurrentTime(),
          isMe: true,
        ),
      );
      messageController.clear();
      notifyListeners();
    }
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final amPm = now.hour >= 12 ? 'PM' : 'AM';
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute $amPm';
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
