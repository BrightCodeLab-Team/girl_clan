import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
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
  List<EventModel> currentUserEventsList = [];

  ///
  ///. constructor if not use then no data fetching
  ///
  HomeViewModel() {
    upComingEvents();
    getAllEvents();
    getHikingEvents();
    getConcertEvents();
    getPartyEvents();
    getWorkShopEvents();
    getSportsEvents();
    getArtExhibitionsEvents();
    getCurrentUserEvents();
  }

  ///
  ///. refresh all events to get latest data
  ///
  Future<void> refreshAllEvents() async {
    await upComingEvents();
    await getAllEvents();
    await getHikingEvents();
    await getConcertEvents();
    await getPartyEvents();
    await getWorkShopEvents();
    await getSportsEvents();
    await getArtExhibitionsEvents();
    getCurrentUserEvents();
    notifyListeners();
  }

  ///
  ///. all current user events
  ///
  Future<void> getCurrentUserEvents() async {
    setState(ViewState.busy);
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        currentUserEventsList = await db.getCurrentUserEvents(
          currentUser.uid,
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
      hikingList = await db.getHikingEvents(eventModel);
      debugPrint('Successfully fetched ${hikingList.length} events');
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching hiking events: $e');
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
      concertList = await db.getConcertEvents(eventModel);
      debugPrint('Successfully fetched ${concertList.length} events');
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching concert events: $e');
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
      partyList = await db.getPartyEvents(eventModel);
      debugPrint('Successfully fetched ${partyList.length} events');
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching party events: $e');
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
      workshopList = await db.getWorkShopEvents(eventModel);
      debugPrint('Successfully fetched ${workshopList.length} events');
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching work shop events: $e');
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
      sportsList = await db.getSportsEvents(eventModel);
      debugPrint('Successfully fetched ${sportsList.length} events');
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching sports events: $e');
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
      artExhibitionsList = await db.getArtExhibitionsEvents(eventModel);
      debugPrint('Successfully fetched ${artExhibitionsList.length} events');
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching art exhibitions events: $e');
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
