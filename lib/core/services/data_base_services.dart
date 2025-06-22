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
  addEventsToDataBase(EventModel eventModel) async {
    try {
      // on both (set & add) it is not storing data in database

      await _db
          .collection('events')
          // .doc(eventModel.id)
          .add(eventModel.toJson())
          .then((value) => debugPrint('user registered successfully'));
    } catch (e, s) {
      debugPrint('Exception @DatabaseService/addEvent');
      debugPrint(s.toString());
      return false;
    }
  }
}
