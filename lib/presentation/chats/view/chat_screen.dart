import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/chats/model/chat_model.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String driverId;
  final String customerId;
  final String type;
  final String name;

  const ChatScreen(
      {super.key,
      required this.driverId,
      required this.customerId,
      required this.type,
      required this.name});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late DatabaseReference _chatRef;
  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();
    final conversationId = '${widget.driverId}_${widget.customerId}';
    _chatRef = FirebaseDatabase.instance.ref().child('chats/$conversationId');
    _listenToMessages();
  }

  void _listenToMessages() {
    _chatRef.onChildAdded.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      final message = ChatMessage.fromMap(data);
      setState(() {
        messages.add(message);
      });
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    final newMessage = ChatMessage(
      senderId: widget.driverId,
      receiverId: widget.customerId,
      message: messageText,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    _chatRef.push().set(newMessage.toMap());
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      top: false,
      right: false,
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          foregroundColor: whiteColor,
          title: Row(
            children: [
              CircleAvatar(radius: 20, backgroundImage: AssetImage(profileImage)),
              const SizedBox(width: 10),
              Text(
                "Kaushal Vyas",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: whiteColor),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isMe = widget.type == 'customer'
                      ? (msg.senderId == widget.customerId)
                      : (msg.senderId == widget.driverId);
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      constraints:
                          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                      decoration: BoxDecoration(
                        color: isMe ? secondaryColor : Colors.grey.shade100,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
                          bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(msg.message,
                              style:
                                  Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16)),
                          const SizedBox(height: 5),
                          Text(
                            DateFormat('hh:mm a')
                                .format(DateTime.fromMillisecondsSinceEpoch(msg.timestamp)),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
                      cursorColor: primaryColor,
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.typeAMessageString,
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  CircleAvatar(
                    backgroundColor: primaryColor,
                    child: Center(
                      child: IconButton(
                        alignment: Alignment.center,
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
