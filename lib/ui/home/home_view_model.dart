import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/model/home_top_picks.dart';
import 'package:girl_clan/core/model/up_coming_evnts.dart';
import 'package:girl_clan/core/others/base_view_model.dart';

class HomeViewModel extends BaseViewModel {
  ///
  ///      up coming events
  ///
  List<UpComingEventsCardModel> UpComingEventsList = [
    UpComingEventsCardModel(
      title: "urban beast",
      date: "12/01/2025",
      location: "Tofino, British Co ...",
      imageUrl: AppAssets().loginImage,
      ratio: "06/10",
    ),
    UpComingEventsCardModel(
      title: "urban beast",
      date: "12/01/2025",
      location: "Tofino, British Co ...",
      imageUrl: AppAssets().loginImage,
      ratio: "06/10",
    ),
    UpComingEventsCardModel(
      title: "urban beast",
      date: "12/01/2025",
      location: "Tofino, British Co ...",
      imageUrl: AppAssets().loginImage,
      ratio: "06/10",
    ),
    UpComingEventsCardModel(
      title: "urban beast",
      date: "12/01/2025",
      location: "Tofino, British Co ...",
      imageUrl: AppAssets().loginImage,
      ratio: "06/10",
    ),
    UpComingEventsCardModel(
      title: "urban beast",
      date: "12/01/2025",
      location: "Tofino, British Co ...",
      imageUrl: AppAssets().loginImage,
      ratio: "06/10",
    ),
    UpComingEventsCardModel(
      title: "urban beast",
      date: "12/01/2025",
      location: "Tofino, British Co ...",
      imageUrl: AppAssets().loginImage,
      ratio: "06/10",
    ),
    UpComingEventsCardModel(
      title: "urban beast",
      date: "12/01/2025",
      location: "Tofino, British Co ...",
      imageUrl: AppAssets().loginImage,
      ratio: "06/10",
    ),
    UpComingEventsCardModel(
      title: "urban beast",
      date: "12/01/2025",
      location: "Tofino, British Co ...",
      imageUrl: AppAssets().loginImage,
      ratio: "06/10",
    ),
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
  List<TopPicksCardModel> TopPickEventsList = [
    TopPicksCardModel(
      title: "Wanderlight Festival",
      imageUrl: AppAssets().loginImage,
      category: 'Hiking',
      location: 'Northern Mountains',
      joined: '12/25 Joined',
      date: '12/12/2025',
    ),
    TopPicksCardModel(
      title: "Wanderlight Festival",
      imageUrl: AppAssets().loginImage,
      category: 'Hiking',
      location: 'Northern Mountains',
      joined: '12/25 Joined',
      date: '12/12/2025',
    ),
    TopPicksCardModel(
      title: "Wanderlight Festival",
      imageUrl: AppAssets().loginImage,
      category: 'Hiking',
      location: 'Northern Mountains',
      joined: '12/25 Joined',
      date: '12/12/2025',
    ),
    TopPicksCardModel(
      title: "Wanderlight Festival",
      imageUrl: AppAssets().loginImage,
      category: 'Hiking',
      location: 'Northern Mountains',
      joined: '12/25 Joined',
      date: '12/12/2025',
    ),
    TopPicksCardModel(
      title: "Wanderlight Festival",
      imageUrl: AppAssets().loginImage,
      category: 'Hiking',
      location: 'Northern Mountains',
      joined: '12/25 Joined',
      date: '12/12/2025',
    ),
  ];
}
