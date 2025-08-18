import 'dart:async';

import 'package:core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/chats/cubit/chat_cubit.dart';
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
  final chatCubit = sl<ChatCubit>();
  List<ChatMessage> messages = [];
  StreamSubscription<DatabaseEvent>? _chatSubscription;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    final conversationId = getConversationId(widget.senderId, widget.receiverId);
    _chatRef = FirebaseDatabase.instance.ref().child('chats/$conversationId');
    clearUnreadCount(conversationId);
    _listenToMessages();
  }

  String getConversationId(String? id1, String? id2) {
    if (id1 == null || id2 == null || id1.trim().isEmpty || id2.trim().isEmpty) return '';
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

  String _maskSensitiveInfo(String text) {
    // Mask phone numbers (10+ digits)
    final phoneRegex = RegExp(r'\b\d{10,}\b');
    text = text.replaceAllMapped(phoneRegex, (match) {
      final number = match.group(0)!;
      if (number.length >= 4) {
        return number.substring(0, 2) + '*' * (number.length - 2);
      }
      return '*' * number.length;
    });

    // Mask emails
    final emailRegex = RegExp(r'([a-zA-Z0-9._%+-]{2,})@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    text = text.replaceAllMapped(emailRegex, (match) {
      final email = match.group(0)!;
      final parts = email.split('@');
      final name = parts[0];
      final maskedName = name.substring(0, 3) + '*' * (name.length - 3);
      return "$maskedName@${parts[1]}";
    });

    return text;
  }

  //* Send Message with unread count

  Future<void> _sendMessage() async {
    if (_isDisposed) return;

    final messageText = _maskSensitiveInfo(_messageController.text.trim());
    if (messageText.isEmpty) return;

    // 5) Clear the input box
    _messageController.clear();

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final newMessage = ChatMessage(
      senderId: widget.senderId,
      receiverId: widget.receiverId,
      message: messageText,
      timestamp: timestamp,
    );

    final conversationId = getConversationId(widget.senderId, widget.receiverId);
    if (conversationId == '') return;

    // Reference to the message list for this conversation
    final messageRef = _chatRef.push();

    try {
      // 1) Save the message
      await messageRef.set(newMessage.toMap());

      // 2) Update sender's chat list entry (unreadCount = 0)
      final senderChatRef =
          FirebaseDatabase.instance.ref("chat_list/${widget.senderId}/$conversationId");

      await senderChatRef.update({
        "name": widget.receiverName,
        "otherUserId": widget.receiverId,
        "lastMessage": messageText,
        "timestamp": timestamp,
        "receiverImageUrl": widget.receiverImageUrl,
        "unreadCount": 0,
      });

      // 3) Atomically increment receiver's unreadCount
      final receiverChatRef =
          FirebaseDatabase.instance.ref("chat_list/${widget.receiverId}/$conversationId");

      await receiverChatRef.runTransaction((Object? currentValue) {
        final Map<String, dynamic> current =
            (currentValue as Map?)?.map((key, value) => MapEntry(key.toString(), value)) ??
                <String, dynamic>{};

        int currentUnread = 0;
        final dynamic u = current['unreadCount'];
        if (u is int) {
          currentUnread = u;
        } else if (u is double) {
          currentUnread = u.toInt();
        } else {
          currentUnread = int.tryParse(u?.toString() ?? '0') ?? 0;
        }

        current['unreadCount'] = currentUnread + 1;
        current['lastMessage'] = messageText;
        current['timestamp'] = timestamp;
        current['otherUserId'] = widget.senderId;
        current['name'] = widget.senderName;
        current['receiverImageUrl'] =
            authCubit.userDetails?.data?.profilePhotoUrl ?? current['receiverImageUrl'];

        return Transaction.success(current);
      });

      // 4) Send push notification
      chatCubit.sendNotification(
        title: widget.senderName,
        message: messageText,
        receiverId: widget.receiverId,
        senderId: widget.senderId,
        receiverName: widget.receiverName,
        senderName: widget.senderName,
        receiverImageUrl: widget.receiverImageUrl,
        userType: widget.type,
      );
    } catch (e) {
      debugPrint('Error sending message: $e');
      if (mounted) {
        Fluttertoast.showToast(msg: AppLocalizations.of(context)!.failedToSendMessageString);
      }
    }
  }

  // Clear unread count for current user & conversation (called when user opens chat)
  Future<void> clearUnreadCount(String conversationId) async {
    final currentUserId = authCubit.userDetails?.data?.id;
    if (currentUserId == null) return;
    try {
      final ref =
          FirebaseDatabase.instance.ref('chat_list/$currentUserId/$conversationId/unreadCount');
      await ref.set(0);
    } catch (e) {
      debugPrint('Error clearing unread count: $e');
    }
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
    final locale = AppLocalizations.of(context)!;
    final theme = Theme.of(context).textTheme;
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
                  ? Center(
                      child: Text(
                        locale.noChatsYetString,
                        style: theme.bodyMedium,
                      ),
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
                                  style: theme.bodyMedium?.copyWith(fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  DateFormat('hh:mm a')
                                      .format(DateTime.fromMillisecondsSinceEpoch(msg.timestamp)),
                                  style:
                                      theme.bodySmall?.copyWith(color: Colors.grey, fontSize: 11),
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
                      style: theme.bodyMedium?.copyWith(fontSize: 18),
                      cursorColor: primaryColor,
                      controller: _messageController,
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: locale.typeAMessageString,
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: theme.bodyLarge?.copyWith(fontSize: 16),
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
