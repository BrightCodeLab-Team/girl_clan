// ///
// /// massage model
// ///

// class MessageModel {
//   final String senderName;
//   final String senderImageUrl;
//   final String content;
//   final String timestamp; // Can be DateTime if you need to parse/format
//   final bool isMe; // true if the message is from the current user
//   final bool isTypingIndicator; // true if this message is the typing ellipsis

//   MessageModel({
//     required this.senderName,
//     required this.senderImageUrl,
//     required this.content,
//     required this.timestamp,
//     required this.isMe,
//     this.isTypingIndicator = false,
//   });
// }
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
