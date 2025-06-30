// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:girl_clan/core/model/chat.dart';
// import 'package:rxdart/rxdart.dart';

// class ChatRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // 1-on-1 Chat Methods
//   Stream<List<ChatMessage>> getChatStream(
//     String currentUserId,
//     String otherUserId,
//   ) {
//     final participants = [currentUserId, otherUserId]..sort();
//     final chatId = participants.join('_');

//     return _firestore.collection('chats').doc(chatId).snapshots().map((
//       snapshot,
//     ) {
//       if (!snapshot.exists) return [];
//       final data = snapshot.data()!;
//       return (data['messages'] as List)
//           .map((msg) => ChatMessage.fromMap(msg as Map<String, dynamic>))
//           .toList()
//         ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
//     });
//   }

//   Future<void> send1on1Message({
//     required String currentUserId,
//     required String otherUserId,
//     required String message,
//   }) async {
//     final participants = [currentUserId, otherUserId]..sort();
//     final chatId = participants.join('_');

//     final newMessage = ChatMessage(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       senderId: currentUserId,
//       receiverId: otherUserId,
//       message: message,
//       timestamp: DateTime.now(),
//     );

//     await _firestore.collection('chats').doc(chatId).set({
//       'participants': participants,
//       'lastMessage': newMessage.toMap(),
//       'lastMessageTime': Timestamp.now(),
//       'updatedAt': FieldValue.serverTimestamp(),
//     }, SetOptions(merge: true));

//     await _firestore.collection('chats').doc(chatId).update({
//       'messages': FieldValue.arrayUnion([newMessage.toMap()]),
//     });
//   }

//   // Group Chat Methods
//   Stream<List<ChatMessage>> getGroupChatStream(String groupId) {
//     return _firestore.collection('groups').doc(groupId).snapshots().map((
//       snapshot,
//     ) {
//       if (!snapshot.exists) return [];
//       final data = snapshot.data()!;
//       return (data['messages'] as List)
//           .map((msg) => ChatMessage.fromMap(msg as Map<String, dynamic>))
//           .toList()
//         ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
//     });
//   }

//   Future<void> sendGroupMessage({
//     required String groupId,
//     required String senderId,
//     required String message,
//   }) async {
//     final newMessage = ChatMessage(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       senderId: senderId,
//       message: message,
//       timestamp: DateTime.now(),
//     );

//     await _firestore.collection('groups').doc(groupId).update({
//       'messages': FieldValue.arrayUnion([newMessage.toMap()]),
//       'lastMessage': newMessage.toMap(),
//       'lastMessageTime': Timestamp.now(),
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }

//   Future<String> createGroup({
//     required String name,
//     required String creatorId,
//     required List<String> memberIds,
//   }) async {
//     final groupRef = _firestore.collection('groups').doc();

//     final groupData = {
//       'id': groupRef.id,
//       'name': name,
//       'creatorId': creatorId,
//       'admins': [creatorId],
//       'members': [...memberIds, creatorId],
//       'messages': [],
//       'createdAt': FieldValue.serverTimestamp(),
//       'updatedAt': FieldValue.serverTimestamp(),
//     };

//     await groupRef.set(groupData);
//     return groupRef.id;
//   }

//   // User Search
//   Stream<List<Map<String, dynamic>>> searchUsers(String query) {
//     return _firestore
//         .collection('users')
//         .where('username', isGreaterThanOrEqualTo: query)
//         .where('username', isLessThan: query + 'z')
//         .snapshots()
//         .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
//   }

//   // Get all conversations
//   Stream<List<ChatConversation>> getConversations(String userId) {
//     final chatsStream =
//         _firestore
//             .collection('chats')
//             .where('participants', arrayContains: userId)
//             .snapshots();

//     final groupsStream =
//         _firestore
//             .collection('groups')
//             .where('members', arrayContains: userId)
//             .snapshots();

//     return CombineLatestStream.list<QuerySnapshot>([
//       chatsStream,
//       groupsStream,
//     ]).map((List<QuerySnapshot> combined) {
//       final chatConversations =
//           combined[0].docs.map((doc) {
//             final data = doc.data() as Map<String, dynamic>;
//             final participants = List<String>.from(
//               data['participants'] as List,
//             );
//             final otherUserId = participants.firstWhere((id) => id != userId);
//             return ChatConversation(
//               id: doc.id,
//               isGroup: false,
//               otherUserId: otherUserId,
//               lastMessage: ChatMessage.fromMap(
//                 data['lastMessage'] as Map<String, dynamic>,
//               ),
//               lastMessageTime:
//                   (data['lastMessageTime'] as Timestamp?)?.toDate(),
//             );
//           }).toList();

//       final groupConversations =
//           combined[1].docs.map((doc) {
//             final data = doc.data() as Map<String, dynamic>;
//             return ChatConversation(
//               id: doc.id,
//               isGroup: true,
//               groupName: data['name'] as String,
//               lastMessage: ChatMessage.fromMap(
//                 data['lastMessage'] as Map<String, dynamic>,
//               ),
//               lastMessageTime:
//                   (data['lastMessageTime'] as Timestamp?)?.toDate(),
//             );
//           }).toList();

//       return [...chatConversations, ...groupConversations]..sort(
//         (a, b) => (b.lastMessageTime ?? DateTime(0)).compareTo(
//           a.lastMessageTime ?? DateTime(0),
//         ),
//       );
//     });
//   }
// }
