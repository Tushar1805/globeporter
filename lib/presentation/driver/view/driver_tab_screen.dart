import 'dart:io';

import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/driver/widgets/info_field_widget.dart';
import 'package:globeporter/presentation/driver/widgets/upload_widget.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class DriverTab extends StatefulWidget {
  const DriverTab({super.key});

  @override
  State<DriverTab> createState() => _DriverTabState();
}

class _DriverTabState extends State<DriverTab> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController licenceNumberController = TextEditingController();
  File? frontAdhaar;
  File? backAdhaar;
  File? frontPan;
  File? backPan;
  File? frontLicence;
  File? backLincece;
  File? driverPhoto;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoFieldWidget(
              title: AppLocalizations.of(context)!.nameString,
              controller: nameController,
            ),
            InfoFieldWidget(
              title: AppLocalizations.of(context)!.phoneNumberString,
              controller: phoneNumberController,
            ),
            InfoFieldWidget(
              title: AppLocalizations.of(context)!.licenceNumberString,
              controller: licenceNumberController,
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
              text: AppLocalizations.of(context)!.driverAdhaarCardString,
              onTap: () {
                context.pushNamed(
                  uploadDocumentScreen,
                  extra: {
                    'type': 'driver_adhaar',
                    'title': AppLocalizations.of(context)!.driverAdhaarCardString,
                    'hintText':
                        '${AppLocalizations.of(context)!.driverAdhaarCardString} (${AppLocalizations.of(context)!.frontSideString})',
                    'onImageCaptured': (File? file, bool? front) {
                      if (front ?? false) {
                        setState(() {
                          frontAdhaar = file;
                        });
                      } else {
                        setState(() {
                          backAdhaar = file;
                        });
                      }
                      debugPrint(
                          "Captured file path: Front:  ${frontAdhaar?.path} : back: ${backAdhaar?.path}");
                    },
                    'front': true,
                  },
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            UploadWidget(
              text: AppLocalizations.of(context)!.driverPanCardString,
              onTap: () {
                context.pushNamed(
                  uploadDocumentScreen,
                  extra: {
                    'type': 'driver_pan',
                    'title': AppLocalizations.of(context)!.driverPanCardString,
                    'hintText':
                        '${AppLocalizations.of(context)!.driverPanCardString} (${AppLocalizations.of(context)!.frontSideString})',
                    'onImageCaptured': (File? file, bool? front) {
                      if (front ?? false) {
                        setState(() {
                          frontPan = file;
                        });
                      } else {
                        setState(() {
                          backPan = file;
                        });
                      }
                      debugPrint(
                          "Captured file path: Front:  ${frontPan?.path} : back: ${backPan?.path}");
                    },
                    'front': true,
                  },
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            UploadWidget(
              text: AppLocalizations.of(context)!.driverLicenceString,
              onTap: () {
                context.pushNamed(
                  uploadDocumentScreen,
                  extra: {
                    'type': 'driver_licence',
                    'title': AppLocalizations.of(context)!.driverLicenceString,
                    'hintText':
                        '${AppLocalizations.of(context)!.driverLicenceString} (${AppLocalizations.of(context)!.frontSideString})',
                    'onImageCaptured': (File? file, bool? front) {
                      if (front ?? false) {
                        setState(() {
                          frontLicence = file;
                        });
                      } else {
                        setState(() {
                          backLincece = file;
                        });
                      }
                      debugPrint(
                          "Captured file path: Front:  ${frontLicence?.path} : back: ${backLincece?.path}");
                    },
                    'front': true,
                  },
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            UploadWidget(
              text: AppLocalizations.of(context)!.driverPhotoString,
              onTap: () {
                context.pushNamed(
                  normalUploadScreen,
                  extra: {
                    'title': AppLocalizations.of(context)!.driverPhotoString,
                    'onImageCaptured': (File? file) {
                      setState(() {
                        driverPhoto = file;
                      });
                      debugPrint("Captured file path: Vehicle:  ${driverPhoto?.path}");
                    },
                  },
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomElevatedButton(
              name: AppLocalizations.of(context)!.submitString,
              borderRadius: 25,
              alignment: Alignment.bottomCenter,
              onPressed: () {
                context.push(driverDashboard);
              },
              textPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              nameSize: 22,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
