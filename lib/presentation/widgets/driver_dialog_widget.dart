import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

void showDriverDialog(final context) {
  showDialog(
    context: context,
    barrierDismissible: true, // prevent closing by tapping outside
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: primaryColor),
        ),
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.driverAskString,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 24,
                    color: primaryColor,
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.pushNamed(driverDetailsScreen);
                    // Handle Yes logic here
                    debugPrint('User is a driver');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.yesString,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 24,
                          color: whiteColor,
                        ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.pop();
                    // Handle No logic here
                    debugPrint('User is not a driver');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.noString,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 24,
                          color: whiteColor,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
