import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/ui/root_screen/root_view_model.dart';
import 'package:provider/provider.dart';

class RootScreen extends StatelessWidget {
  final int? selectedScreen;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  RootScreen({super.key, this.selectedScreen = 0});

  @override
  Widget build(BuildContext context) {
    return Consumer<RootScreenViewModel>(
      builder:
          (context, model, child) => Scaffold(
            key: _scaffoldKey,

            ///
            /// Start Body
            ///
            body: model.allScreen[model.selectedScreen],

            ///
            /// BottomBar with BoxShadow
            ///
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.1), // Soft shadow
                    offset: Offset(0, 2),
                    blurRadius: 10,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: BottomNavigationBar(
                backgroundColor: whiteColor,
                currentIndex: model.selectedScreen,
                onTap: (index) => model.updatedScreen(index),
                type: BottomNavigationBarType.fixed,
                selectedFontSize: 0,
                unselectedFontSize: 0,
                selectedItemColor: darkPurpleColor,
                unselectedItemColor: darkGreyColor,
                items: List.generate(3, (index) {
                  final isSelected = model.selectedScreen == index;
                  return BottomNavigationBarItem(
                    label: '',
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(
                            height: 40.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color:
                                  isSelected
                                      // ignore: deprecated_member_use
                                      ? primaryColor
                                      : whiteColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    model.tabIcons[index],
                                    scale: 4,
                                    color: isSelected ? whiteColor : blackColor,
                                  ),
                                  5.horizontalSpace,
                                  Text(
                                    model.tabTitlesList[index],
                                    style: style14B.copyWith(
                                      color: whiteColor,
                                      // fontSize: 10,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
    );
  }
}
