import 'package:flutter/material.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/core/others/base_view_model.dart';
import 'package:girl_clan/ui/chat/main_chat/main_chat_screen.dart';
import 'package:girl_clan/ui/home/home_screen.dart';
import 'package:girl_clan/ui/profile/profile_screen.dart';

class RootScreenViewModel extends BaseViewModel {
  int selectedScreen = 0;

  List<String> tabTitlesList = ['Home', 'Chat', 'Profile'];
  List<String> tabIcons = [
    AppAssets().homeIcon,
    AppAssets().chatIcon,
    AppAssets().profileIcon,
  ];

  List<Widget> allScreen = [HomeScreen(), MainChatScreen(), ProfileScreen()];

  RootScreenViewModel({this.selectedScreen = 0});

  void updatedScreen(int index) {
    setState(ViewState.busy);
    selectedScreen = index;
    setState(ViewState.idle);
    notifyListeners();
  }
}
