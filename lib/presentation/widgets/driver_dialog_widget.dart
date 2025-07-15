import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

void showDriverDialog(final context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: primaryColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                CustomElevatedButton(
                  name: AppLocalizations.of(context)!.yesString,
                  borderRadius: 28,
                  alignment: Alignment.center,
                  onPressed: () {
                    context.pop();
                    // context.pushNamed(driverDetailsScreen);
                    context.pushNamed(ownerDetailsScreen);
                    debugPrint('User is a driver');
                  },
                  nameColor: whiteColor,
                  nameSize: 24,
                ),
                CustomElevatedButton(
                  name: AppLocalizations.of(context)!.noString,
                  borderRadius: 28,
                  alignment: Alignment.center,
                  backgroundColor: Colors.red,
                  onPressed: () {
                    context.pop();
                    context.push(customerDashboard);
                    debugPrint('User is not a driver');
                  },
                  nameColor: whiteColor,
                  nameSize: 24,
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
