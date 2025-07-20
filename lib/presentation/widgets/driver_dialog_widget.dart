import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:go_router/go_router.dart';

class DriverDialog extends StatefulWidget {
  final AuthCubit authCubit;

  const DriverDialog({super.key, required this.authCubit});

  @override
  State<DriverDialog> createState() => _DriverDialogState();

  static Future<void> show(BuildContext context, AuthCubit authCubit) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DriverDialog(authCubit: authCubit),
    );
  }
}

class _DriverDialogState extends State<DriverDialog> {
  @override
  Widget build(BuildContext context) {
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
                onPressed: () async {
                  context.pop();
                  await widget.authCubit.updateUserType(userType: '2');
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
                onPressed: () async {
                  context.pop();
                  await widget.authCubit.updateUserType(userType: '1');
                  debugPrint('User is not a Customer');
                },
                nameColor: whiteColor,
                nameSize: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
