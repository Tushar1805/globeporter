import 'dart:async';

import 'package:core/di/service_locator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/authentication/model/user_details_response_model.dart';
import 'package:globeporter/presentation/chats/view/chat_list_screen.dart';
import 'package:globeporter/presentation/customer/cubit/customer_cubit.dart';
import 'package:globeporter/presentation/customer/view/create_request_screen.dart';
import 'package:globeporter/presentation/customer/view/my_request_screen.dart';
import 'package:globeporter/presentation/settings/view/settings_screen.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_storage.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({
    super.key,
    required this.type,
  });
  final String? type;

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  int pageIndex = 1;
  late PageController pageController;
  final customerCubit = sl<CustomerCubit>();
  final authCubit = sl<AuthCubit>();
  final storage = sl<SecureStorage>();
  int totalUnreadCount = 0;
  UserDetailsResponseModel? userDetailsResponse;
  late DatabaseReference _chatListRef;
  StreamSubscription<DatabaseEvent>? _chatListSubscription;
  bool isDisposed = false;

  void getUserDetails() async {
    await authCubit.getUserDetails(force: true);
  }

  void getChatUnreadCount() {
    final currentUserId = authCubit.userDetails?.data?.id?.toString();
    if (currentUserId == null || currentUserId.trim().isEmpty) {
      debugPrint('Current user ID is null/empty, cannot initialize chat list');
      return;
    }

    _chatListRef = FirebaseDatabase.instance.ref("chat_list/$currentUserId");

    _chatListSubscription = _chatListRef.orderByChild("timestamp").onValue.listen(
      (DatabaseEvent event) {
        if (isDisposed || !mounted) return;

        final data = event.snapshot.value as Map<dynamic, dynamic>?;

        if (data != null) {
          try {
            int total = 0; // <- total counter

            data.forEach((key, value) {
              final dynamic unreadRaw = value['unreadCount'] ?? value['unread_count'] ?? 0;
              int unreadCount = 0;
              if (unreadRaw is int) {
                unreadCount = unreadRaw;
              } else if (unreadRaw is double) {
                unreadCount = unreadRaw.toInt();
              } else {
                unreadCount = int.tryParse(unreadRaw.toString()) ?? 0;
              }

              total += unreadCount; // <- accumulate
            });

            if (mounted && !isDisposed) {
              setState(() {
                totalUnreadCount = total;
              });
            }

            debugPrint("Total unread count: $totalUnreadCount");
          } catch (e) {
            debugPrint('Error parsing chat list data: $e');
          }
        } else {
          if (mounted && !isDisposed) {
            setState(() {
              totalUnreadCount = 0;
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
  void initState() {
    super.initState();
    getUserDetails();
    pageController = PageController(initialPage: pageIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    isDisposed = true;
    // Cancel stream subscription
    _chatListSubscription?.cancel();
    _chatListSubscription = null;
    super.dispose();
  }

  void onNavBarTap(int targetIndex) {
    if (targetIndex == pageIndex) return;

    // final duration = const Duration(milliseconds: 300);
    // final curve = Curves.easeInOut;

    setState(() {
      pageIndex = targetIndex;
    });

    // pageController.animateToPage(
    //   targetIndex,
    //   duration: duration,
    //   curve: curve,
    // );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screens = [
      MyRequestScreen(
        onCreateRequestTap: () => onNavBarTap(1),
      ),
      CreateRequestScreen(
        onSubmitTap: () => onNavBarTap(0),
      ),
      ChatListScreen(
        role: 'customer',
      ),
      SettingsScreen(
        role: 'customer',
      ),
    ];
    return BlocListener(
      bloc: authCubit,
      listener: (final context, final state) async {
        if (state is UserDetailsLoadedState) {
          final data = state.data as UserDetailsResponseModel?;
          userDetailsResponse = data;
          getChatUnreadCount();

          if (data?.data?.status == 0) {
            await authCubit.logout();
            // ignore: use_build_context_synchronously
            context.go(loginScreen, extra: {
              'status': data?.data?.status,
            });
          }
          setState(() {});
        }
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: whiteColor,
          body: screens[pageIndex],
          //  PageView(
          //   controller: pageController,
          //   children: screens,
          //   onPageChanged: (index) {
          //     setState(() {
          //       pageIndex = index;
          //     });
          //   },
          // ),
          bottomNavigationBar: Container(
            height: size.width * 0.18,
            padding: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              border: Border.all(
                color: const Color(
                  0xFFCDCDCD,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BottomNavBarIcon(
                  title: AppLocalizations.of(context)!.myRequestString,
                  icon: myRequestIcon,
                  onTap: () => onNavBarTap(0),
                  pageIndex: pageIndex,
                  itemIndex: 0,
                ),
                BottomNavBarIcon(
                  title: AppLocalizations.of(context)!.homeString,
                  icon: homeIcon,
                  onTap: () => onNavBarTap(1),
                  pageIndex: pageIndex,
                  itemIndex: 1,
                ),
                Stack(
                  children: [
                    BottomNavBarIcon(
                      title: AppLocalizations.of(context)!.chatsString,
                      icon: chatIcon,
                      onTap: () => onNavBarTap(2),
                      pageIndex: pageIndex,
                      itemIndex: 2,
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: UnreadBadge(
                        count: totalUnreadCount,
                      ),
                    ),
                  ],
                ),
                BottomNavBarIcon(
                  title: AppLocalizations.of(context)!.profileString,
                  icon: profileIcon,
                  onTap: () => onNavBarTap(3),
                  pageIndex: pageIndex,
                  itemIndex: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
