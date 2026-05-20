import 'package:flutter/material.dart';
import 'package:girl_clan/ui/my_self_events/my_selef_events_view_model.dart';
import 'package:provider/provider.dart';

class MySelfEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MySelefEventsViewModel(),
      child: Consumer<MySelefEventsViewModel>(
        builder:
            (context, model, child) => Scaffold(
              ///
              /// Start Body
              ///
              body: Column(children: [

    ],),
            ),
      ),
    );
  }
}
