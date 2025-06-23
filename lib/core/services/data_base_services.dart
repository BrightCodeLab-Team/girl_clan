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
  Future<List<EventModel>> getUpcomingEvents() async {
    try {
      // Get current date and calculate next week's date
      final currentDate = DateTime.now();
      final nextWeekDate = currentDate.add(const Duration(days: 7));

      // Format dates to match your Firestore format (YYYY/MM/DD)
      final formattedCurrentDate =
          "${currentDate.year}/${currentDate.month}/${currentDate.day}";
      final formattedNextWeekDate =
          "${nextWeekDate.year}/${nextWeekDate.month}/${nextWeekDate.day}";

      // Query events between today and next week
      final snapshot =
          await _db
              .collection('events')
              .where('date', isGreaterThanOrEqualTo: formattedCurrentDate)
              .where('date', isLessThanOrEqualTo: formattedNextWeekDate)
              .orderBy('date')
              .get();

      if (snapshot.docs.isEmpty) {
        debugPrint('No upcoming events found in Firestore');
        return [];
      }

      debugPrint(
        'Fetched ${snapshot.docs.length} upcoming events from Firestore',
      );

      final events =
          snapshot.docs.map((doc) {
            debugPrint('Upcoming event data: ${doc.data()}');
            return EventModel.fromJson(doc.data());
          }).toList();

      return events;
    } catch (e, s) {
      debugPrint('Exception @DatabaseService/getUpcomingEvents: $e');
      debugPrint(s.toString());
      return [];
    }
  }
}
