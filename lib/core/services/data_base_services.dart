// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/model/event_model.dart';
import 'package:girl_clan/core/model/groups_model.dart';
import 'package:girl_clan/core/model/user_model.dart';

class DatabaseServices {
  final _db = FirebaseFirestore.instance;

  final List<UserModel> userModels = [];

  static final DatabaseServices _singleton = DatabaseServices._internal();

  factory DatabaseServices() {
    return _singleton;
  }

  DatabaseServices._internal();

  ///
  ///. fetch all current user events
  ///
  Future<List<EventModel>> getCurrentUserEvents(currentUserId) async {
    try {
      final snapshot =
          await _db
              .collection('events')
              .where('id', isEqualTo: currentUserId)
              .get();

      final events = <EventModel>[];

      print("events lenght==> ${events.length}");

      for (var doc in snapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        final event = EventModel.fromJson(data);
        events.add(event);
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
  addEventsToDataBase(EventModel eventModel, hostName) async {
    try {
      final ref = _db.collection('events');
      eventModel.id = currentUserId;
      eventModel.hostName = hostName;
      eventModel = ref.add(eventModel.toJson()) as EventModel;
      print("event data ${eventModel.toJson()}");
    } catch (e, s) {
      debugPrint('Exception @DatabaseService/addEvent');
      debugPrint(s.toString());
      return false;
    }
  }

  //  Future<List<EventModel>> getUpcomingEvents() async {
  //     try {
  //       final query = FirebaseFirestore.instance
  //           .collection('events')
  //           .where('status', isNotEqualTo: 'ended') // Only active events
  //           .orderBy('date');

  //       final snapshot = await query.get();
  //       return snapshot.docs
  //           .map((doc) => EventModel.fromJson(doc.data()))
  //           .toList();
  //     } catch (e) {
  //       debugPrint('Error getting upcoming events: $e');
  //       return [];
  //     }
  //   }
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
  Future<List<EventModel>> getAllEventsByCategory(String category) async {
    try {
      debugPrint('Fetching events from Firestore with category: $category');

      late QuerySnapshot<Map<String, dynamic>> snapshot;

      if (category == 'All' || category.isEmpty) {
        // All: fetch all events without filter
        snapshot = await _db.collection('events').get();
      } else {
        // Filtered by category
        snapshot =
            await _db
                .collection('events')
                .where('category', isEqualTo: category)
                .get();
      }

      debugPrint(
        'Found ${snapshot.docs.length} events for category: $category',
      );

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return EventModel.fromJson(data);
      }).toList();
    } catch (e, s) {
      debugPrint('Error in getAllEventsByCategory: $e');
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

  Future<List<GroupsModel>> getGroupsData() async {
    final response = await _db.collection("events_groups").get();
    List<GroupsModel> groupList = [];

    if (response.docs.isNotEmpty) {
      for (var doc in response.docs) {
        groupList.add(GroupsModel.fromJson(doc.data()));
      }
      print("events group data ==>>> $groupList");
    } else {
      print("No groups found.");
    }

    return groupList;
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
    required String senderName, // Add this
    required String senderImageUrl, // Add this
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
        'senderName': senderName, // Include sender name
        'senderImageUrl': senderImageUrl, // Include sender image
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
          currentUserId: senderName, // Use passed senderName
          receiverId: await _getUserName(receiverId),
        },
        'participantAvatars': {
          currentUserId: senderImageUrl, // Use passed senderImageUrl
          receiverId: await _getUserAvatar(receiverId),
        },
      }, SetOptions(merge: true));

      await batch.commit();
    } catch (e) {
      debugPrint('Error sending message: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getGroupMembers(String groupId) async {
    try {
      final doc = await _db.collection('groups').doc(groupId).get();
      if (doc.exists) {
        final members = List<String>.from(doc['members'] ?? []);
        final membersData = <Map<String, dynamic>>[];

        for (final memberId in members) {
          final memberDoc =
              await _db.collection('app-user').doc(memberId).get();
          if (memberDoc.exists) {
            membersData.add(memberDoc.data()!);
          }
        }

        return membersData;
      }
      return [];
    } catch (e) {
      debugPrint('Error getting group members: $e');
      return [];
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

  Future<Map<String, dynamic>> getCurrentUserData() async {
    try {
      final doc = await _db.collection('app-user').doc(currentUserId).get();
      if (doc.exists) {
        return doc.data() ?? {};
      }
      return {};
    } catch (e) {
      debugPrint('Error getting current user data: $e');
      return {};
    }
  }

  Future<List<UserModel>> getAllChatUsers() async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) return [];

      final snapshot =
          await FirebaseFirestore.instance
              .collection('chats')
              .where('participants', arrayContains: currentUserId)
              .get();

      final List<UserModel> userModels = [];

      for (var doc in snapshot.docs) {
        final participants = doc['participants'] as List<dynamic>;
        final otherUserId = participants.firstWhereOrNull(
          (id) => id != currentUserId,
        );

        if (otherUserId != null) {
          final userDoc =
              await FirebaseFirestore.instance
                  .collection('app-user')
                  .doc(otherUserId)
                  .get();

          if (userDoc.exists && userDoc.data() != null) {
            final userData = userDoc.data()!;
            userData['id'] = userDoc.id;
            userData['name'] =
                '${userData['firstName']} ${userData['surName']}';
            userData['imgUrl'] = userData['imgUrl'] ?? '';
            userData['message'] = doc['lastMessage'];
            userData['time'] = doc['lastMessageTime'];

            print("user profileImageUrl:  ${userData['profileImageUrl']}");
            print("user message:  ${userData['lastMessage']}");
            print("user lastMessageTime:  ${userData['lastMessage']}");
            userModels.add(UserModel.fromJson(userData));
          }
        }
      }

      return userModels;
    } catch (e) {
      debugPrint('Error fetching chat users: $e');
      return [];
    }
  }

