import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.35),
        child: CustomStatusBarWidget(
          title: AppLocalizations.of(context)!.myTripsString,
        ),
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Large enough for pill shape
          ),
          padding: const EdgeInsets.all(14),
        ),
        onPressed: () {
          context.pushNamed(newRideScreen);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add,
              color: whiteColor,
              size: 24,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              AppLocalizations.of(context)!.newRideString,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: whiteColor),
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(AppLocalizations.of(context)!.myTripsString),
      ),
    );
  }
}
