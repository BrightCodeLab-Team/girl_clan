import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:girl_clan/core/model/event_model.dart';
import 'package:girl_clan/core/model/user_model.dart';

class DatabaseServices {
  final _db = FirebaseFirestore.instance;

  static final DatabaseServices _singleton = DatabaseServices._internal();

  factory DatabaseServices() {
    return _singleton;
  }

  DatabaseServices._internal();

  ///
  ///. fetch all current user events
  ///
  Future<List<EventModel>> getCurrentUserEvents(String userId) async {
    try {
      final snapshot =
          await _db.collection('events').where('id', isEqualTo: userId).get();

      debugPrint('Found ${snapshot.docs.length} user events for user $userId');

      final events = <EventModel>[];

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();
          data['id'] = doc.id;

          debugPrint('User event: ${data['eventName']} on ${data['date']}');

          final event = EventModel.fromJson(data);
          events.add(event);
        } catch (e) {
          debugPrint('Error processing user event ${doc.id}: $e');
        }
      }

      return events;
    } catch (e, s) {
      debugPrint('Error in getting CurrentUser Events: $e');
      debugPrint('Stack trace: $s');
      return [];
    }
  }

  ///
  ///. ad event details to database
  addEventsToDataBase(EventModel eventModel) async {
    try {
      await _db
          .collection('events')
          .add(eventModel.toJson())
          .then((value) => debugPrint('user registered successfully'));
    } catch (e, s) {
      debugPrint('Exception @DatabaseService/addEvent');
      debugPrint(s.toString());
      return false;
    }
  }

  Future<List<EventModel>> getUpcomingEvents() async {
    try {
      final snapshot = await _db.collection('events').orderBy('date').get();

      debugPrint('Found ${snapshot.docs.length} documents');

      final events = <EventModel>[];

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();
          // Add document ID to the data
          data['id'] = doc.id;

          debugPrint(
            'Processing event: ${data['eventName']} on ${data['date']}',
          );

          final event = EventModel.fromJson(data);
          events.add(event);
        } catch (e) {
          debugPrint('Error processing document ${doc.id}: $e');
        }
      }

      return events;
    } catch (e, s) {
      debugPrint('Error in getUpcomingEvents: $e');
      debugPrint('Stack trace: $s');
      return [];
    }
  }

  ///
  ///
  ///

  ///
  ///  get all events from database
  ///
  Future<List<EventModel>> getAllEvents(EventModel eventModel) async {
    try {
      debugPrint('Fetching all events from Firestore...');
      final snapshot = await _db.collection('events').orderBy('date').get();

      debugPrint('Found ${snapshot.docs.length} events');

      final events =
          snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id; // Include document ID
            debugPrint('Event data: ${data.toString()}');
            return EventModel.fromJson(data);
          }).toList();

      return events;
    } catch (e, s) {
      debugPrint('Error in getAllEvents: $e');
      debugPrint('Stack trace: $s');
      return [];
    }
  }

  ///
  ///  get hiking events from database
  ///
  Future<List<EventModel>> getHikingEvents(EventModel eventModel) async {
    try {
      // Query for all possible case variations
      final snapshot =
          await _db
              .collection('events')
              .where('category', whereIn: ['Hiking', 'hiking', 'HIKING'])
              .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return EventModel.fromJson(data);
      }).toList();
      // ignore: unused_catch_stack
    } catch (e, s) {
      debugPrint('Error in getHikingEvents: $e');
      return [];
    }
  }

  ///
  ///. get concert events from database
  ///
  Future<List<EventModel>> getConcertEvents(EventModel eventModel) async {
    try {
      final snapshot =
          await _db
              .collection('events')
              .where('category', whereIn: ['Concert', 'concert', 'CONCERT'])
              .get();

      debugPrint('Found ${snapshot.docs.length} documents');

      final events = <EventModel>[];

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();
          // Add document ID to the data
          data['id'] = doc.id;

          debugPrint(
            'Processing event: ${data['eventName']} on ${data['date']}',
          );

          final event = EventModel.fromJson(data);
          events.add(event);
        } catch (e) {
          debugPrint('Error processing document ${doc.id}: $e');
        }
      }

      return events;
    } catch (e, s) {
      debugPrint('Error in getUpcomingEvents: $e');
      debugPrint('Stack trace: $s');
      return [];
    }
  }

  ///
  ///. get party events from database
  ///
  Future<List<EventModel>> getPartyEvents(EventModel eventModel) async {
    try {
      final snapshot =
          await _db
              .collection('events')
              .where('category', whereIn: ['Party', 'party', 'PARTY'])
              .get();

      debugPrint('Found ${snapshot.docs.length} documents');

      final events = <EventModel>[];

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();
          // Add document ID to the data
          data['id'] = doc.id;

          debugPrint(
            'Processing event: ${data['eventName']} on ${data['date']}',
          );

          final event = EventModel.fromJson(data);
          events.add(event);
        } catch (e) {
          debugPrint('Error processing document ${doc.id}: $e');
        }
      }

      return events;
    } catch (e, s) {
      debugPrint('Error in getUpcomingEvents: $e');
      debugPrint('Stack trace: $s');
      return [];
    }
  }

  ///
  ///. get Workshop events from database
  ///
  Future<List<EventModel>> getWorkShopEvents(EventModel eventModel) async {
    try {
      final snapshot =
          await _db
              .collection('events')
              .where('category', whereIn: ['Workshop', 'workshop', 'WORKSHOP'])
              .get();

      debugPrint('Found ${snapshot.docs.length} documents');

      final events = <EventModel>[];

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();
          // Add document ID to the data
          data['id'] = doc.id;

          debugPrint(
            'Processing event: ${data['eventName']} on ${data['date']}',
          );

          final event = EventModel.fromJson(data);
          events.add(event);
        } catch (e) {
          debugPrint('Error processing document ${doc.id}: $e');
        }
      }

      return events;
    } catch (e, s) {
      debugPrint('Error in getUpcomingEvents: $e');
      debugPrint('Stack trace: $s');
      return [];
    }
  }

  ///
  ///. get sports events from database
  ///
  Future<List<EventModel>> getSportsEvents(EventModel eventModel) async {
    try {
      final snapshot =
          await _db
              .collection('events')
              .where('category', whereIn: ['Sports', 'sports', 'SPORTS'])
              .get();

      debugPrint('Found ${snapshot.docs.length} documents');

      final events = <EventModel>[];

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();
          // Add document ID to the data
          data['id'] = doc.id;

          debugPrint(
            'Processing event: ${data['eventName']} on ${data['date']}',
          );

          final event = EventModel.fromJson(data);
          events.add(event);
        } catch (e) {
          debugPrint('Error processing document ${doc.id}: $e');
        }
      }

      return events;
    } catch (e, s) {
      debugPrint('Error in getUpcomingEvents: $e');
      debugPrint('Stack trace: $s');
      return [];
    }
  }

  ///
  ///. get Art Exhibitions events from database
  ///
  Future<List<EventModel>> getArtExhibitionsEvents(
    EventModel eventModel,
  ) async {
    try {
      final snapshot =
          await _db
              .collection('events')
              .where(
                'category',
                whereIn: [
                  'ArtExhibition',
                  'artexhibition',
                  'ARTEXHIBITION',
                  'Art Exhibition',
                  'art exhibition',
                  'ART EXHIBITION',
                ],
              )
              .get();

      debugPrint('Found ${snapshot.docs.length} documents');

      final events = <EventModel>[];

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();
          // Add document ID to the data
          data['id'] = doc.id;

          debugPrint(
            'Processing event: ${data['eventName']} on ${data['date']}',
          );

          final event = EventModel.fromJson(data);
          events.add(event);
        } catch (e) {
          debugPrint('Error processing document ${doc.id}: $e');
        }
      }

      return events;
    } catch (e, s) {
      debugPrint('Error in getUpcomingEvents: $e');
      debugPrint('Stack trace: $s');
      return [];
    }
  }

  ///
  ///
  ///
  ///
  ///. chat services
  ///
  ///

  // Get all users for chat list
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // static final DatabaseServices _singleton = DatabaseServices._internal();
  // factory DatabaseServices() => _singleton;
  // DatabaseServices._internal();

  // Get current user ID
  String get currentUserId => _auth.currentUser?.uid ?? '';

  // Generate consistent chat ID between two users
  String _getChatId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode
        ? '${userId1}_$userId2'
        : '${userId2}_$userId1';
  }

  // Send a message
  Future<void> sendMessage({
    required String receiverId,
    required String text,
  }) async {
    try {
      final chatId = _getChatId(currentUserId, receiverId);
      final messageRef =
          _firestore
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .doc();

      final messageData = {
        'senderId': currentUserId,
        'receiverId': receiverId,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
      };

      // Batch write for atomic operation
      final batch = _firestore.batch();

      // Add message
      batch.set(messageRef, messageData);

      // Update chat metadata
      batch.set(_firestore.collection('chats').doc(chatId), {
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'participants': [currentUserId, receiverId],
        'participantNames': {
          currentUserId: await _getUserName(currentUserId),
          receiverId: await _getUserName(receiverId),
        },
        'participantAvatars': {
          currentUserId: await _getUserAvatar(currentUserId),
          receiverId: await _getUserAvatar(receiverId),
        },
      }, SetOptions(merge: true));

      await batch.commit();
    } catch (e) {
      debugPrint('Error sending message: $e');
      rethrow;
    }
  }

  // Get messages stream
  Stream<QuerySnapshot> getMessagesStream(String receiverId) {
    final chatId = _getChatId(currentUserId, receiverId);
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Get all users for chat list
  Future<List<UserModel>> getAllUsers() async {
    try {
      // Exclude current user from the list
      final snapshot =
          await _firestore
              .collection('users')
              .where('id', isNotEqualTo: currentUserId)
              .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return UserModel(
          id: doc.id,
          name: data['name'] ?? 'Unknown',
          imageUrl: data['profileImageUrl'] ?? '',
          message: data['lastMessage'] ?? '',
          time:
              data['lastMessageTime'] != null
                  ? _formatTimestamp(data['lastMessageTime'])
                  : '',
        );
      }).toList();
    } catch (e) {
      debugPrint('Error getting users: $e');
      return [];
    }
  }

  // Helper methods
  Future<String> _getUserName(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data()?['name'] ?? 'Unknown';
  }

  Future<String> _getUserAvatar(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data()?['profileImageUrl'] ?? '';
  }

  String _formatTimestamp(Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }
}
