import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:girl_clan/core/model/event_model.dart';

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
}
