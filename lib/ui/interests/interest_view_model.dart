import 'package:flutter/material.dart';
import 'package:girl_clan/core/constants/app_assest.dart';
import 'package:girl_clan/core/model/interest_model.dart';

class InterestViewModel extends ChangeNotifier {
  final List<InterestModel> _interests = [
    InterestModel(title: 'Board Games', imageUrl: AppAssets().loginImage),
    InterestModel(title: 'Drinks', imageUrl: AppAssets().loginImage),
    InterestModel(title: 'Book Club', imageUrl: AppAssets().loginImage),
    InterestModel(title: 'Gym', imageUrl: AppAssets().loginImage),
    InterestModel(title: 'Cooking', imageUrl: AppAssets().loginImage),
  ];

  List<InterestModel> get interests => _interests;

  int _selectedIndex = -1;
  int get selectedIndex => _selectedIndex;

  void selectInterest(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
