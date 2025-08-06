import 'dart:io';

import 'package:core/app_widgets.dart';
import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:datasource/states/data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:globeporter/presentation/driver/cubit/driver_details_cubit.dart';
import 'package:globeporter/presentation/driver/states/driver_states.dart';
import 'package:globeporter/presentation/driver/widgets/info_field_widget.dart';
import 'package:globeporter/presentation/driver/widgets/upload_widget.dart';
import 'package:globeporter/resources/app_extension_functions.dart';
import 'package:globeporter/resources/app_regex.dart';
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

  FocusNode nameFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode licenceFocusNode = FocusNode();

  final driverCubit = sl<DriverDetailsCubit>();
  FToast? fToast;
  bool loading = false;
  String? errorMessage;

  void _driverNameListener() {
    driverCubit.updateDriverName(nameController.text);
  }

  void _driverPhoneListener() {
    driverCubit.updateDriverPhoneNumber(phoneNumberController.text);
  }

  void _driverLicenceListener() {
    driverCubit.updateDriverLicenceNumber(licenceNumberController.text);
  }

  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);

    nameController.text = driverCubit.driverName ?? '';
    phoneNumberController.text = driverCubit.driverPhoneNumber ?? '';
    licenceNumberController.text = driverCubit.driverLicenceNumber ?? '';
    frontAdhaar = driverCubit.driverFrontAdhaar;
    backAdhaar = driverCubit.driverBackAdhaar;
    frontPan = driverCubit.driverFrontPan;
    backPan = driverCubit.driverBackPan;
    frontLicence = driverCubit.driverFrontLicence;
    backLicence = driverCubit.driverBackLicence;
    driverPhoto = driverCubit.driverPhoto;

    nameController.addListener(_driverNameListener);
    phoneNumberController.addListener(_driverPhoneListener);
    licenceNumberController.addListener(_driverLicenceListener);

    super.initState();
  }

  @override
  void dispose() {
    nameController.removeListener(_driverNameListener);
    phoneNumberController.removeListener(_driverPhoneListener);
    licenceNumberController.removeListener(_driverLicenceListener);
    nameController.dispose();
    phoneNumberController.dispose();
    licenceNumberController.dispose();
    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    licenceFocusNode.dispose();
    super.dispose();
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
              focusNode: nameFocusNode,
              title: AppLocalizations.of(context)!.nameString,
              controller: nameController,
              inputFormatter: [
                FilteringTextInputFormatter.allow(nameRegex),
              ],
              inputType: TextInputType.name,
              hint: 'eg. Jon Doe',
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(phoneFocusNode);
              },
            ),
            InfoFieldWidget(
              focusNode: phoneFocusNode,
              title: AppLocalizations.of(context)!.phoneNumberString,
              controller: phoneNumberController,
              hint: '91XXXXXXXX',
              inputFormatter: [
                FilteringTextInputFormatter.allow(phoneNumberRegex),
                LengthLimitingTextInputFormatter(10),
              ],
              inputType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(licenceFocusNode);
              },
            ),
            InfoFieldWidget(
              focusNode: licenceFocusNode,
              title: AppLocalizations.of(context)!.licenceNumberString,
              controller: licenceNumberController,
              hint: 'MH1220190000001',
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.characters,
              inputFormatter: [
                FilteringTextInputFormatter.allow(RegExp('[A-Z0-9]')),
                LengthLimitingTextInputFormatter(16),
              ],
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
              uploaded: (frontAdhaar != null && backAdhaar != null),
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
                          driverCubit.updateDriverFrontAdhaar(file);
                        });
                      } else {
                        setState(() {
                          backAdhaar = file;
                          driverCubit.updateDriverBackAdhaar(file);
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
              uploaded: (frontPan != null && backPan != null),
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
                          driverCubit.updateDriverFrontPan(file);
                        });
                      } else {
                        setState(() {
                          backPan = file;
                          driverCubit.updateDriverBackPan(file);
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
              uploaded: (frontLicence != null && backLicence != null),
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
                          driverCubit.updateDriverFrontLicence(file);
                        });
                      } else {
                        setState(() {
                          backLicence = file;
                          driverCubit.updateDriverBackLicence(file);
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
              uploaded: driverPhoto != null,
              onTap: () {
                context.pushNamed(
                  normalUploadScreen,
                  extra: {
                    'title': AppLocalizations.of(context)!.driverPhotoString,
                    'image': driverPhoto,
                    'onImageCaptured': (File? file) {
                      setState(() {
                        driverPhoto = file;
                        driverCubit.updateDriverPhoto(file);
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
              bloc: driverCubit,
              listener: (final context, final state) {
                if (state is SaveDriverDetailsLoadingState) {
                  setState(() {
                    loading = true;
                  });
                } else if (state is SaveDriverDetailsLoadedState) {
                  context.go(documentVerificationScreen);
                  setState(() {
                    loading = false;
                  });
                } else if (state is ErrorState) {
                  setState(() {
                    loading = false;
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
                        } else if (phoneNumberController.text.isEmpty ||
                            phoneNumberController.text.length < 10 ||
                            phoneNumberController.text.length > 10) {
                          showToast(
                            context: context,
                            fToast: fToast!,
                            msg:
                                '$enterMsg ${AppLocalizations.of(context)!.validString} ${AppLocalizations.of(context)!.phoneNumberString.toLowerCase()}',
                            duration: 3,
                          );
                        } else if (licenceNumberController.text.isEmpty ||
                            !licenceNumberController.text.isValidLicenceNumber()) {
                          showToast(
                            context: context,
                            fToast: fToast!,
                            msg:
                                '$enterMsg ${AppLocalizations.of(context)!.validString} ${AppLocalizations.of(context)!.licenceNumberString.toLowerCase()}',
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
                          driverCubit.saveDriverDetails(
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

                          await driverCubit.submitDriverDetails();
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
