import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/core/model/event_model.dart';
import 'package:girl_clan/core/others/base_view_model.dart';
import 'package:girl_clan/core/services/data_base_services.dart';
import 'package:girl_clan/locator.dart';
import 'package:girl_clan/ui/root_screen/root_screen.dart';

class HomeViewModel extends BaseViewModel {
  EventModel eventModel = EventModel();
  final db = locator<DatabaseServices>();

  ///
  ///      up coming events
  ///
  List<EventModel> upcomingEventsList = [];

  ///
  ///
  ///

  Future<void> init() async {
    setState(ViewState.busy);
    try {
      upcomingEventsList = await db.getUpcomingEvents(eventModel);
      debugPrint('Fetched ${upcomingEventsList.length} events in ViewModel');
      notifyListeners();

      if (upcomingEventsList.isEmpty) {
        Get.snackbar('No Events', "No upcoming events found");
      }
    } catch (e) {
      debugPrint('Error initializing HomeViewModel: $e');
      Get.snackbar('Error', "Failed to load events");
    } finally {
      setState(ViewState.idle);
    }
  }

  ///
  ///
  ///
  // List<EventModel> UpComingEventsList = [
  //   EventModel(
  //     id: '1',
  //     eventName: 'Discover the World',
  //     location: 'location',
  //     date: '12/03/2024',
  //     startTime: '45/05',
  //     category: 'Hiking',
  //     imageUrl: AppAssets().loginImage,
  //     joiningPeople: '10',
  //     availablePeople: '3',
  //     capacity: '5000',
  //   ),
  //   EventModel(
  //     id: '1',
  //     eventName: 'Discover the World',
  //     location: 'location',
  //     date: '12/03/2024',
  //     startTime: '45/05',
  //     category: 'Hiking',
  //     imageUrl: AppAssets().loginImage,
  //     joiningPeople: '10',
  //     availablePeople: '3',
  //     capacity: '5000',
  //   ),
  //   EventModel(
  //     id: '1',
  //     eventName: 'Discover the World',
  //     location: 'location',
  //     date: '12/03/2024',
  //     startTime: '45/05',
  //     category: 'Hiking',
  //     imageUrl: AppAssets().loginImage,
  //     joiningPeople: '10',
  //     availablePeople: '3',
  //     capacity: '5000',
  //   ),
  //   EventModel(
  //     id: '1',
  //     eventName: 'Discover the World',
  //     location: 'location',
  //     date: '12/03/2024',
  //     startTime: '45/05',
  //     category: 'Hiking',
  //     imageUrl: AppAssets().loginImage,
  //     joiningPeople: '10',
  //     availablePeople: '3',
  //     capacity: '5000',
  //   ),
  //   // UpComingEventsCardModel(
  //   //   title: "urban beast",
  //   //   date: "12/01/2025",
  //   //   location: "Tofino, British Co ...",
  //   //   imageUrl: AppAssets().loginImage,
  //   //   ratio: "06/10",
  //   // ),
  // ];

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
