import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [
    {
      "text": "Hey there!",
      "isMe": false,
      "time": "12:30 PM",
    },
    {
      "text": "Hi! What's up?",
      "isMe": true,
      "time": "12:31 PM",
    },
    {
      "text": "All good, working on the project.",
      "isMe": false,
      "time": "12:32 PM",
    },
    {
      "text": "Nice! Let me know if you need any help.",
      "isMe": true,
      "time": "12:33 PM",
    },
  ];
  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      messages.add({
        "text": text,
        "isMe": true,
        "time": TimeOfDay.now().format(context),
      });
      _controller.clear();
    });
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
              SizedBox(width: 10),
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return Align(
                    alignment: msg['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      constraints:
                          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                      decoration: BoxDecoration(
                        color: msg['isMe'] ? secondaryColor : Colors.grey.shade100,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft:
                              msg['isMe'] ? const Radius.circular(12) : const Radius.circular(0),
                          bottomRight:
                              msg['isMe'] ? const Radius.circular(0) : const Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(msg['text'],
                              style:
                                  Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16)),
                          const SizedBox(height: 5),
                          Text(
                            msg['time'],
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
                      controller: _controller,
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.typeAMessageString,
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16)),
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
