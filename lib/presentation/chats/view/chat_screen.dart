import 'dart:async';

import 'package:core/app_widgets.dart';
import 'package:core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/chats/model/chat_model.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String senderId;
  final String receiverId;
  final String type;
  final String senderName;
  final String receiverName;
  final String? receiverImageUrl;

  const ChatScreen({
    super.key,
    required this.senderId,
    required this.receiverId,
    required this.type,
    required this.senderName,
    required this.receiverName,
    required this.receiverImageUrl,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late DatabaseReference _chatRef;
  final authCubit = sl<AuthCubit>();
  List<ChatMessage> messages = [];
  StreamSubscription<DatabaseEvent>? _chatSubscription;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    final conversationId = getConversationId(widget.senderId, widget.receiverId);
    _chatRef = FirebaseDatabase.instance.ref().child('chats/$conversationId');
    _listenToMessages();
  }

  String getConversationId(String id1, String id2) {
    final ids = [id1, id2];
    ids.sort(); // ensures same order for both users
    return "${ids[0]}_${ids[1]}";
  }

  void _listenToMessages() {
    // Use onValue instead of onChildAdded to get all messages and handle updates properly
    _chatSubscription = _chatRef.orderByChild('timestamp').onValue.listen(
      (DatabaseEvent event) {
        if (_isDisposed || !mounted) return;

        final data = event.snapshot.value;
        if (data == null) {
          if (mounted) {
            setState(() {
              messages.clear();
            });
          }
          return;
        }

        final Map<String, dynamic> messagesMap = Map<String, dynamic>.from(data as Map);
        final List<ChatMessage> newMessages = [];

        messagesMap.forEach((key, value) {
          try {
            final messageData = Map<String, dynamic>.from(value as Map);
            final message = ChatMessage.fromMap(messageData);
            newMessages.add(message);
          } catch (e) {
            // Handle potential parsing errors gracefully
            debugPrint('Error parsing message: $e');
          }
        });

        // Sort messages by timestamp
        newMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        if (mounted && !_isDisposed) {
          setState(() {
            messages = newMessages;
          });

          // Auto-scroll to bottom after state update
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!_isDisposed && _scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      },
      onError: (error) {
        debugPrint('Error listening to messages: $error');
      },
    );
  }

  void _sendMessage() {
    if (_isDisposed) return;

    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final newMessage = ChatMessage(
      senderId: widget.senderId,
      receiverId: widget.receiverId,
      message: messageText,
      timestamp: timestamp,
    );

    final conversationId = getConversationId(widget.senderId, widget.receiverId);

    // Use a unique key for the message to avoid conflicts
    final messageRef = _chatRef.push();
    messageRef.set(newMessage.toMap()).catchError((error) {
      debugPrint('Error sending message: $error');
      // Optionally show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send message')),
        );
      }
    });

    // Update chat list for sender
    FirebaseDatabase.instance.ref("chat_list/${widget.senderId}/$conversationId").set({
      "name": widget.receiverName,
      "otherUserId": widget.receiverId,
      "lastMessage": messageText,
      "timestamp": timestamp,
      "receiverImageUrl": widget.receiverImageUrl
    }).catchError((error) {
      debugPrint('Error updating sender chat list: $error');
    });

    // Update chat list for receiver
    FirebaseDatabase.instance.ref("chat_list/${widget.receiverId}/$conversationId").set({
      "name": widget.senderName,
      "otherUserId": widget.senderId,
      "lastMessage": messageText,
      "timestamp": timestamp,
      "receiverImageUrl": authCubit.userDetails?.data?.profilePhotoUrl,
    }).catchError((error) {
      debugPrint('Error updating receiver chat list: $error');
    });

    _messageController.clear();
  }

  @override
  void dispose() {
    _isDisposed = true;

    // Cancel stream subscription
    _chatSubscription?.cancel();
    _chatSubscription = null;

    // Dispose controllers
    _messageController.dispose();
    _scrollController.dispose();

    // Clear messages list to free memory
    messages.clear();

    super.dispose();
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
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  widget.receiverImageUrl ?? sampleNetworkImage,
                ),
                onBackgroundImageError: (exception, stackTrace) {
                  // Handle image loading errors gracefully
                  debugPrint('Error loading profile image: $exception');
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.receiverName,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: whiteColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? const Center(
                      child: LoadingWithoutText(),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isMe = msg.senderId == widget.senderId;
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
                                bottomLeft:
                                    isMe ? const Radius.circular(12) : const Radius.circular(0),
                                bottomRight:
                                    isMe ? const Radius.circular(0) : const Radius.circular(12),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  msg.message,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontSize: 16),
                                ),
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
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.typeAMessageString,
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: _sendMessage,
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
