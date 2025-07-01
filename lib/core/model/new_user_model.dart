import 'package:girl_clan/core/constants/app_assets.dart';

class NewUserModel {
  final String? id;
  final String imageUrl;
  final String name;
  final String message;
  final String time;

  NewUserModel({
    this.id,
    required this.imageUrl,
    required this.name,
    required this.message,
    required this.time,
  });
  Map<String, dynamic> toJson() {
    return {
      //'id': currentUser?.uid ?? '',
      'id': id ?? '',
      'name': name ?? '',
      'time': time ?? '',
      'profileImageUrl': imageUrl ?? AppAssets().loginImage,
      'message': message ?? '',
    };
  }

  // Factory constructor to create an Event from a Map (useful for persistence)
  factory NewUserModel.fromJson(Map<String, dynamic> json) {
    return NewUserModel(
      id: json['id'].toString(),
      name: json['name'].toString(),
      imageUrl: json['profileImageUrl'].toString(),
      message: json['message'].toString(),
      time: json['time'].toString(),
    );
  }
}

///
/// massage model
///

class MessageModel {
  final String senderName;
  final String senderImageUrl;
  final String content;
  final String timestamp; // Can be DateTime if you need to parse/format
  final bool isMe; // true if the message is from the current user
  final bool isTypingIndicator; // true if this message is the typing ellipsis

  MessageModel({
    required this.senderName,
    required this.senderImageUrl,
    required this.content,
    required this.timestamp,
    required this.isMe,
    this.isTypingIndicator = false,
  });
}
