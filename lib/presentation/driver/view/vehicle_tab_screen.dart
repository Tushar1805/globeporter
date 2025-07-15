import 'dart:io';

import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/driver/widgets/info_field_widget.dart';
import 'package:globeporter/presentation/driver/widgets/upload_widget.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class VehicleTab extends StatefulWidget {
  const VehicleTab({super.key});

  @override
  State<VehicleTab> createState() => _VehicleTabState();
}

class _VehicleTabState extends State<VehicleTab> {
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController vehicleRcController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoFieldWidget(
              title: AppLocalizations.of(context)!.vehicleNo,
              controller: vehicleNumberController,
            ),
            InfoFieldWidget(
              title: AppLocalizations.of(context)!.vehicleRcString,
              controller: vehicleRcController,
            ),
            InfoFieldWidget(
              title: AppLocalizations.of(context)!.vehicleTypeString,
              controller: vehicleTypeController,
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
              text: AppLocalizations.of(context)!.uploadRcString,
              onTap: () {
                context.pushNamed(
                  uploadDocumentScreen,
                  extra: {
                    'title': AppLocalizations.of(context)!.uploadRcString,
                    'hintText':
                        '${AppLocalizations.of(context)!.uploadRcString} (${AppLocalizations.of(context)!.frontSideString})',
                    'onImageCaptured': (File? file) {
                      // upload to Firebase or send back to previous page
                      debugPrint("Captured file path: ${file?.path}");
                    },
                  },
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
