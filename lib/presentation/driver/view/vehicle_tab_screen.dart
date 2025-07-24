import 'dart:io';

import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/authentication/model/vehicle_type_response_model.dart';
import 'package:globeporter/presentation/driver/widgets/info_field_widget.dart';
import 'package:globeporter/presentation/driver/widgets/upload_widget.dart';
import 'package:globeporter/resources/app_colors.dart';
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
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController vehicleRcController = TextEditingController();

  Data? selectedVehicleType;
  File? frontRc;
  File? backRc;
  File? vehiclePhoto;
  VehicleTypeResponseModel? vehicleTypeResponse;

  final authCubit = sl<AuthCubit>();
  FToast? fToast;

  void getVehicleType() async {
    await authCubit.getVehicleType();
  }

  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);
    vehicleNumberController.text = authCubit.vehicleNo ?? '';
    vehicleRcController.text = authCubit.vehicleRC ?? '';
    selectedVehicleType = vehicleTypeResponse?.data?.firstWhere(
      (d) => d?.id.toString() == authCubit.vehicleTypeId,
      orElse: () => null,
    );
    frontRc = authCubit.vehicleFrontRC;
    backRc = authCubit.vehicleBackRC;
    vehiclePhoto = authCubit.vehiclePhoto;

    getVehicleType();
    super.initState();
  }

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
            onPressed: () {
              var uploadMsg =
                  '${AppLocalizations.of(context)!.pleaseUploadString} ${AppLocalizations.of(context)!.vehicleString.toLowerCase()}';
              var enterMsg = AppLocalizations.of(context)!.pleaseEnterString;
              if (vehicleNumberController.text.isEmpty) {
                showToast(
                  context: context,
                  fToast: fToast!,
                  msg: '$enterMsg ${AppLocalizations.of(context)!.vehicleNo.toLowerCase()}',
                  duration: 3,
                );
              } else if (vehicleRcController.text.isEmpty) {
                showToast(
                  context: context,
                  fToast: fToast!,
                  msg: '$enterMsg ${AppLocalizations.of(context)!.vehicleRcString.toLowerCase()}',
                  duration: 3,
                );
              } else if (selectedVehicleType == null) {
                showToast(
                  context: context,
                  fToast: fToast!,
                  msg: '$enterMsg ${AppLocalizations.of(context)!.vehicleTypeString.toLowerCase()}',
                  duration: 3,
                );
              } else if (frontRc == null && backRc == null) {
                showToast(
                  context: context,
                  fToast: fToast!,
                  msg: '$uploadMsg ${AppLocalizations.of(context)!.rcString}',
                  duration: 3,
                );
              } else if (frontRc == null) {
                showToast(
                  context: context,
                  fToast: fToast!,
                  msg:
                      '$uploadMsg ${AppLocalizations.of(context)!.frontSideString.toLowerCase()} ${AppLocalizations.of(context)!.rcString}',
                  duration: 3,
                );
              } else if (backRc == null) {
                showToast(
                  context: context,
                  fToast: fToast!,
                  msg:
                      '$uploadMsg ${AppLocalizations.of(context)!.backSide.toLowerCase()} ${AppLocalizations.of(context)!.rcString}',
                  duration: 3,
                );
              } else if (vehiclePhoto == null) {
                showToast(
                  context: context,
                  fToast: fToast!,
                  msg: '$uploadMsg  ${AppLocalizations.of(context)!.photoString}',
                  duration: 3,
                );
              } else {
                authCubit.saveVehicleDetails(
                  vehicleNo: vehicleNumberController.text,
                  vehicleRC: vehicleRcController.text,
                  vehicleTypeId: selectedVehicleType!.id.toString(),
                  vehicleFrontRC: frontRc ?? File(''),
                  vehicleBackRC: backRc ?? File(''),
                  vehiclePhoto: vehiclePhoto ?? File(''),
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
      body: BlocListener(
        bloc: authCubit,
        listener: (final context, final state) {
          if (state is VehicleTypeLoadedState) {
            setState(() {
              vehicleTypeResponse = state.data as VehicleTypeResponseModel?;
            });
          }
        },
        child: SingleChildScrollView(
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButtonFormField2<Data>(
                  value: selectedVehicleType,
                  isExpanded: true,
                  iconStyleData: IconStyleData(icon: const Icon(Icons.keyboard_arrow_down)),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    maxHeight: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: secondaryColor,
                    ),
                    offset: const Offset(0, -4),
                    scrollbarTheme: ScrollbarThemeData(
                      thumbColor: WidgetStateProperty.all(primaryColor),
                      radius: const Radius.circular(4),
                    ),
                  ),
                  items: vehicleTypeResponse?.data?.map((Data? item) {
                    return DropdownMenuItem<Data>(
                      value: item,
                      child: Text(
                        item?.name ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedVehicleType = val;
                    });
                  },
                ),
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
                uploaded: (frontRc != null && backRc != null),
                onTap: () {
                  context.pushNamed(
                    uploadDocumentScreen,
                    extra: {
                      'type': 'vehicle_rc',
                      'title': AppLocalizations.of(context)!.uploadRcString,
                      'hintText':
                          '${AppLocalizations.of(context)!.uploadRcString} (${AppLocalizations.of(context)!.frontSideString})',
                      'imageList': [frontRc, backRc],
                      'onImageCaptured': (File? file, bool? front) {
                        if (front ?? false) {
                          setState(() {
                            frontRc = file;
                          });
                        } else {
                          setState(() {
                            backRc = file;
                          });
                        }
                        debugPrint(
                            "Captured file path: Front:  ${frontRc?.path} : back: ${backRc?.path}");
                      },
                      'front': true,
                    },
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              UploadWidget(
                text: AppLocalizations.of(context)!.vehiclePhotoString,
                uploaded: (vehiclePhoto != null),
                onTap: () {
                  context.pushNamed(
                    normalUploadScreen,
                    extra: {
                      'title': AppLocalizations.of(context)!.vehiclePhotoString,
                      'image': vehiclePhoto,
                      'onImageCaptured': (File? file) {
                        setState(() {
                          vehiclePhoto = file;
                        });
                        debugPrint("Captured file path: Vehicle:  ${vehiclePhoto?.path}");
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
      ),
    );
  }
}
