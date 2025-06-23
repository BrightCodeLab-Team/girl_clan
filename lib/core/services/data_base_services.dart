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
  ///. ad event details to database
  addEventsToDataBase(EventModel eventModel) async {
    try {
      // on both (set & add) it is not storing data in database

      await _db
          .collection('events')
          // .doc(eventModel.id)
          // .set(eventModel.toJson())
          .add(eventModel.toJson())
          .then((value) => debugPrint('user registered successfully'));
    } catch (e, s) {
      debugPrint('Exception @DatabaseService/addEvent');
      debugPrint(s.toString());
      return false;
    }
  }

  ///
  ///. get upcomingEvents events from database.
  ///

  // Future<List<EventModel>> getUpcomingEvents(EventModel eventModel) async {
  //   try {
  //     final currentDate = DateTime.now();
  //     final formattedCurrentDate =
  //         "${currentDate.year}/${currentDate.month}/${currentDate.day}";

  //     final snapshot =
  //         await _db
  //             .collection('events')
  //             // .where('date', isGreaterThanOrEqualTo: formattedCurrentDate)
  //             .orderBy('date')
  //             .get();

  //     return snapshot.docs
  //         .map((doc) => EventModel.fromJson(doc.data()))
  //         .toList();
  //   } catch (e, s) {
  //     debugPrint('Exception @DatabaseService/getUpcomingEvents');
  //     debugPrint(s.toString());
  //     return [];
  //   }
  // }
  ///
  ///
  ///
  ///
  Future<List<EventModel>> getUpcomingEvents() async {
    try {
      final currentDate = DateTime.now();
      final nextWeekDate = currentDate.add(const Duration(days: 7));

      // Format dates as strings for comparison (YYYY/MM/DD)
      final formattedCurrentDate =
          "${currentDate.year}/${currentDate.month.toString().padLeft(2, '0')}/${currentDate.day.toString().padLeft(2, '0')}";
      final formattedNextWeekDate =
          "${nextWeekDate.year}/${nextWeekDate.month.toString().padLeft(2, '0')}/${nextWeekDate.day.toString().padLeft(2, '0')}";

      debugPrint(
        'Querying events between $formattedCurrentDate and $formattedNextWeekDate',
      );

      final snapshot =
          await _db
              .collection('events')
              // .where('date', isGreaterThanOrEqualTo: formattedCurrentDate)
              // .where('date', isLessThanOrEqualTo: formattedNextWeekDate)
              .orderBy('date')
              .get();

      debugPrint('Found ${snapshot.docs.length} documents');

      final events = <EventModel>[];

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
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
      final snapshot = await _db.collection('events').get();

      debugPrint('Found ${snapshot.docs.length} events');

      final events =
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
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
}
