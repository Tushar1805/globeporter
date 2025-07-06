import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> today = [
    {
      'text': 'Hi Vinod, Your request has been accepted Ravi.',
      'time': 'Now',
    },
    {
      'text': 'Hi Vinod, Your request has been accepted Ravi.',
      'time': '1 hr ago',
    },
    {
      'text': 'Hi Vinod, Your request has been accepted Ravi.',
      'time': '2 hr agp',
    },
  ];
  List<Map<String, dynamic>> yesterday = [
    {
      'text': 'Hi Vinod, Your request has been accepted Ravi.',
      'time': '12 June',
    },
    {
      'text': 'Hi Vinod, Your request has been accepted Ravi.',
      'time': '1 hr ago',
    },
  ];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.35),
        child: CustomStatusBarWidget(
          title: AppLocalizations.of(context)!.notificationString,
          height: size.width * 0.35,
          titlePositionTop: size.width * 0.2,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.of(context)!.todayString,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ...today.map(
              (element) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                        border: Border(left: BorderSide(width: 4, color: primaryColor))),
                    child: Row(
                      children: [
                        Image.asset(
                          bellIcon,
                          height: 24,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            element['text'],
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 50,
                          alignment: Alignment.bottomRight,
                          child: Text(
                            element['time'],
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF989696),
                                ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