  // Add this helper method to DatabaseServices
  Future<GroupsModel?> getGroupById(String groupId) async {
    try {
      final doc = await _db.collection("events_groups").doc(groupId).get();
      if (doc.exists) {
        return GroupsModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting group by ID: $e');
      return null;
    }
  }

  Future<void> deleteGroup(String groupId) async {
    try {
      // Delete the group document
      await _db.collection("events_groups").doc(groupId).delete();

      // Optional: Delete any related data (like chat messages, members, etc.)
      // await _db.collection("group_chats").doc(groupId).delete();

      print("Group deleted successfully: $groupId");
    } catch (e) {
      print("Error deleting group: $e");
      throw Exception("Failed to delete group: $e");
    }
  }

  Future<void> endEvent(String eventId) async {
    try {
      // Update the event status or mark as ended
      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .delete();
    } catch (e) {
      debugPrint('Error ending event in DB: $e');
      rethrow;
    }
  }

  Future<EventModel?> getEventById(String eventId) async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('events')
              .doc(eventId)
              .get();
      return doc.exists ? EventModel.fromJson(doc.data()!) : null;
    } catch (e) {
      debugPrint('Error getting event by ID: $e');
      return null;
    }
  }

  Future<bool> joinEvent(String eventId, String userId) async {
    try {
      final eventRef = _db.collection('events').doc(eventId);

      await eventRef.update({
        'joinedUsers': FieldValue.arrayUnion([userId]),
      });

      return true;
    } catch (e) {
      debugPrint('Error in joinEvent: $e');
      return false;
    }
  }

  Future<bool> leaveEvent(String eventId, String userId) async {
    try {
      final eventRef = _db.collection('events').doc(eventId);

      await eventRef.update({
        'joinedUsers': FieldValue.arrayRemove([userId]),
      });

      return true;
    } catch (e) {
      debugPrint('Error in leaveEvent: $e');
      return false;
    }
  }

  Future<bool> isUserJoined(String eventId, String userId) async {
    try {
      final doc = await _db.collection('events').doc(eventId).get();

      if (doc.exists) {
        final data = doc.data();
        final joinedUsers = List<String>.from(data?['joinedUsers'] ?? []);
        return joinedUsers.contains(userId);
      }

      return false;
    } catch (e) {
      debugPrint('Error in isUserJoined: $e');
      return false;
    }
  }

  Future<Map<String, int>> getEventSeatData(String eventId) async {
    final doc = await _db.collection('events').doc(eventId).get();
    if (doc.exists) {
      final data = doc.data();
      final capacity = int.tryParse(data?['capacity'] ?? '0') ?? 0;
      final joined = int.tryParse(data?['joiningPeople'] ?? '0') ?? 0;
      return {'capacity': capacity, 'joined': joined};
    }
    return {'capacity': 0, 'joined': 0};
  }

  Future<void> updateSeatCount(String eventId, int newCount) async {
    await _db.collection('events').doc(eventId).update({
      'joiningPeople': newCount.toString(),
    });
  }

  // Helper methods
  Future<String> _getUserName(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data()?['name'] ?? '';
  }

  Future<String> _getUserAvatar(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data()?['profileImageUrl'] ?? '';
  }

  // String _formatTimestamp(Timestamp timestamp) {
  //   final now = DateTime.now();
  //   final date = timestamp.toDate();
  //   final difference = now.difference(date);

  //   if (difference.inMinutes < 1) return 'Just now';
  //   if (difference.inHours < 1) return '${difference.inMinutes}m ago';
  //   if (difference.inDays < 1) return '${difference.inHours}h ago';
  //   return '${difference.inDays}d ago';
  // }

  // ------------------ GROUP CHAT METHODS ------------------

  Future<String> createGroup({
    required String name,
    required String imageUrl,
  }) async {
    try {
      final newGroupRef = _db.collection('groups').doc();

      final groupData = {
        'id': newGroupRef.id,
        'name': name,
        'imageUrl': imageUrl,
        'createdBy': currentUserId,
        'createdAt': FieldValue.serverTimestamp(),
        'members': [currentUserId],
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
      };

      await newGroupRef.set(groupData);

      return newGroupRef.id;
    } catch (e) {
      debugPrint('Error in createGroup: $e');
      rethrow;
    }
  }

  Future<void> joinGroup(String groupId) async {
    try {
      final groupRef = _db.collection('groups').doc(groupId);
      await groupRef.update({
        'members': FieldValue.arrayUnion([currentUserId]),
      });
    } catch (e) {
      debugPrint('Error in joinGroup: $e');
      rethrow;
    }
  }

  Future<void> leaveGroup(String groupId) async {
    try {
      final groupRef = _db.collection('groups').doc(groupId);
      await groupRef.update({
        'members': FieldValue.arrayRemove([currentUserId]),
      });
    } catch (e) {
      debugPrint('Error in leaveGroup: $e');
      rethrow;
    }
  }

  Future<bool> isUserJoinedGroup(String groupId, String userId) async {
    try {
      final doc = await _db.collection('groups').doc(groupId).get();
      if (!doc.exists) {
        debugPrint("Group with ID $groupId does not exist in Firestore.");
        return false;
      }
      final members = List<String>.from(doc['members'] ?? []);
      return members.contains(userId);
    } catch (e) {
      debugPrint('Error in isUserJoinedGroup: $e');
      return false;
    }
  }

  // Make sure sendGroupMessage includes proper sender info
  Future<void> sendGroupMessage({
    required String groupId,
    required String text,
    required String senderName,
    required String senderImageUrl,
  }) async {
    try {
      // Create a batch to perform atomic operations
      final batch = FirebaseFirestore.instance.batch();

      // Reference to the new message
      final messageRef =
          FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .collection('messages')
              .doc();

      // Add the message data
      batch.set(messageRef, {
        'senderId': currentUserId,
        'senderName': senderName,
        'senderImageUrl': senderImageUrl,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update the group's last message info
      final groupRef = FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId);
      batch.update(groupRef, {
        'lastMessage': text,
        'lastMessageSenderName': senderName,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });

      // Commit the batch
      await batch.commit();
    } catch (e) {
      debugPrint('Error sending group message: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getGroupMessagesStream(String groupId) {
    return _db
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<List<Map<String, dynamic>>> getUserGroups() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('groups')
              .where('members', arrayContains: currentUserId)
              .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? 'No Name',
          'imageUrl': data['imageUrl'] ?? '',
          'lastMessage': data['lastMessage'] ?? 'No messages yet',
          'lastMessageTime': data['lastMessageTime'],
          'lastMessageSenderName': data['lastMessageSenderName'] ?? '',
        };
      }).toList();
    } catch (e) {
      debugPrint('Error getting user groups: $e');
      return [];
    }
  }

  Future<String?> createOrGetGroupForEvent(EventModel eventModel) async {
    try {
      final groupId = eventModel.id; // Using event id as group id

      final groupRef = _db.collection('groups').doc(groupId);
      final groupDoc = await groupRef.get();

      if (groupDoc.exists) {
        // Group already exists, just join if not already member
        final members = List<String>.from(groupDoc['members'] ?? []);
        if (!members.contains(currentUserId)) {
          await groupRef.update({
            'members': FieldValue.arrayUnion([currentUserId]),
          });
        }
        return groupId;
      } else {
        // Group doesn’t exist, create it
        final groupData = {
          'id': groupId,
          'name': eventModel.eventName ?? '',
          'imageUrl': eventModel.imageUrl ?? '',
          'createdBy': currentUserId,
          'createdAt': FieldValue.serverTimestamp(),
          'members': [currentUserId],
          'lastMessage': '',
          'lastMessageTime': FieldValue.serverTimestamp(),
        };
        await groupRef.set(groupData);
        return groupId;
      }
    } catch (e) {
      debugPrint('Error in createOrGetGroupForEvent: $e');
      rethrow;
    }
  }

  Future<String?> createOrGetGroup(GroupsModel groupModel) async {
    try {
      final groupId = groupModel.id; // Using event id as group id

      final groupRef = _db.collection('groups').doc(groupId);
      final groupDoc = await groupRef.get();

      if (groupDoc.exists) {
        // Group already exists, just join if not already member
        final members = List<String>.from(groupDoc['members'] ?? []);
        if (!members.contains(currentUserId)) {
          await groupRef.update({
            'members': FieldValue.arrayUnion([currentUserId]),
          });
        }
        return groupId;
      } else {
        // Group doesn’t exist, create it
        final groupData = {
          'id': groupId,
          'name': groupModel.title ?? '',
          'imageUrl': groupModel.imageUrl ?? '',
          'createdBy': currentUserId,
          'createdAt': FieldValue.serverTimestamp(),
          'members': [currentUserId],
          'lastMessage': '',
          'lastMessageTime': FieldValue.serverTimestamp(),
        };
        await groupRef.set(groupData);
        return groupId;
      }
    } catch (e) {
      debugPrint('Error in createOrGetGroupForEvent: $e');
      rethrow;
    }
  }
}
