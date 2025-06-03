import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/interest_card.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/ui/interests/interest_view_model.dart';
import 'package:provider/provider.dart';

class InterestScreen extends StatelessWidget {
  const InterestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InterestViewModel(),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(130.h), // Adjust height as needed
            child: AppBar(
              automaticallyImplyLeading: false, // if you don’t want back button
              flexibleSpace: Padding(
                padding: EdgeInsets.fromLTRB(
                  8.w,
                  7.h,
                  8.w,
                  0,
                ), // add top padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Interests',
                      style: style25B.copyWith(color: primaryColor),
                    ),
                    8.verticalSpace,
                    Text(
                      'Click your interest to get notifications when \nmentioned in a chat or an event has been set up',
                      style: style14,
                    ),
                    12.verticalSpace,
                    const TabBar(
                      labelColor: primaryColor,
                      unselectedLabelColor: Colors.black,
                      indicatorColor: primaryColor,
                      indicatorWeight: 3,
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(text: 'Outdoors'),
                        Tab(text: 'Indoors'),
                        Tab(text: 'Online'),
                      ],
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
          ),

          body: Column(
            children: [
              10.verticalSpace,
              Expanded(
                child: const TabBarView(
                  children: [OutdoorsTab(), IndoorsTab(), OnlineTab()],
                ),
              ),
              20.verticalSpace,
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: CustomButton(
                    onTap: () {},
                    text: 'Add Interest',
                    backgroundColor: primaryColor,
                  ),
                ),
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

///
///      outdoor tab
///
class OutdoorsTab extends StatelessWidget {
  const OutdoorsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<InterestViewModel>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
          color: whiteColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: ListView.builder(
            itemCount: viewModel.interests.length,
            itemBuilder: (context, index) {
              final interest = viewModel.interests[index];
              return InterestCard(
                interest: interest,
                isSelected: viewModel.selectedIndex == index,
                onTap: () => viewModel.selectInterest(index),
              );
            },
          ),
        ),
      ),
    );
  }
}

///
///      indoor tab
///
class IndoorsTab extends StatelessWidget {
  const IndoorsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<InterestViewModel>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
          color: whiteColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: ListView.builder(
            itemCount: viewModel.interests.length,
            itemBuilder: (context, index) {
              final interest = viewModel.interests[index];
              return InterestCard(
                interest: interest,
                isSelected: viewModel.selectedIndex == index,
                onTap: () => viewModel.selectInterest(index),
              );
            },
          ),
        ),
      ),
    );
  }
}

///
///      online tab
///
class OnlineTab extends StatelessWidget {
  const OnlineTab({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<InterestViewModel>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
          color: whiteColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: ListView.builder(
            itemCount: viewModel.interests.length,
            itemBuilder: (context, index) {
              final interest = viewModel.interests[index];
              return InterestCard(
                interest: interest,
                isSelected: viewModel.selectedIndex == index,
                onTap: () => viewModel.selectInterest(index),
              );
            },
          ),
        ),
      ),
    );
  }
}
