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
  Future<List<EventModel>> getUpcomingEvents(EventModel eventModel) async {
    try {
      final snapshot = await _db.collection('events').orderBy('date').get();

      if (snapshot.docs.isEmpty) {
        debugPrint('No events found in Firestore');
        return [];
      }

      debugPrint('Fetched ${snapshot.docs.length} events from Firestore');

      final events =
          snapshot.docs.map((doc) {
            debugPrint('Document data: ${doc.data()}');
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
