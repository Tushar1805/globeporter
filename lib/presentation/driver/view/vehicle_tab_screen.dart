import 'dart:io';

import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/driver/widgets/info_field_widget.dart';
import 'package:globeporter/presentation/driver/widgets/upload_widget.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class VehicleTab extends StatefulWidget {
  const VehicleTab({super.key, required this.animateToPage});
  final VoidCallback animateToPage;

  @override
  State<VehicleTab> createState() => _VehicleTabState();
}

class _VehicleTabState extends State<VehicleTab> {
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController vehicleRcController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();

  String? selectedVehicleType;
  final List<String> vehicleTypes = [
    '2-Wheeler',
    '3-Wheeler',
    '4-Wheeler',
    'Truck',
    'Van',
    'Other',
  ];

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
              title: AppLocalizations.of(context)!.vehicleNo,
              controller: vehicleNumberController,
            ),
            InfoFieldWidget(
              title: AppLocalizations.of(context)!.vehicleRcString,
              controller: vehicleRcController,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomRichText(
                title: AppLocalizations.of(context)!.vehicleTypeString,
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
              height: 10,
            ),
            CustomDropdownField(
              value: selectedVehicleType,
              options: vehicleTypes,
              onChanged: (val) {
                setState(() {
                  selectedVehicleType = val;
                });
              },
            ),
            const SizedBox(
              height: 20,
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
            UploadWidget(
              text: AppLocalizations.of(context)!.vehiclePhotoString,
              onTap: () {
                context.pushNamed(
                  uploadDocumentScreen,
                  extra: {
                    'title': AppLocalizations.of(context)!.vehiclePhotoString,
                    'hintText': AppLocalizations.of(context)!.vehiclePhotoString,
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
