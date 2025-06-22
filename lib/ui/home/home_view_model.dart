import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/model/event_model.dart';
import 'package:girl_clan/core/model/home_top_picks.dart';
import 'package:girl_clan/core/model/up_coming_evnts.dart';
import 'package:girl_clan/core/others/base_view_model.dart';

class HomeViewModel extends BaseViewModel {
  ///
  ///      up coming events
  ///
  List<EventModel> UpComingEventsList = [
    EventModel(
      id: '1',
      eventName: 'Discover the World',
      location: 'location',
      date: '12/03/2024',
      startTime: '45/05',
      category: 'Hiking',
      imageUrl: AppAssets().loginImage,
      joiningPeople: 12,
      availablePeople: 5,
    ),
    EventModel(
      id: '1',
      eventName: 'Discover the World',
      location: 'location',
      date: '12/03/2024',
      startTime: '45/05',
      category: 'Hiking',
      imageUrl: AppAssets().loginImage,
      joiningPeople: 12,
      availablePeople: 5,
    ),
    EventModel(
      id: '1',
      eventName: 'Discover the World',
      location: 'location',
      date: '12/03/2024',
      startTime: '45/05',
      category: 'Hiking',
      imageUrl: AppAssets().loginImage,
      joiningPeople: 12,
      availablePeople: 5,
    ),
    EventModel(
      id: '1',
      eventName: 'Discover the World',
      location: 'location',
      date: '12/03/2024',
      startTime: '45/05',
      category: 'Hiking',
      imageUrl: AppAssets().loginImage,
      joiningPeople: 12,
      availablePeople: 5,
    ),
    EventModel(
      id: '1',
      eventName: 'Discover the World',
      location: 'location',
      date: '12/03/2024',
      startTime: '45/05',
      category: 'Hiking',
      imageUrl: AppAssets().loginImage,
      joiningPeople: 12,
      availablePeople: 5,
    ),
    EventModel(
      id: '1',
      eventName: 'Discover the World',
      location: 'location',
      date: '12/03/2024',
      startTime: '45/05',
      category: 'Hiking',
      imageUrl: AppAssets().loginImage,
      joiningPeople: 12,
      availablePeople: 5,
    ),
    EventModel(
      id: '1',
      eventName: 'Discover the World',
      location: 'location',
      date: '12/03/2024',
      startTime: '45/05',
      category: 'Hiking',
      imageUrl: AppAssets().loginImage,
      joiningPeople: 12,
      availablePeople: 5,
    ),

    // UpComingEventsCardModel(
    //   title: "urban beast",
    //   date: "12/01/2025",
    //   location: "Tofino, British Co ...",
    //   imageUrl: AppAssets().loginImage,
    //   ratio: "06/10",
    // ),
  ];

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
      joiningPeople: 12,
      availablePeople: 5,
    ),
    EventModel(
      id: '1',
      eventName: 'Discover the World',
      location: 'location',
      date: '12/03/2024',
      startTime: '45/05',
      category: 'Hiking',
      imageUrl: AppAssets().loginImage,
      joiningPeople: 12,
      availablePeople: 5,
    ),
    EventModel(
      id: '1',
      eventName: 'Discover the World',
      location: 'location',
      date: '12/03/2024',
      startTime: '45/05',
      category: 'Hiking',
      imageUrl: AppAssets().loginImage,
      joiningPeople: 12,
      availablePeople: 5,
    ),
    EventModel(
      id: '1',
      eventName: 'Discover the World',
      location: 'location',
      date: '12/03/2024',
      startTime: '45/05',
      category: 'Hiking',
      imageUrl: AppAssets().loginImage,
      joiningPeople: 12,
      availablePeople: 5,
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
