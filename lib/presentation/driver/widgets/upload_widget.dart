import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_widgets.dart';

class UploadWidget extends StatelessWidget {
  const UploadWidget({
    super.key,
    required this.text,
    required this.onTap,
    required this.uploaded,
  });
  final String text;
  final VoidCallback onTap;
  final bool uploaded;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: secondaryColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(text: text),
            TextButton(
              onPressed: onTap,
              child: Row(
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    color: uploaded ? primaryColor : greyTextColor,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    uploaded
                        ? AppLocalizations.of(context)!.uploadedString
                        : AppLocalizations.of(context)!.uploadString,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: uploaded ? primaryColor : greyTextColor),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
