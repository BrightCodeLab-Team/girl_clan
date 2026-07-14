class MessageModel {
  final String messageId;
  final String senderId;
  final String receiverId;
  final String senderName;
  final String senderImageUrl;
  final String content;
  final String timestamp;
  final bool isMe;
  final bool isTypingIndicator;

  MessageModel({
    this.messageId = '',
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
