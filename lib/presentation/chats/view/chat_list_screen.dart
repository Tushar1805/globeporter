import 'package:flutter/material.dart';
import 'package:globeporter/resources/app_widgets.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key, required this.role});
  final String role;

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.35),
        child: CustomStatusBarWidget(title: 'Chats'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chat list'),
          ],
        ),
      ),
    );
  }
}
