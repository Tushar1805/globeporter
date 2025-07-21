import 'dart:io';

import 'package:core/app_widgets.dart';
import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:datasource/states/data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
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
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController licenceNumberController = TextEditingController();
  File? frontAdhaar;
  File? backAdhaar;
  File? frontPan;
  File? backPan;
  File? frontLicence;
  File? backLicence;
  File? driverPhoto;

  final authCubit = sl<AuthCubit>();
  FToast? fToast;
  bool loading = false;
  String? errorMessage;

  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);

    nameController.text = authCubit.driverName ?? '';
    phoneNumberController.text = authCubit.driverPhoneNumber ?? '';
    licenceNumberController.text = authCubit.driverLicenceNumber ?? '';
    frontAdhaar = authCubit.driverFrontAdhaar;
    backAdhaar = authCubit.driverBackAdhaar;
    frontPan = authCubit.driverFrontPan;
    backPan = authCubit.driverBackPan;
    frontLicence = authCubit.driverFrontLicence;
    backLicence = authCubit.driverBackLicence;
    driverPhoto = authCubit.driverPhoto;

    super.initState();
  }

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
                    'imageList': [frontAdhaar, backAdhaar],
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
                setState(() {
                  loading = false;
                });
                context.pushNamed(
                  uploadDocumentScreen,
                  extra: {
                    'type': 'driver_pan',
                    'title': AppLocalizations.of(context)!.driverPanCardString,
                    'hintText':
                        '${AppLocalizations.of(context)!.driverPanCardString} (${AppLocalizations.of(context)!.frontSideString})',
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
              text: AppLocalizations.of(context)!.driverLicenceString,
              onTap: () {
                context.pushNamed(
                  uploadDocumentScreen,
                  extra: {
                    'type': 'driver_licence',
                    'title': AppLocalizations.of(context)!.driverLicenceString,
                    'hintText':
                        '${AppLocalizations.of(context)!.driverLicenceString} (${AppLocalizations.of(context)!.frontSideString})',
                    'imageList': [frontLicence, backLicence],
                    'onImageCaptured': (File? file, bool? front) {
                      if (front ?? false) {
                        setState(() {
                          frontLicence = file;
                        });
                      } else {
                        setState(() {
                          backLicence = file;
                        });
                      }
                      debugPrint(
                          "Captured file path: Front:  ${frontLicence?.path} : back: ${backLicence?.path}");
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
                    'image': driverPhoto,
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
            BlocListener(
              bloc: authCubit,
              listener: (final context, final state) {
                if (state is AllDetailsLoadingState) {
                  setState(() {
                    loading = true;
                  });
                } else if (state is AllDetailsLoadedState) {
                  context.push(driverDashboard);
                  setState(() {
                    loading = false;
                  });
                } else if (state is ErrorState) {
                  setState(() {
                    loading = false;
                  });
                  setState(() {
                    errorMessage = state.errorMessage;
                  });
                }
              },
              child: loading
                  ? SizedBox.shrink()
                  : CustomElevatedButton(
                      name: AppLocalizations.of(context)!.submitString,
                      borderRadius: 25,
                      alignment: Alignment.bottomCenter,
                      onPressed: () async {
                        var uploadMsg =
                            '${AppLocalizations.of(context)!.pleaseUploadString} ${AppLocalizations.of(context)!.driverString.toLowerCase()}';
                        var enterMsg = AppLocalizations.of(context)!.pleaseEnterString;
                        if (nameController.text.isEmpty) {
                          showToast(
                            context: context,
                            fToast: fToast!,
                            msg:
                                '$enterMsg ${AppLocalizations.of(context)!.nameString.toLowerCase()}',
                            duration: 3,
                          );
                        } else if (phoneNumberController.text.isEmpty) {
                          showToast(
                            context: context,
                            fToast: fToast!,
                            msg:
                                '$enterMsg ${AppLocalizations.of(context)!.phoneNumberString.toLowerCase()}',
                            duration: 3,
                          );
                        } else if (licenceNumberController.text.isEmpty) {
                          showToast(
                            context: context,
                            fToast: fToast!,
                            msg:
                                '$enterMsg ${AppLocalizations.of(context)!.licenceNumberString.toLowerCase()}',
                            duration: 3,
                          );
                        } else if (frontAdhaar == null && backAdhaar == null) {
                          showToast(
                            context: context,
                            fToast: fToast!,
                            msg: '$uploadMsg ${AppLocalizations.of(context)!.adhaarCardString}',
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
                            msg: '$uploadMsg ${AppLocalizations.of(context)!.panCardString}',
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
                        } else if (frontLicence == null && backLicence == null) {
                          showToast(
                            context: context,
                            fToast: fToast!,
                            msg: '$uploadMsg ${AppLocalizations.of(context)!.licenceString}',
                            duration: 3,
                          );
                        } else if (frontLicence == null) {
                          showToast(
                            context: context,
                            fToast: fToast!,
                            msg:
                                '$uploadMsg ${AppLocalizations.of(context)!.frontSideString.toLowerCase()} ${AppLocalizations.of(context)!.licenceString}',
                            duration: 3,
                          );
                        } else if (backLicence == null) {
                          showToast(
                            context: context,
                            fToast: fToast!,
                            msg:
                                '$uploadMsg ${AppLocalizations.of(context)!.backSide.toLowerCase()}  ${AppLocalizations.of(context)!.licenceString}',
                            duration: 3,
                          );
                        } else if (driverPhoto == null) {
                          showToast(
                            context: context,
                            fToast: fToast!,
                            msg: '$uploadMsg  ${AppLocalizations.of(context)!.photoString}',
                            duration: 3,
                          );
                        } else {
                          authCubit.saveDriverDetails(
                            driverName: nameController.text,
                            driverPhoneNumber: phoneNumberController.text,
                            driverLicenceNumber: licenceNumberController.text,
                            driverFrontAdhaar: frontAdhaar ?? File(''),
                            driverBackAdhaar: backAdhaar ?? File(''),
                            driverFrontPan: frontPan ?? File(''),
                            driverBackPan: backPan ?? File(''),
                            driverFrontLicence: frontLicence ?? File(''),
                            driverBackLicence: backLicence ?? File(''),
                            driverPhoto: driverPhoto ?? File(''),
                          );

                          await authCubit.submitOwnerDriverVehiclDetails();
                        }
                      },
                      textPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      nameSize: 22,
                    ),
            ),
            const SizedBox(height: 20),
            loading ? LoadingWithoutText() : SizedBox.shrink(),
            errorMessage != null
                ? Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                    child: Center(
                      child: Text(
                        errorMessage ?? '',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.red,
                            ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
