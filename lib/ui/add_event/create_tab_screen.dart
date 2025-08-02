import 'package:flutter/material.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/ui/add_event/create_events.dart/create_event_screen.dart';
import 'package:girl_clan/ui/add_event/create_groups/create_group_screen.dart';

class CreateTabScreen extends StatefulWidget {
  const CreateTabScreen({super.key});

  @override
  State<CreateTabScreen> createState() => _CreateTabScreenState();
}

class _CreateTabScreenState extends State<CreateTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _titles = ["Create Event", "Create Group"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // update title on tab change
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_tabController.index]),
        bottom: TabBar(
          unselectedLabelColor: blackColor,
          labelStyle: style16B.copyWith(color: primaryColor),
          dividerColor: primaryColor,
          labelColor: primaryColor,
          controller: _tabController,
          indicatorColor: primaryColor,
          tabs: const [Tab(text: 'Create Event'), Tab(text: 'Create Group')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [AddEventScreen(), CreateGroupScreen()],
      ),
    );
  }
}
