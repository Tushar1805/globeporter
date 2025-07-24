// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/driver/widgets/info_field_widget.dart';
import 'package:globeporter/presentation/driver/widgets/upload_widget.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_regex.dart';
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
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  File? frontAdhaar;
  File? backAdhaar;
  File? frontPan;
  File? backPan;
  File? ownerPhoto;

  final authCubit = sl<AuthCubit>();
  FToast? fToast;
  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);
    nameController.text = authCubit.ownerName ?? '';
    phoneNumberController.text = authCubit.ownerPhoneNumber ?? '';
    frontAdhaar = authCubit.ownerFrontAdhaar;
    backAdhaar = authCubit.ownerBackAdhaar;
    frontPan = authCubit.ownerFrontPan;
    backPan = authCubit.ownerBackPan;
    ownerPhoto = authCubit.ownerPhoto;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white60,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: CustomElevatedButton(
              name: AppLocalizations.of(context)!.notADriverString,
              borderRadius: 4,
              alignment: Alignment.bottomRight,
              onPressed: () async {
                authCubit.updateUserType(userType: '1');
                context.pushNamed(customerDashboard);
              },
            ),
          ),
          CustomElevatedButton(
            name: AppLocalizations.of(context)!.goString,
            borderRadius: 4,
            alignment: Alignment.bottomRight,
            onPressed: () {
              var uploadMsg =
                  '${AppLocalizations.of(context)!.pleaseUploadString} ${AppLocalizations.of(context)!.ownerString.toLowerCase()}';
              if (nameController.text.isEmpty && nameController.text.length < 5) {
                showToast(
                  context: context,
                  fToast: fToast!,
                  msg: AppLocalizations.of(context)!.validNameString,
                  duration: 3,
                );
              } else if (phoneNumberController.text.isEmpty ||
                  phoneNumberController.text.length < 10 ||
                  phoneNumberController.text.length > 10) {
                showToast(
                  context: context,
                  fToast: fToast!,
                  msg: AppLocalizations.of(context)!.validPhoneNumberString,
                  duration: 3,
                );
              } else if (frontAdhaar == null && backAdhaar == null) {
                showToast(
                  context: context,
                  fToast: fToast!,
                  msg: '$uploadMsg ${AppLocalizations.of(context)!.adhaarCardString.toLowerCase()}',
                  duration: 3,
                );
              } else if (frontAdhaar == null) {
                showToast(
                  context: context,
                  fToast: fToast!,
                  msg:
                      '$uploadMsg ${AppLocalizations.of(context)!.frontSideString.toLowerCase()} ${AppLocalizations.of(context)!.adhaarCardString}',
                  duration: 3,
                );
              } else if (backAdhaar == null) {
                showToast(
                  context: context,
                  fToast: fToast!,
                  msg:
                      '$uploadMsg ${AppLocalizations.of(context)!.backSide.toLowerCase()} ${AppLocalizations.of(context)!.adhaarCardString}',
                  duration: 3,
                );
              } else if (frontPan == null && backPan == null) {
                showToast(
                  context: context,
                  fToast: fToast!,
                  msg: '$uploadMsg  ${AppLocalizations.of(context)!.panCardString}',
                  duration: 3,
                );
              } else if (frontPan == null) {
                showToast(
                  context: context,
                  fToast: fToast!,
                  msg:
                      '$uploadMsg ${AppLocalizations.of(context)!.frontSideString.toLowerCase()} ${AppLocalizations.of(context)!.panCardString}',
                  duration: 3,
                );
              } else if (backPan == null) {
                showToast(
                  context: context,
                  fToast: fToast!,
                  msg:
                      '$uploadMsg ${AppLocalizations.of(context)!.backSide.toLowerCase()} ${AppLocalizations.of(context)!.panCardString}',
                  duration: 3,
                );
              } else if (ownerPhoto == null) {
                showToast(
                  context: context,
                  fToast: fToast!,
                  msg: '$uploadMsg ${AppLocalizations.of(context)!.photoString}',
                  duration: 3,
                );
              } else {
                authCubit.saveOwnerDetails(
                  ownerName: nameController.text,
                  ownerPhoneNumber: phoneNumberController.text,
                  ownerFrontAdhaar: frontAdhaar ?? File(''),
                  ownerBackAdhaar: backAdhaar ?? File(''),
                  ownerFrontPan: frontPan ?? File(''),
                  ownerBackPan: backPan ?? File(''),
                  ownerPhoto: ownerPhoto ?? File(''),
                );
                widget.animateToPage();
              }
            },
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
              inputFormatter: [
                FilteringTextInputFormatter.allow(nameRegex),
              ],
              inputType: TextInputType.name,
            ),
            InfoFieldWidget(
              title: AppLocalizations.of(context)!.phoneNumberString,
              controller: phoneNumberController,
              inputFormatter: [
                FilteringTextInputFormatter.allow(phoneNumberRegex),
              ],
              inputType: TextInputType.number,
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
              uploaded: (frontAdhaar != null && backAdhaar != null),
              onTap: () {
                context.pushNamed(
                  uploadDocumentScreen,
                  extra: {
                    'type': 'own_adhaar',
                    'title': AppLocalizations.of(context)!.ownerAdhaarCardString,
                    'hintText':
                        '${AppLocalizations.of(context)!.ownerAdhaarCardString} (${AppLocalizations.of(context)!.frontSideString})',
                    'imageList': [frontAdhaar, backAdhaar],
                    'onImageCaptured': (File? file, bool? front) {
                      // upload to Firebase or send back to previous page
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
              text: AppLocalizations.of(context)!.ownerPanCardString,
              uploaded: (frontPan != null && backPan != null),
              onTap: () {
                context.pushNamed(
                  uploadDocumentScreen,
                  extra: {
                    'type': 'own_pan',
                    'title': AppLocalizations.of(context)!.ownerPanCardString,
                    'hintText':
                        '${AppLocalizations.of(context)!.ownerPanCardString} (${AppLocalizations.of(context)!.frontSideString})',
                    'imageList': [frontPan, backPan],
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
              text:
                  '${AppLocalizations.of(context)!.ownerString} ${AppLocalizations.of(context)!.photoString}',
              uploaded: ownerPhoto != null,
              onTap: () {
                context.pushNamed(
                  normalUploadScreen,
                  extra: {
                    'title':
                        '${AppLocalizations.of(context)!.ownerString} ${AppLocalizations.of(context)!.photoString}',
                    'image': ownerPhoto,
                    'onImageCaptured': (File? file) {
                      setState(() {
                        ownerPhoto = file;
                      });
                      debugPrint("Captured file path: Vehicle:  ${ownerPhoto?.path}");
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
