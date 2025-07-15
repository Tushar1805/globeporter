import 'dart:io';

import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/driver/widgets/info_field_widget.dart';
import 'package:globeporter/presentation/driver/widgets/upload_widget.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class OwnerTab extends StatefulWidget {
  const OwnerTab({super.key, required this.animateToPage});
  final VoidCallback animateToPage;

  @override
  State<OwnerTab> createState() => _OwnerTabState();
}

class _OwnerTabState extends State<OwnerTab> {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white60,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomElevatedButton(
            name: 'Next',
            borderRadius: 4,
            alignment: Alignment.bottomRight,
            onPressed: widget.animateToPage,
            textWidget: Image.asset(
              arrowForward,
              width: size.width * 0.13,
              height: size.height * 0.017,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoFieldWidget(
              title: AppLocalizations.of(context)!.nameString,
              controller: nameController,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: CustomRichText(
                title: AppLocalizations.of(context)!.uploadTheFollowingString,
                value: ' *',
                titleStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                valueStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.red,
                    ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            UploadWidget(
              text: AppLocalizations.of(context)!.ownerAdhaarCardString,
              onTap: () {
                context.pushNamed(
                  uploadDocumentScreen,
                  extra: {
                    'title': AppLocalizations.of(context)!.ownerAdhaarCardString,
                    'hintText':
                        '${AppLocalizations.of(context)!.ownerAdhaarCardString} (${AppLocalizations.of(context)!.frontSideString})',
                    'onImageCaptured': (File? file) {
                      // upload to Firebase or send back to previous page
                      debugPrint("Captured file path: ${file?.path}");
                    },
                  },
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            UploadWidget(
              text: AppLocalizations.of(context)!.ownerPanCardString,
              onTap: () {
                context.pushNamed(
                  uploadDocumentScreen,
                  extra: {
                    'title': AppLocalizations.of(context)!.ownerPanCardString,
                    'hintText':
                        '${AppLocalizations.of(context)!.ownerPanCardString} (${AppLocalizations.of(context)!.frontSideString})',
                    'onImageCaptured': (File? file) {
                      // upload to Firebase or send back to previous page
                      debugPrint("Captured file path: ${file?.path}");
                    },
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
