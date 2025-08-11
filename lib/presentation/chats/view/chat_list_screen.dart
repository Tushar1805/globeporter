import 'dart:async';
import 'package:core/di/service_locator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key, required this.role});
  final String role;

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late DatabaseReference _chatListRef;
  List<Map<String, dynamic>> chatList = [];
  final authCubit = sl<AuthCubit>();

  // Add these for proper memory management
  StreamSubscription<DatabaseEvent>? _chatListSubscription;
  bool _isDisposed = false;

  void loadUserDetails() async {
    await authCubit.getUserDetails(force: true);
  }

  @override
  void initState() {
    loadUserDetails();
    _initializeChatList();
    super.initState();
  }

  void _initializeChatList() {
    final currentUserId = authCubit.userDetails?.data?.id?.toString();
    if (currentUserId == null || currentUserId.trim().isEmpty) {
      debugPrint('Current user ID is null/empty, cannot initialize chat list');
      return;
    }

    _chatListRef = FirebaseDatabase.instance.ref("chat_list/$currentUserId");

    // Properly handle the stream subscription
    _chatListSubscription = _chatListRef.orderByChild("timestamp").onValue.listen(
      (DatabaseEvent event) {
        // CRITICAL: Check disposal and mount state before setState
        if (_isDisposed || !mounted) return;

        final data = event.snapshot.value as Map<dynamic, dynamic>?;

        if (data != null) {
          try {
            final List<Map<String, dynamic>> loadedChats = [];

            data.forEach((key, value) {
              // robust parsing of unreadCount
              final dynamic unreadRaw = value['unreadCount'] ?? value['unread_count'] ?? 0;
              int unreadCount = 0;
              if (unreadRaw is int) {
                unreadCount = unreadRaw;
              } else if (unreadRaw is double) {
                unreadCount = unreadRaw.toInt();
              } else {
                unreadCount = int.tryParse(unreadRaw.toString()) ?? 0;
              }
              // Add null safety checks
              if (value != null && value is Map) {
                loadedChats.add({
                  "conversationId": key,
                  "name": value["name"] ?? "Unknown",
                  "lastMessage": value["lastMessage"] ?? "",
                  "timestamp": value["timestamp"] ?? 0,
                  "otherUserId": value["otherUserId"] ?? "",
                  'receiverImageUrl': value['receiverImageUrl'],
                  'unreadCount': unreadCount, // <- new
                });
              }
            });

            // Sort latest first
            loadedChats.sort((a, b) {
              final timestampA = a["timestamp"] as int? ?? 0;
              final timestampB = b["timestamp"] as int? ?? 0;
              return timestampB.compareTo(timestampA);
            });

            // Double-check before setState
            if (mounted && !_isDisposed) {
              setState(() {
                chatList = loadedChats;
              });
            }
          } catch (e) {
            debugPrint('Error parsing chat list data: $e');
          }
        } else {
          // Handle empty data case
          if (mounted && !_isDisposed) {
            setState(() {
              chatList.clear();
            });
          }
        }
      },
      onError: (error) {
        debugPrint('Error listening to chat list: $error');
      },
    );
  }

  @override
  void dispose() {
    // CRITICAL: Set disposal flag first
    _isDisposed = true;

    // Cancel stream subscription
    _chatListSubscription?.cancel();
    _chatListSubscription = null;

    // Clear chat list to free memory
    chatList.clear();

    super.dispose();
  }

  String _formatTime(int timestamp) {
    if (timestamp == 0) return '';

    try {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return DateFormat('MMM dd').format(dateTime);
      } else {
        return DateFormat('hh:mm a').format(dateTime);
      }
    } catch (e) {
      debugPrint('Error formatting time: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.35),
        child: CustomStatusBarWidget(
          title: AppLocalizations.of(context)!.chatsString,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: chatList.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No chats yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                itemCount: chatList.length,
                separatorBuilder: (context, index) => Divider(
                  height: 2,
                  thickness: 1,
                  color: Colors.grey.shade300,
                ),
                itemBuilder: (context, index) {
                  final chat = chatList[index];
                  final timestamp = chat["timestamp"] as int? ?? 0;
                  final time = _formatTime(timestamp);
                  final unreadCount = chat['unreadCount'] as int? ?? 0;

                  return ListTile(
                    // tileColor: unreadCount > 0 ? secondaryColor : null,
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        chat['receiverImageUrl'] ?? sampleNetworkImage,
                      ),
                      radius: 24,
                      onBackgroundImageError: (exception, stackTrace) {
                        debugPrint('Error loading chat list image: $exception');
                      },
                    ),
                    title: Text(
                      chat["name"] ?? "Unknown",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 20),
                    ),
                    subtitle: Text(
                      chat["lastMessage"] ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          time,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 13,
                                color: greyTextColor,
                              ),
                        ),
                        const SizedBox(height: 6),
                        if (unreadCount > 0) buildUnreadBadge(unreadCount),
                      ],
                    ),
                    onTap: () {
                      // Add null safety checks for navigation
                      final senderId = authCubit.userDetails?.data?.id?.toString();
                      final receiverId = chat['otherUserId'];
                      final senderName = authCubit.userDetails?.data?.name;
                      final receiverName = chat["name"];

                      if (senderId != null &&
                          receiverId != null &&
                          senderName != null &&
                          receiverName != null) {
                        context.pushNamed(chatScreen, extra: {
                          'senderId': senderId,
                          'receiverId': receiverId,
                          'senderName': senderName,
                          'type': widget.role,
                          'receiverName': receiverName,
                          'receiverImageUrl': chat['receiverImageUrl']
                        });
                      } else {
                        debugPrint('Missing required data for chat navigation');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Unable to open chat. Please try again.'),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
      ),
    );
  }

  // --- helper badge widget (add to class) ---
  Widget buildUnreadBadge(int count) {
    if (count <= 0) return const SizedBox.shrink();
    final display = count > 99 ? '99+' : count.toString();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1))],
      ),
      constraints: const BoxConstraints(minWidth: 24, minHeight: 20),
      child: Text(
        display,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: whiteColor,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
