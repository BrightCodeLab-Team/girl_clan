import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String? receiverId;
  final String message;
  final DateTime timestamp;
  final List<String> readBy;

  ChatMessage({
    required this.id,
    required this.senderId,
    this.receiverId,
    required this.message,
    required this.timestamp,
    this.readBy = const [],
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'],
      message: map['message'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      readBy: List<String>.from(map['readBy'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      if (receiverId != null) 'receiverId': receiverId,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'readBy': readBy,
    };
  }
}

class ChatConversation {
  final String id;
  final bool isGroup;
  final String? otherUserId;
  final String? groupName;
  final ChatMessage lastMessage;
  final DateTime? lastMessageTime;

  ChatConversation({
    required this.id,
    required this.isGroup,
    this.otherUserId,
    this.groupName,
    required this.lastMessage,
    this.lastMessageTime,
  });
}
