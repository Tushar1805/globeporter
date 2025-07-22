import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key, required this.role});
  final String role;

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final List<Map<String, String>> chats = [
    {"name": "Kaushal Vyas", "message": "ok", "time": "05:30 PM", "avatar": profileImage},
    {
      "name": "Rahul Singh",
      "message": "hi Ranjit ,aap vishrantwadi aaog...",
      "time": "08:44 AM",
      "avatar": profileImage
    },
    {
      "name": "Manasi Gavali",
      "message": "leaving in next 10mn",
      "time": "07:21 AM",
      "avatar": profileImage
    },
    {
      "name": "Vishal Moghe",
      "message": "gm",
      "time": "06:42 AM",
      "avatar": profileImage,
    },
    {
      "name": "Swapnil K",
      "message": "yes",
      "time": "07:30 PM",
      "avatar": profileImage,
    },
    {
      "name": "Priya Kumari",
      "message": "Ok",
      "time": "12:15 PM",
      "avatar": profileImage,
    },
    {
      "name": "Neeshma Cherian",
      "message": "no worries",
      "time": "08:00 AM",
      "avatar": profileImage
    },
    {
      "name": "Tushar Bharambe",
      "message": "I have parked my car in the Glo...",
      "time": "04:52 PM",
      "avatar": profileImage
    },
    {
      "name": "Nishant Bhat",
      "message": "👍",
      "time": "10:13 AM",
      "avatar": profileImage,
    },
  ];
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
        child: ListView.separated(
          itemCount: chats.length,
          separatorBuilder: (context, index) =>
              Divider(height: 2, thickness: 1, color: Colors.grey.shade300),
          itemBuilder: (context, index) {
            final chat = chats[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(chat["avatar"]!),
                radius: 24,
              ),
              title: Text(
                chat["name"]!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 20),
              ),
              subtitle: Text(
                chat["message"]!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
              ),
              trailing: Text(
                chat["time"]!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 13,
                      color: greyTextColor,
                    ),
              ),
              onTap: () {
                context.pushNamed(chatScreen);
              },
            );
          },
        ),
      ),
    );
  }
}
