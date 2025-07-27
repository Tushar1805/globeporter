import 'dart:io';

import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/driver/cubit/driver_cubit.dart';
import 'package:globeporter/presentation/driver/model/verification_status_response.dart';
import 'package:globeporter/presentation/driver/states/driver_states.dart';
import 'package:globeporter/presentation/driver/widgets/upload_widget.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DocumentVerificationScreen extends StatefulWidget {
  const DocumentVerificationScreen({super.key});

  @override
  State<DocumentVerificationScreen> createState() => _DocumentVerificationScreenState();
}

class _DocumentVerificationScreenState extends State<DocumentVerificationScreen> {
  bool isVerified = false;
  final authCubit = sl<AuthCubit>();
  final driverCubit = sl<DriverCubit>();
  VerificationStatusResponse? verificationStatus;
  List<String?> failedTypes = [];
  List<String?> localFailedTypes = [];

  File? ownerFrontAdhaar;
  File? ownerBackAdhaar;
  File? ownerFrontPan;
  File? ownerBackPan;
  File? ownerPhoto;
  File? vehicleFrontRc;
  File? vehicleBackRc;
  File? vehiclePhoto;
  File? driverFrontAdhaar;
  File? driverBackAdhaar;
  File? driverFrontPan;
  File? driverBackPan;
  File? driverFrontLicence;
  File? driverBackLicence;
  File? driverPhoto;
  FToast? fToast;
  void getDetails() async {
    await authCubit.getUserDetails();
    await driverCubit.getVerificationStatus();
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast!.init(context);
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final steps = [
      _StepData(
        title: AppLocalizations.of(context)!.uploadDocumentString,
        subtitle:
            '${AppLocalizations.of(context)!.driverLicenceString}, ${AppLocalizations.of(context)!.adhaarCardString}, ${AppLocalizations.of(context)!.etcString}',
        isCompleted: true,
      ),
      _StepData(
        title: AppLocalizations.of(context)!.verificationString,
        subtitle: AppLocalizations.of(context)!.verificationInProcessString,
        isCompleted: isVerified,
        isCurrent: true,
      ),
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.35),
        child: CustomStatusBarWidget(
          title:
              ' ${AppLocalizations.of(context)!.hiString} ${authCubit.userDetails?.data?.name ?? 'Jon Doe'}',
          fontSize: 18,
        ),
      ),
      body: BlocListener(
        bloc: driverCubit,
        listener: (final context, final state) {
          if (state is VerificationStatusLoadedState) {
            setState(() {
              verificationStatus = state.data as VerificationStatusResponse?;
              isVerified = verificationStatus?.isDocVerified == 1;
              failedTypes = verificationStatus?.data?.map((e) => e.type).toSet().toList() ?? [];
              localFailedTypes = List<String>.from(failedTypes);
            });
            customPrint(failedTypes.toList().toString());
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.fewStepsAwayString,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ...List.generate(steps.length, (index) {
                final step = steps[index];
                return _StepItem(step: step, index: index + 1);
              }),
              const SizedBox(height: 24),
              ...localFailedTypes.map((type) {
                if ([
                  'owner_aadhar',
                  'owner_pan',
                  'driver_aadhar',
                  'driver_pan',
                  'driver_licence',
                  'vehicle_rc'
                ].contains(type)) {
                  if ((type == 'owner_aadhar' && failedTypes.contains('owner_aadhar')) ||
                      (type == 'owner_pan' && failedTypes.contains('owner_pan')) ||
                      (type == 'driver_aadhar' && failedTypes.contains('driver_aadhar')) ||
                      (type == 'driver_pan' && failedTypes.contains('driver_pan')) ||
                      (type == 'driver_licence' && failedTypes.contains('driver_licence')) ||
                      (type == 'vehicle_rc' && failedTypes.contains('vehicle_rc'))) {
                    // failedTypes.remove(type); // Prevent duplicate widgets
                    if (type == 'owner_aadhar') {
                      return UploadWidget(
                        text: AppLocalizations.of(context)!.ownerAdhaarCardString,
                        uploaded: (ownerFrontAdhaar != null && ownerBackAdhaar != null),
                        onTap: () {
                          context.pushNamed(
                            uploadDocumentScreen,
                            extra: {
                              'type': 'own_adhar',
                              'title': AppLocalizations.of(context)!.ownerAdhaarCardString,
                              'hintText':
                                  '${AppLocalizations.of(context)!.ownerAdhaarCardString} (${AppLocalizations.of(context)!.frontSideString})',
                              'imageList': [ownerFrontAdhaar, ownerBackAdhaar],
                              'onImageCaptured': (File? file, bool? front) {
                                if (front ?? false) {
                                  setState(() {
                                    ownerFrontAdhaar = file;
                                  });
                                } else {
                                  setState(() {
                                    ownerBackAdhaar = file;
                                  });
                                }
                              },
                              'front': true,
                            },
                          );
                        },
                      );
                    } else if (type == 'owner_pan') {
                      return UploadWidget(
                        text: AppLocalizations.of(context)!.ownerPanCardString,
                        uploaded: (ownerFrontPan != null && ownerBackPan != null),
                        onTap: () {
                          context.pushNamed(
                            uploadDocumentScreen,
                            extra: {
                              'type': 'own_pan',
                              'title': AppLocalizations.of(context)!.ownerPanCardString,
                              'hintText':
                                  '${AppLocalizations.of(context)!.ownerPanCardString} (${AppLocalizations.of(context)!.frontSideString})',
                              'imageList': [ownerFrontPan, ownerBackPan],
                              'onImageCaptured': (File? file, bool? front) {
                                if (front ?? false) {
                                  setState(() {
                                    ownerFrontPan = file;
                                  });
                                } else {
                                  setState(() {
                                    ownerBackPan = file;
                                  });
                                }
                              },
                              'front': true,
                            },
                          );
                        },
                      );
                    } else if (type == 'driver_aadhar') {
                      return UploadWidget(
                        text: AppLocalizations.of(context)!.driverAdhaarCardString,
                        uploaded: (driverFrontAdhaar != null && driverBackAdhaar != null),
                        onTap: () {
                          context.pushNamed(
                            uploadDocumentScreen,
                            extra: {
                              'type': 'driver_aadhar',
                              'title': AppLocalizations.of(context)!.driverAdhaarCardString,
                              'hintText':
                                  '${AppLocalizations.of(context)!.driverAdhaarCardString} (${AppLocalizations.of(context)!.frontSideString})',
                              'imageList': [driverFrontAdhaar, driverBackAdhaar],
                              'onImageCaptured': (File? file, bool? front) {
                                if (front ?? false) {
                                  setState(() {
                                    driverFrontAdhaar = file;
                                  });
                                } else {
                                  setState(() {
                                    driverBackAdhaar = file;
                                  });
                                }
                              },
                              'front': true,
                            },
                          );
                        },
                      );
                    } else if (type == 'driver_pan') {
                      return UploadWidget(
                        text: AppLocalizations.of(context)!.driverPanCardString,
                        uploaded: (driverFrontPan != null && driverBackPan != null),
                        onTap: () {
                          context.pushNamed(
                            uploadDocumentScreen,
                            extra: {
                              'type': 'driver_pan',
                              'title': AppLocalizations.of(context)!.driverPanCardString,
                              'hintText':
                                  '${AppLocalizations.of(context)!.driverPanCardString} (${AppLocalizations.of(context)!.frontSideString})',
                              'imageList': [driverFrontPan, driverBackPan],
                              'onImageCaptured': (File? file, bool? front) {
                                if (front ?? false) {
                                  setState(() {
                                    driverFrontPan = file;
                                  });
                                } else {
                                  setState(() {
                                    driverBackPan = file;
                                  });
                                }
                              },
                              'front': true,
                            },
                          );
                        },
                      );
                    } else if (type == 'driver_licence') {
                      return UploadWidget(
                        text: AppLocalizations.of(context)!.driverLicenceString,
                        uploaded: (driverFrontLicence != null && driverBackLicence != null),
                        onTap: () {
                          context.pushNamed(
                            uploadDocumentScreen,
                            extra: {
                              'type': 'driver_licence',
                              'title': AppLocalizations.of(context)!.driverLicenceString,
                              'hintText':
                                  '${AppLocalizations.of(context)!.driverLicenceString} (${AppLocalizations.of(context)!.frontSideString})',
                              'imageList': [driverFrontLicence, driverBackLicence],
                              'onImageCaptured': (File? file, bool? front) {
                                if (front ?? false) {
                                  setState(() {
                                    driverFrontLicence = file;
                                  });
                                } else {
                                  setState(() {
                                    driverBackLicence = file;
                                  });
                                }
                              },
                              'front': true,
                            },
                          );
                        },
                      );
                    } else if (type == 'vehicle_rc') {
                      return UploadWidget(
                        text: AppLocalizations.of(context)!.vehicleRcString,
                        uploaded: (vehicleFrontRc != null && vehicleBackRc != null),
                        onTap: () {
                          context.pushNamed(
                            uploadDocumentScreen,
                            extra: {
                              'type': 'vehicle_rc',
                              'title': AppLocalizations.of(context)!.vehicleRcString,
                              'hintText':
                                  '${AppLocalizations.of(context)!.vehicleRcString} (${AppLocalizations.of(context)!.frontSideString})',
                              'imageList': [vehicleFrontRc, vehicleBackRc],
                              'onImageCaptured': (File? file, bool? front) {
                                if (front ?? false) {
                                  setState(() {
                                    vehicleFrontRc = file;
                                  });
                                } else {
                                  setState(() {
                                    vehicleBackRc = file;
                                  });
                                }
                              },
                              'front': true,
                            },
                          );
                        },
                      );
                    }
                  }
                } else if (['owner_photo', 'driver_photo', 'vehicle_photo'].contains(type)) {
                  if (type == 'owner_photo') {
                    return UploadWidget(
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
                            },
                          },
                        );
                      },
                    );
                  } else if (type == 'driver_photo') {
                    return UploadWidget(
                      text:
                          '${AppLocalizations.of(context)!.driverString} ${AppLocalizations.of(context)!.photoString}',
                      uploaded: driverPhoto != null,
                      onTap: () {
                        context.pushNamed(
                          normalUploadScreen,
                          extra: {
                            'title':
                                '${AppLocalizations.of(context)!.driverString} ${AppLocalizations.of(context)!.photoString}',
                            'image': driverPhoto,
                            'onImageCaptured': (File? file) {
                              setState(() {
                                driverPhoto = file;
                              });
                            },
                          },
                        );
                      },
                    );
                  } else if (type == 'vehicle_photo') {
                    return UploadWidget(
                      text:
                          '${AppLocalizations.of(context)!.vehicleString} ${AppLocalizations.of(context)!.photoString}',
                      uploaded: vehiclePhoto != null,
                      onTap: () {
                        context.pushNamed(
                          normalUploadScreen,
                          extra: {
                            'title':
                                '${AppLocalizations.of(context)!.vehicleString} ${AppLocalizations.of(context)!.photoString}',
                            'image': vehiclePhoto,
                            'onImageCaptured': (File? file) {
                              setState(() {
                                vehiclePhoto = file;
                              });
                            },
                          },
                        );
                      },
                    );
                  }
                }
                return const SizedBox.shrink();
              }),
              const SizedBox(height: 24),
              if (verificationStatus?.data?.isNotEmpty ?? false)
                BlocListener(
                  bloc: driverCubit,
                  listener: (final context, final state) {
                    if (state is ReSubmitDocumentsLoadedState) {
                      showToast(
                        context: context,
                        fToast: fToast!,
                        msg: AppLocalizations.of(context)!.reUploadString,
                        duration: 3,
                      );
                    }
                  },
                  child: CustomElevatedButton(
                    name: AppLocalizations.of(context)!.submitString,
                    borderRadius: 25,
                    alignment: Alignment.bottomCenter,
                    onPressed: () async {
                      await driverCubit.reSubmitDocuments(
                        driverFrontAdhaar: driverFrontAdhaar,
                        driverBackAdhaar: driverBackAdhaar,
                        driverFrontPan: driverFrontPan,
                        driverBackPan: driverBackPan,
                        driverFrontLicence: driverFrontLicence,
                        driverBackLicence: driverBackLicence,
                        driverPhoto: driverPhoto,
                        vehicleFrontRC: vehicleFrontRc,
                        vehicleBackRC: vehicleBackRc,
                        vehiclePhoto: vehiclePhoto,
                        ownerFrontAdhaar: ownerFrontAdhaar,
                        ownerBackAdhaar: ownerBackAdhaar,
                        ownerFrontPan: ownerFrontPan,
                        ownerBackPan: ownerBackPan,
                        ownerPhoto: ownerPhoto,
                      );
                    },
                    textPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    nameSize: 22,
                  ),
                ),
              const SizedBox(height: 24),
              if (steps.last.isCurrent)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (isVerified) {
                        context.go(driverDashboard);
                      }
                    },
                    icon: const Icon(Icons.arrow_forward, color: whiteColor),
                    label: Text(
                      AppLocalizations.of(context)!.goString,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: whiteColor, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isVerified ? primaryColor : Colors.grey.shade500,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
// ---------------- Helper Widgets ----------------

class _StepData {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isCurrent;

  _StepData({
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    this.isCurrent = false,
  });
}

class _StepItem extends StatelessWidget {
  final _StepData step;
  final int index;

  const _StepItem({required this.step, required this.index});

  @override
  Widget build(BuildContext context) {
    final icon = step.isCompleted
        ? const Icon(Icons.check_circle, color: primaryColor)
        : step.isCurrent
            ? CircleAvatar(
                radius: 12,
                backgroundColor: Colors.yellow,
                child: Text(
                  '$index',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            : CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey.shade300,
                child: Text(
                  '$index',
                  style: const TextStyle(color: Colors.black),
                ),
              );

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(step.subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey, fontSize: 14)),
                  step.isCompleted
                      ? Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(AppLocalizations.of(context)!.uploadedString,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: primaryColor, fontSize: 16)),
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(AppLocalizations.of(context)!.pendingString,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.amber, fontSize: 16)),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
