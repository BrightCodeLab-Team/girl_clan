import 'package:flutter/material.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/core/others/base_view_model.dart';
import 'package:girl_clan/ui/chat/new_chat/main_chat_screen.dart';
import 'package:girl_clan/ui/home/home_screen.dart';
import 'package:girl_clan/ui/home/home_view_model.dart';
import 'package:girl_clan/ui/profile/profile_screen.dart';

class RootScreenViewModel extends BaseViewModel {
  int selectedScreen = 0;

  ///
  ///     bottom navigator bottom bar
  ///
  List<String> tabTitlesList = ['Home', 'Chat', 'Profile'];
  List<String> tabIcons = [
    AppAssets().homeIcon,
    AppAssets().chatIcon,
    AppAssets().profileIcon,
  ];

  List<Widget> allScreen = [HomeScreen(), MainChatScreen(), ProfileScreen()];

  ///
  /// Constructor
  ///
  // ignore: non_constant_identifier_names
  RootViewModel(val) {
    updatedScreen(val);
    notifyListeners();
  }

  updatedScreen(int index) {
    setState(ViewState.busy);
    selectedScreen = index;
    setState(ViewState.idle);
    notifyListeners();
  }


}
