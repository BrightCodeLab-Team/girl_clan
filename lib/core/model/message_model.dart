class MessageModel {
  final String senderId; // Add this
  final String receiverId; // Add this
  final String senderName;
  final String senderImageUrl;
  final String content;
  final String timestamp;
  final bool isMe;
  final bool isTypingIndicator;

  MessageModel({
    this.senderId = '',
    this.receiverId = '',
    required this.senderName,
    required this.senderImageUrl,
    required this.content,
    required this.timestamp,
    required this.isMe,
    this.isTypingIndicator = false,
  });
}
