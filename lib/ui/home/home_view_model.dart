// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/core/model/event_model.dart';
import 'package:girl_clan/core/others/base_view_model.dart';
import 'package:girl_clan/core/services/data_base_services.dart';
import 'package:girl_clan/locator.dart';

class HomeViewModel extends BaseViewModel {
  EventModel eventModel = EventModel();
  final db = locator<DatabaseServices>();
  final currentUser = FirebaseAuth.instance;

  final List<Map<String, dynamic>> tabs = [
    {'icon': Icons.apps, 'text': 'All'},
    {'icon': Icons.hiking, 'text': 'Hiking'},
    {'icon': Icons.music_note, 'text': 'Concert'},
    {'icon': Icons.music_note, 'text': 'Party'},
    {'icon': Icons.music_note, 'text': 'Workshop'},
    {'icon': Icons.music_note, 'text': 'Sports'},
    {'icon': Icons.music_note, 'text': 'Art Exhibitions'},
  ];

  ///
  ///      up coming events
  ///
  List<EventModel> upcomingEventsList = [];
  List<EventModel> allEventsList = [];
  List<EventModel> currentUserEventsList = [];

  ///
  ///. constructor if not use then no data fetching
  ///
  HomeViewModel() {
    upComingEvents();
    getAllEvent(tabs[selectedTabIndex]['text']); // Pass "All"
    getCurrentUserEvents();
  }

  ///
  ///. refresh all events to get latest data
  ///
  Future<void> refreshAllEvents() async {
    await upComingEvents();
    await getAllEvent("$selectedTabIndex");
    await getCurrentUserEvents();
    notifyListeners();
  }

  ///
  ///. all current user events
  ///
  getCurrentUserEvents() async {
    setState(ViewState.busy);
    try {
      if (currentUser != null) {
        currentUserEventsList = await db.getCurrentUserEvents(
          currentUser.currentUser!.uid,
        ); // Pass UID only
        debugPrint(
          'Fetched ${currentUserEventsList.length} current user events',
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching current user events: $e');
    } finally {
      setState(ViewState.idle);
    }
  }

  ///
  /// let debug first fetch all events from the database then classify them
  ///

  Future<void> upComingEvents() async {
    setState(ViewState.busy);
    try {
      upcomingEventsList = await db.getUpcomingEvents();
      debugPrint('Successfully fetched ${upcomingEventsList.length} events');

      // Debug print all event names and dates
      for (var event in upcomingEventsList) {
        debugPrint('Event: ${event.eventName}, Date: ${event.date}');
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error in init: $e');
      //Get.snackbar('Error', 'Failed to load events');
    } finally {
      setState(ViewState.idle);
    }
  }

  ///
  ///.  get all events from database
  ///
  Future<void> getAllEvent(String? category) async {
    setState(ViewState.busy);
    try {
      allEventsList = await db.getAllEventsByCategory("$category");
      debugPrint('Successfully fetched ${allEventsList.length} events');
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching all events: $e');
    } finally {
      setState(ViewState.idle);
    }
  }

  ///
  ///     tabs
  ///
  int selectedTabIndex = 0;
  selectedTabFunction(int index) {
    selectedTabIndex = index;

    final selectedCategory = tabs[index]['text'];

    getAllEvent(selectedCategory); // fetch events by category

    notifyListeners();
  }

  ////
  /// JOIN EVENTS AND LEAVE EVENTS
  ///
  Future<void> joinEvent(String eventId) async {
    setState(ViewState.busy);
    try {
      final isAlreadyJoined = await db.isUserJoined(
        eventId,
        currentUser.currentUser!.uid,
      );

      if (!isAlreadyJoined) {
        await db.joinEvent(eventId, currentUser.currentUser!.uid);
        await refreshAllEvents(); // To refresh local lists
      }
    } catch (e) {
      debugPrint("Error joining event: $e");
    } finally {
      setState(ViewState.idle);
    }
  }

  Future<void> leaveEvent(String eventId) async {
    setState(ViewState.busy);
    try {
      await db.leaveEvent(eventId, currentUser.currentUser!.uid);
      await refreshAllEvents();
    } catch (e) {
      debugPrint("Error leaving event: $e");
    } finally {
      setState(ViewState.idle);
    }
  }

  /// Get seat data (capacity & joined) from DatabaseServices
  Future<Map<String, int>> getEventSeatData(String eventId) async {
    try {
      return await db.getEventSeatData(eventId);
    } catch (e) {
      debugPrint('Error getting event seat data: $e');
      return {'capacity': 0, 'joined': 0};
    }
  }

  /// Update the seat count in Firestore via DatabaseServices
  Future<void> updateSeatCount(String eventId, int newCount) async {
    try {
      await db.updateSeatCount(eventId, newCount);
    } catch (e) {
      debugPrint('Error updating seat count: $e');
    }
  }

  Future<bool> hasUserJoined(String eventId) async {
    try {
      return await db.isUserJoined(eventId, currentUser.currentUser!.uid);
    } catch (e) {
      debugPrint("Error checking joined status: $e");
      return false;
    }
  }

  // Call this once when you load data (from API / Firebase)
  void loadEvents(List<EventModel> events) {
    allEventsList = events;
    upcomingEventsList = List.from(allEventsList);
    notifyListeners();
  }

  void searchEvents(String query) {
    if (query.isEmpty) {
      upcomingEventsList = List.from(allEventsList);
    } else {
      final lowerQuery = query.toLowerCase();
      upcomingEventsList =
          allEventsList.where((event) {
            return (event.eventName?.toLowerCase().contains(lowerQuery) ??
                    false) ||
                (event.category?.toLowerCase().contains(lowerQuery) ?? false) ||
                (event.location?.toLowerCase().contains(lowerQuery) ?? false);
          }).toList();
    }
    notifyListeners();
  }

  void applyFilter({String? category, String? date, String? location}) {
    upcomingEventsList =
        allEventsList.where((event) {
          final matchCategory = category == null || event.category == category;
          final matchDate = date == null || event.date == date;
          final matchLocation =
              location == null || event.location!.contains(location);
          return matchCategory && matchDate && matchLocation;
        }).toList();
    notifyListeners();
  }

  void resetFilters() {
    upcomingEventsList = List.from(allEventsList);
    notifyListeners();
  }

  @override
  void dispose() {
    resetFilters();
    super.dispose();
  }
}
