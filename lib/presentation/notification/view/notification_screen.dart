// ignore_for_file: use_build_context_synchronously

import 'package:core/app_widgets.dart';
import 'package:core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/customer/cubit/customer_cubit.dart';
import 'package:globeporter/presentation/notification/cubit/notification_cubit.dart';
import 'package:globeporter/presentation/notification/model/notifications_response_model.dart';
import 'package:globeporter/presentation/notification/states/notification_states.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

extension DataDateX on Data {
  /// Parses ISO 8601 `createdAt` safely.
  DateTime? get createdAtUtc {
    final raw = createdAt;
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  /// Local device time (important for correct Today/Yesterday in IST).
  DateTime? get createdAtLocal {
    final dt = createdAtUtc;
    if (dt == null) return null;
    return dt.isUtc ? dt.toLocal() : dt;
  }

  /// Date-only (midnight) for bucketing.
  DateTime? get createdAtLocalDateOnly {
    final dt = createdAtLocal;
    if (dt == null) return null;
    return DateTime(dt.year, dt.month, dt.day);
  }
}

class NotificationSection {
  final DateTime? date; // null if unknown
  final String label; // "Today", "Yesterday", or formatted date
  final List<Data> items;

  NotificationSection({
    required this.date,
    required this.label,
    required this.items,
  });
}

List<NotificationSection> buildNotificationSections(List<Data> list, {DateTime? now}) {
  final baseNow = (now ?? DateTime.now()).toLocal();
  final today = DateTime(baseNow.year, baseNow.month, baseNow.day);

  // Group by date-only
  final Map<DateTime?, List<Data>> buckets = <DateTime?, List<Data>>{};
  for (final n in list) {
    final key = n.createdAtLocalDateOnly; // may be null
    (buckets[key] ??= <Data>[]).add(n);
  }

  // Sort each bucket by createdAt desc
  for (final entry in buckets.entries) {
    entry.value.sort((a, b) {
      final ad = a.createdAtLocal ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bd = b.createdAtLocal ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bd.compareTo(ad);
    });
  }

  // Sort known dates desc
  final knownDates = buckets.keys.where((k) => k != null).cast<DateTime>().toList()
    ..sort((a, b) => b.compareTo(a));

  String labelFor(DateTime d) {
    final diff = today.difference(d).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return _formatDateHeading(d);
  }

  final sections = <NotificationSection>[];

  for (final d in knownDates) {
    sections.add(
      NotificationSection(
        date: d,
        label: labelFor(d),
        items: buckets[d]!,
      ),
    );
  }

  // Unknown dates at end (rare)
  if (buckets.containsKey(null)) {
    sections.add(
      NotificationSection(
        date: null,
        label: 'Unknown date',
        items: buckets[null]!,
      ),
    );
  }

  // Ensure Today → Yesterday → others (already date-desc)
  sections.sort((a, b) {
    int rank(NotificationSection s) {
      if (s.label == 'Today') return 0;
      if (s.label == 'Yesterday') return 1;
      return 2;
    }

    final r = rank(a).compareTo(rank(b));
    if (r != 0) return r;

    final ad = a.date ?? DateTime.fromMillisecondsSinceEpoch(0);
    final bd = b.date ?? DateTime.fromMillisecondsSinceEpoch(0);
    return bd.compareTo(ad);
  });

  return sections;
}

/// "19 Aug 2025"
String _formatDateHeading(DateTime d) {
  const months = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return '${d.day} ${months[d.month]} ${d.year}';
}

/// Relative time for the small trailing label in the tile.
/// Today → "Now" / "X min ago" / "X hr ago"
/// Else  → "dd MMM"
String _formatRelativeTime(DateTime created, DateTime baseNow) {
  final createdLocal = created.toLocal();
  final now = baseNow.toLocal();

  final today = DateTime(now.year, now.month, now.day);
  final createdDay = DateTime(createdLocal.year, createdLocal.month, createdLocal.day);

  if (createdDay == today) {
    final diff = now.difference(createdLocal);
    final mins = diff.inMinutes;
    if (mins <= 0) return 'Now';
    if (mins < 60) return '$mins min ago';
    final hrs = diff.inHours;
    return '$hrs hr${hrs > 1 ? 's' : ''} ago';
  } else {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${createdLocal.day} ${months[createdLocal.month]}';
  }
}

/// View-model for your tile that keeps a reference to the raw Data.
class NotificationTileVM {
  final String title;
  final String text;
  final String time;
  final bool isChat;
  final Data raw;
  NotificationTileVM(
      {required this.title,
      required this.text,
      required this.time,
      required this.raw,
      this.isChat = false});
}

/// Convert section items into the same simple structure your UI expects,
/// but keep the original Data for navigation.
List<NotificationTileVM> _toTileVMs(List<Data> items, DateTime baseNow) {
  return items.map((n) {
    final created = n.createdAtLocal ?? DateTime.fromMillisecondsSinceEpoch(0);
    return NotificationTileVM(
      title: n.title ?? '',
      text: n.message ?? '',
      isChat: n.type != null ? n.type == 'notify' : false,
      time: _formatRelativeTime(created, baseNow),
      raw: n,
    );
  }).toList();
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final notificationCubit = sl<NotificationCubit>();
  final customerCubit = sl<CustomerCubit>();
  final authCubit = sl<AuthCubit>();
  NotificationsResponse? notificationsResponse;

  void getNotifications() async {
    await notificationCubit.getNotifications();
    await notificationCubit.markNotificationsRead();
  }

  @override
  void initState() {
    getNotifications();
    super.initState();
  }

  void _onNotificationTap(Data data) async {
    // Decide where to go using available fields.
    // You can tweak these route names to your app.
    final type = data.type ?? 'notify'; // e.g. "1" for ride accepted
    // final rideType = data.rideType ?? ''; // e.g. "Rural" / "Urban"
    final bookingId = data.bookingId;

    if (type == '0') {
      await context.pushNamed(driverRideNotificationScreen, extra: {
        'bookingId': bookingId.toString(),
      });
    } else if (type.toString() == '1') {
      if (data.userType.toString() == '1') {
        final response = await customerCubit.getBookingDetails(bookingId: bookingId.toString());

        //* Route to customer -> request details
        await context.pushNamed(myRequestDetailsScreen, extra: {
          'type': response?.data?.rideType?.toLowerCase(),
          'bookingId': bookingId.toString(),
        });
      }
    } else if (type == 'notify' && data.receiverId != null && data.senderId != null) {
      //* when chat notification receives sender becomes receiver
      // TODO: Receiver Image logic not yet done
      await context.pushNamed(chatScreen, extra: {
        'senderId': data.receiverId,
        'receiverId': data.senderId,
        'senderName': data.receiverName,
        'type':
            data.userType ?? ((authCubit.userDetails?.data?.userType == 1) ? 'customer' : 'driver'),
        'receiverName': data.senderName,
        'receiverImageUrl': data.receiverImageUrl,
      });
    } else if (type == "5" && data.userType.toString() == "1") {
      //* Status on the way -> Track driver
      final response = await customerCubit.getBookingDetails(bookingId: bookingId.toString());
      await context.pushNamed(trackDriverScreen, extra: {
        'type': response?.data?.rideType?.toLowerCase(),
        'data': response?.data,
      });
    } else if (type == '6' && data.userType.toString() == "1") {
      //* Status Arrived at pickup
      final response = await customerCubit.getBookingDetails(bookingId: bookingId.toString());

      //* Route to customer -> request details
      await context.pushNamed(myRequestDetailsScreen, extra: {
        'type': response?.data?.rideType?.toLowerCase(),
        'bookingId': bookingId.toString(),
      });
    } else if (type == '7' && data.userType.toString() == "1") {
      //* Status Ride started
      final response = await customerCubit.getBookingDetails(bookingId: bookingId.toString());

      //* Route to customer -> request details
      await context.pushNamed(myRequestDetailsScreen, extra: {
        'type': response?.data?.rideType?.toLowerCase(),
        'bookingId': bookingId.toString(),
      });
    } else if (type == '8' && data.userType.toString() == "1") {
      //* Status Arrived at destination
      final response = await customerCubit.getBookingDetails(bookingId: bookingId.toString());

      //* Route to customer -> request details
      await context.pushNamed(myRequestDetailsScreen, extra: {
        'type': response?.data?.rideType?.toLowerCase(),
        'bookingId': bookingId.toString(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locale = AppLocalizations.of(context)!;
    final userDetails = authCubit.userDetails?.data;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.35),
        child: CustomStatusBarWidget(
          title: locale.notificationString,
          height: size.width * 0.35,
          titlePositionTop: size.width * 0.2,
        ),
      ),
      body: BlocConsumer(
        bloc: notificationCubit,
        listener: (final context, final state) {
          if (state is NotificationsLoadedState) {
            notificationsResponse = state.data as NotificationsResponse?;
          }
        },
        builder: (final context, final state) {
          if (state is NotificationsLoadingState) {
            return const Center(child: LoadingWithoutText());
          } else {
            final List<Data> raw = notificationsResponse?.data ?? <Data>[];
            final sections = buildNotificationSections(raw);
            final baseNow = DateTime.now();

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Build each date section (UI unchanged).
                  ...sections.expand((section) {
                    final sectionLabel = section.label == 'Today'
                        ? locale.todayString
                        : section.label == 'Yesterday'
                            ? locale.yesterdayString
                            : section.label; // "dd MMM yyyy"

                    final tileVMs = _toTileVMs(section.items, baseNow);

                    return [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            sectionLabel,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...tileVMs.map(
                        (vm) {
                          final message =
                              vm.isChat ? '${locale.youGotMessageString} ${vm.title}' : vm.text;
                          return GestureDetector(
                            onTap: () => _onNotificationTap(vm.raw),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Container(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(9)),
                                  border: Border(left: BorderSide(width: 4, color: primaryColor)),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      bellIcon,
                                      height: 24,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "${locale.hiString} ${userDetails?.name}, $message",
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      height: 50,
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        vm.time,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xFF989696),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ];
                  }),

                  if (sections.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${locale.noString} ${locale.notificationString}",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
