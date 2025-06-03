import 'package:flutter/material.dart';
import 'package:girl_clan/ui/options/chat/chat_view_model.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatViewModel(),
      child: Consumer<ChatViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(title: Text("Chat")),
            body: Center(child: Text("Chat Screen Content Here")),
          );
        },
      ),
    );
  }
}
