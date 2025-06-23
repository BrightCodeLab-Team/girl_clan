import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/core/model/event_model.dart';
import 'package:girl_clan/core/others/base_view_model.dart';
import 'package:girl_clan/core/services/data_base_services.dart';
import 'package:girl_clan/locator.dart';

class HomeViewModel extends BaseViewModel {
  EventModel eventModel = EventModel();
  final db = locator<DatabaseServices>();

  ///
  ///      up coming events
  ///
  List<EventModel> upcomingEventsList = [];
  List<EventModel> allEventsList = [];

  ///
  /// let debug first fetch all events from the database then classify them
  ///

  Future<void> init() async {
    setState(ViewState.busy);
    try {
      upcomingEventsList = await db.getUpcomingEvents();
      debugPrint('Successfully fetched ${upcomingEventsList.length} events');

      // Debug print all event names and dates
      for (var event in upcomingEventsList) {
        debugPrint('Event: ${event.eventName}, Date: ${event.date}');
      }

      notifyListeners();

      if (upcomingEventsList.isEmpty) {
        Get.snackbar('Info', 'No upcoming events found');
      }
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
  Future<void> getAllEvents() async {
    setState(ViewState.busy);
    try {
      allEventsList = await db.getAllEvents(eventModel);
      debugPrint('Successfully fetched ${allEventsList.length} events');
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching all events: $e');
    } finally {
      setState(ViewState.idle);
    }
  }

  ///
  ///
  ///

  ///
  ///     top picks
  ///
  int selectedTabIndex = 0;
  selectedTabFunction(index) {
    selectedTabIndex = index;
    notifyListeners();
  }

  ///
  ///
  List<EventModel> TopPickEventsList = [
    EventModel(
      id: '1',
      eventName: 'Discover the World',
      location: 'location',
      date: '12/03/2024',
      startTime: '45/05',
      category: 'Hiking',
      imageUrl: AppAssets().loginImage,
      joiningPeople: '10',
      availablePeople: '3',
      capacity: '5000',
    ),
    EventModel(
      id: '1',
      eventName: 'Discover the World',
      location: 'location',
      date: '12/03/2024',
      startTime: '45/05',
      category: 'Hiking',
      imageUrl: AppAssets().loginImage,
      joiningPeople: '10',
      availablePeople: '3',
      capacity: '5000',
    ),
    EventModel(
      id: '1',
      eventName: 'Discover the World',
      location: 'location',
      date: '12/03/2024',
      startTime: '45/05',
      category: 'Hiking',
      imageUrl: AppAssets().loginImage,
      joiningPeople: '10',
      availablePeople: '3',
      capacity: '5000',
    ),
    EventModel(
      id: '1',
      eventName: 'Discover the World',
      location: 'location',
      date: '12/03/2024',
      startTime: '45/05',
      category: 'Hiking',
      imageUrl: AppAssets().loginImage,
      joiningPeople: '10',
      availablePeople: '3',
      capacity: '5000',
    ),
    EventModel(
      id: '1',
      eventName: 'Discover the World',
      location: 'location',
      date: '12/03/2024',
      startTime: '45/05',
      category: 'Hiking',
      imageUrl: AppAssets().loginImage,
      joiningPeople: '10',
      availablePeople: '3',
      capacity: '5000',
    ),

    // TopPicksCardModel(
    //   title: "Wanderlight Festival",
    //   imageUrl: AppAssets().loginImage,
    //   category: 'Hiking',
    //   location: 'Northern Mountains',
    //   joined: '12/25 Joined',
    //   date: '12/12/2025',
    // ),
  ];
}
