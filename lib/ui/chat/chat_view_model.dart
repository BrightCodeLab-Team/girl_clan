// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:girl_clan/core/model/chat.dart';
// import 'package:girl_clan/ui/chat/chat_repository.dart';

// class ChatViewModel extends ChangeNotifier {
//   final ChatRepository _chatRepository;
//   final FirebaseAuth _auth;

//   // State variables
//   List<ChatConversation> _conversations = [];
//   List<ChatMessage> _messages = [];
//   List<Map<String, dynamic>> _searchResults = [];
//   bool _isLoading = false;
//   String? _currentChatId;
//   bool _isDisposed = false;

//   // Stream subscriptions
//   StreamSubscription<List<ChatConversation>>? _conversationsSubscription;
//   StreamSubscription<List<ChatMessage>>? _messagesSubscription;
//   StreamSubscription<List<Map<String, dynamic>>>? _searchSubscription;

//   ChatViewModel({
//     required ChatRepository chatRepository,
//     required FirebaseAuth auth,
//   }) : _chatRepository = chatRepository,
//        _auth = auth;

//   // Getters
//   List<ChatConversation> get conversations => _conversations;
//   List<ChatMessage> get messages => _messages;
//   List<Map<String, dynamic>> get searchResults => _searchResults;
//   bool get isLoading => _isLoading;
//   String? get currentUserId => _auth.currentUser?.uid;
//   String? get currentChatId => _currentChatId;

//   @override
//   void dispose() {
//     _isDisposed = true;
//     _conversationsSubscription?.cancel();
//     _messagesSubscription?.cancel();
//     _searchSubscription?.cancel();
//     super.dispose();
//   }

//   // Helper method to safely notify listeners
//   bool _isNotifying = false;

//   void _safeNotifyListeners() {
//     if (!_isDisposed && !_isNotifying) {
//       _isNotifying = true;
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _isNotifying = false;
//         if (!_isDisposed) {
//           notifyListeners();
//         }
//       });
//     }
//   }

//   Future<void> loadConversations() async {
//     if (currentUserId == null) return;

//     _isLoading = true;
//     _safeNotifyListeners();

//     try {
//       _conversationsSubscription?.cancel();
//       _conversationsSubscription = _chatRepository
//           .getConversations(currentUserId!)
//           .listen((conversations) {
//             _conversations = conversations;
//             _safeNotifyListeners();
//           });
//     } catch (e) {
//       debugPrint('Error loading conversations: $e');
//     } finally {
//       _isLoading = false;
//       _safeNotifyListeners();
//     }
//   }

//   Future<void> loadMessages({String? otherUserId, String? groupId}) async {
//     if (currentUserId == null) return;

//     _isLoading = true;
//     _currentChatId = groupId ?? otherUserId;
//     _safeNotifyListeners();

//     try {
//       _messagesSubscription?.cancel();
//       if (groupId != null) {
//         _messagesSubscription = _chatRepository
//             .getGroupChatStream(groupId)
//             .listen((messages) {
//               _messages = messages;
//               _safeNotifyListeners();
//             });
//       } else if (otherUserId != null) {
//         _messagesSubscription = _chatRepository
//             .getChatStream(currentUserId!, otherUserId)
//             .listen((messages) {
//               _messages = messages;
//               _safeNotifyListeners();
//             });
//       }
//     } catch (e) {
//       debugPrint('Error loading messages: $e');
//     } finally {
//       _isLoading = false;
//       _safeNotifyListeners();
//     }
//   }

//   Future<void> sendMessage({
//     String? otherUserId,
//     String? groupId,
//     required String message,
//   }) async {
//     if (currentUserId == null || message.isEmpty) return;

//     try {
//       if (groupId != null) {
//         await _chatRepository.sendGroupMessage(
//           groupId: groupId,
//           senderId: currentUserId!,
//           message: message,
//         );
//       } else if (otherUserId != null) {
//         await _chatRepository.send1on1Message(
//           currentUserId: currentUserId!,
//           otherUserId: otherUserId,
//           message: message,
//         );
//       }
//     } catch (e) {
//       debugPrint('Error sending message: $e');
//       rethrow;
//     }
//   }

//   Future<void> searchUsers(String query) async {
//     if (query.isEmpty) {
//       _searchResults = [];
//       _safeNotifyListeners();
//       return;
//     }

//     try {
//       _searchSubscription?.cancel();
//       _searchSubscription = _chatRepository.searchUsers(query).listen((
//         results,
//       ) {
//         _searchResults =
//             results.where((user) => user['id'] != currentUserId).toList();
//         _safeNotifyListeners();
//       });
//     } catch (e) {
//       debugPrint('Error searching users: $e');
//     }
//   }

//   Future<String> createGroup({
//     required String name,
//     required List<String> memberIds,
//   }) async {
//     if (currentUserId == null) throw Exception('User not logged in');

//     try {
//       return await _chatRepository.createGroup(
//         name: name,
//         creatorId: currentUserId!,
//         memberIds: memberIds,
//       );
//     } catch (e) {
//       debugPrint('Error creating group: $e');
//       rethrow;
//     }
//   }

//   void clearMessages() {
//     _messages = [];
//     _currentChatId = null;
//     _safeNotifyListeners();
//   }

//   void clearSearchResults() {
//     _searchResults = [];
//     _safeNotifyListeners();
//   }
// }
