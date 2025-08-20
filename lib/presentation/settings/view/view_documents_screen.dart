import 'dart:io';

import 'package:core/app_widgets.dart';
import 'package:core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/driver/cubit/driver_details_cubit.dart';
import 'package:globeporter/presentation/driver/states/driver_states.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class ViewUploadedDocuments extends StatefulWidget {
  const ViewUploadedDocuments({super.key});

  @override
  State<ViewUploadedDocuments> createState() => _ViewUploadedDocumentsState();
}

class _ViewUploadedDocumentsState extends State<ViewUploadedDocuments> {
  final driverCubit = sl<DriverDetailsCubit>();
  bool loading = false;

  void getDetails() async {
    await driverCubit.getAllDocs();
  }

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.35),
        child: CustomStatusBarWidget(
          title: ' ${AppLocalizations.of(context)!.documentsString} ',
          fontSize: 18,
        ),
      ),
      body: BlocBuilder(
        bloc: driverCubit,
        builder: (final context, final state) {
          if (state is AllDocumentsLoadingState ||
              state is GetOwnerDetailsLoadingState ||
              state is GetVehicleDetailsLoadingState ||
              state is GetDriverDetailsLoadingState) {
            return Center(
              child: LoadingWithoutText(),
            );
          } else if (state is AllDocumentsLoadedState) {
            final list = state.data as List<File?>;
            final List<Map<String, dynamic>> docList = [
              {
                'title':
                    '${AppLocalizations.of(context)!.ownerAdhaarCardString} ${AppLocalizations.of(context)!.frontSideString}',
                'file': list[0],
              },
              {
                'title':
                    '${AppLocalizations.of(context)!.ownerAdhaarCardString} ${AppLocalizations.of(context)!.backSide}',
                'file': list[1],
              },
              {
                'title':
                    '${AppLocalizations.of(context)!.ownerPanCardString} ${AppLocalizations.of(context)!.frontSideString}',
                'file': list[2],
              },
              {
                'title':
                    '${AppLocalizations.of(context)!.ownerPanCardString} ${AppLocalizations.of(context)!.backSide}',
                'file': list[3],
              },
              {
                'title':
                    '${AppLocalizations.of(context)!.ownerString} ${AppLocalizations.of(context)!.photoString}',
                'file': list[4],
              },
              {
                'title':
                    '${AppLocalizations.of(context)!.vehicleRcString} ${AppLocalizations.of(context)!.frontSideString}',
                'file': list[5],
              },
              {
                'title':
                    '${AppLocalizations.of(context)!.vehicleRcString} ${AppLocalizations.of(context)!.backSide}',
                'file': list[6],
              },
              {
                'title':
                    '${AppLocalizations.of(context)!.vehicleString} ${AppLocalizations.of(context)!.photoString}',
                'file': list[7],
              },
              {
                'title':
                    '${AppLocalizations.of(context)!.driverAdhaarCardString} ${AppLocalizations.of(context)!.frontSideString}',
                'file': list[8],
              },
              {
                'title':
                    '${AppLocalizations.of(context)!.driverAdhaarCardString} ${AppLocalizations.of(context)!.backSide}',
                'file': list[9],
              },
              {
                'title':
                    '${AppLocalizations.of(context)!.driverPanCardString} ${AppLocalizations.of(context)!.frontSideString}',
                'file': list[10],
              },
              {
                'title':
                    '${AppLocalizations.of(context)!.driverPanCardString} ${AppLocalizations.of(context)!.backSide}',
                'file': list[11],
              },
              {
                'title':
                    '${AppLocalizations.of(context)!.driverLicenceString} ${AppLocalizations.of(context)!.frontSideString}',
                'file': list[12],
              },
              {
                'title':
                    '${AppLocalizations.of(context)!.driverLicenceString} ${AppLocalizations.of(context)!.backSide}',
                'file': list[13],
              },
              {
                'title': AppLocalizations.of(context)!.driverPhotoString,
                'file': list[14],
              },
            ];

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ...docList.map((doc) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.white, border: Border.all(color: secondaryColor)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(text: doc['title']),
                            TextButton(
                              onPressed: () {
                                if (doc['file'] != null) {
                                  context.pushNamed(
                                    fullImagePreviewScreen,
                                    extra: {'imageFile': doc['file']},
                                  );
                                }
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.camera_alt_outlined,
                                    color: primaryColor,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.viewString,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: primaryColor),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
