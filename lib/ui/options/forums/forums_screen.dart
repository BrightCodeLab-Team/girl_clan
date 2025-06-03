import 'package:flutter/material.dart';
import 'package:girl_clan/ui/options/forums/forums_view_model.dart';
import 'package:provider/provider.dart';

class ForumsScreen extends StatelessWidget {
  const ForumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ForumsViewModel(),
      child: Consumer<ForumsViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(title: Text("Forums")),
            body: Center(child: Text("Forums Screen Content Here")),
          );
        },
      ),
    );
  }
}
