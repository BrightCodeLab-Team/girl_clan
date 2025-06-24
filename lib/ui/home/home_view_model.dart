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
  List<EventModel> hikingList = [];
  List<EventModel> concertList = [];
  List<EventModel> partyList = [];
  List<EventModel> workshopList = [];
  List<EventModel> sportsList = [];
  List<EventModel> artExhibitionsList = [];

  HomeViewModel() {
    upComingEvents();
    getAllEvents();
    getHikingEvents();
    getConcertEvents();
    getPartyEvents();
    getWorkShopEvents();
    getSportsEvents();
    getArtExhibitionsEvents();
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
  ///. hiking events
  ///
  Future<void> getHikingEvents() async {
    setState(ViewState.busy);
    try {
      allEventsList = await db.getHikingEvents(eventModel);
      debugPrint('Successfully fetched ${allEventsList.length} events');
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching all events: $e');
    } finally {
      setState(ViewState.idle);
    }
  }

  ///
  ///. concert events
  ///
  Future<void> getConcertEvents() async {
    setState(ViewState.busy);
    try {
      allEventsList = await db.getConcertEvents(eventModel);
      debugPrint('Successfully fetched ${allEventsList.length} events');
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching all events: $e');
    } finally {
      setState(ViewState.idle);
    }
  }

  ///
  ///. party events
  ///
  Future<void> getPartyEvents() async {
    setState(ViewState.busy);
    try {
      allEventsList = await db.getPartyEvents(eventModel);
      debugPrint('Successfully fetched ${allEventsList.length} events');
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching all events: $e');
    } finally {
      setState(ViewState.idle);
    }
  }

  ///
  ///. workshop events
  ///
  Future<void> getWorkShopEvents() async {
    setState(ViewState.busy);
    try {
      allEventsList = await db.getWorkShopEvents(eventModel);
      debugPrint('Successfully fetched ${allEventsList.length} events');
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching all events: $e');
    } finally {
      setState(ViewState.idle);
    }
  }

  ///
  ///. sports events
  ///
  Future<void> getSportsEvents() async {
    setState(ViewState.busy);
    try {
      allEventsList = await db.getSportsEvents(eventModel);
      debugPrint('Successfully fetched ${allEventsList.length} events');
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching all events: $e');
    } finally {
      setState(ViewState.idle);
    }
  }

  ///
  ///. art exhibitions events
  ///
  Future<void> getArtExhibitionsEvents() async {
    setState(ViewState.busy);
    try {
      allEventsList = await db.getArtExhibitionsEvents(eventModel);
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
  selectedTabFunction(index) {
    selectedTabIndex = index;
    notifyListeners();
  }
}
