import 'package:flutter/material.dart';
import 'package:girl_clan/ui/options/events/events_view_model.dart';
import 'package:provider/provider.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventsViewModel(),
      child: Consumer<EventsViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(title: Text("Events")),
            body: Center(child: Text("Events Screen Content Here")),
          );
        },
      ),
    );
  }
}
