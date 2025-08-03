import 'dart:io';

import 'package:core/app_widgets.dart';
import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:datasource/states/data_state.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:globeporter/presentation/authentication/model/vehicle_type_response_model.dart';
import 'package:globeporter/presentation/driver/cubit/driver_details_cubit.dart';
import 'package:globeporter/presentation/driver/states/driver_states.dart';
import 'package:globeporter/presentation/driver/widgets/info_field_widget.dart';
import 'package:globeporter/presentation/driver/widgets/upload_widget.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_extension_functions.dart';
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
  String errorMessage = '';

  FocusNode vehicleNumberFocusNode = FocusNode();
  FocusNode vehicleRcFocusNode = FocusNode();

  final driverCubit = sl<DriverDetailsCubit>();
  FToast? fToast;
  bool loading = false;

  void getVehicleType() async {
    await driverCubit.getVehicleType();
  }

  void _vehicleNumberListener() {
    driverCubit.updateVehicleNo(vehicleNumberController.text);
  }

  void _vehicleRcListener() {
    driverCubit.updateVehicleRC(vehicleRcController.text);
  }

  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);
    vehicleNumberController.text = driverCubit.vehicleNo ?? '';
    vehicleRcController.text = driverCubit.vehicleRC ?? '';
    frontRc = driverCubit.vehicleFrontRC;
    backRc = driverCubit.vehicleBackRC;
    vehiclePhoto = driverCubit.vehiclePhoto;

    vehicleNumberController.addListener(_vehicleNumberListener);
    vehicleRcController.addListener(_vehicleRcListener);

    if (selectedVehicleType == null) {
      getVehicleType();
    }
    super.initState();
  }

  Data? findVehicleById(List<Data?> list, String? id) {
    for (var item in list) {
      if (item?.id.toString() == id) return item;
    }
    return null;
  }

  @override
  void dispose() {
    vehicleNumberController.removeListener(_vehicleNumberListener);
    vehicleRcController.removeListener(_vehicleRcListener);
    vehicleNumberController.dispose();
    vehicleRcController.dispose();
    vehicleNumberFocusNode.dispose();
    vehicleRcFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white60,
      floatingActionButton: loading
          ? SizedBox(
              height: size.width * 0.15,
              child: Align(alignment: Alignment.bottomCenter, child: LoadingWithoutText()),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomElevatedButton(
                  name: AppLocalizations.of(context)!.goString,
                  borderRadius: 4,
                  alignment: Alignment.bottomRight,
                  onPressed: () async {
                    var uploadMsg =
                        '${AppLocalizations.of(context)!.pleaseUploadString} ${AppLocalizations.of(context)!.vehicleString.toLowerCase()}';
                    var enterMsg =
                        '${AppLocalizations.of(context)!.pleaseEnterString} ${AppLocalizations.of(context)!.validString}';
                    if (vehicleNumberController.text.isEmpty ||
                        !vehicleNumberController.text.isValidVehicleNumber()) {
                      showToast(
                        context: context,
                        fToast: fToast!,
                        msg: '$enterMsg ${AppLocalizations.of(context)!.vehicleNo.toLowerCase()}',
                        duration: 3,
                      );
                    } else if (vehicleRcController.text.isEmpty ||
                        !vehicleRcController.text.isValidRCNumber()) {
                      showToast(
                        context: context,
                        fToast: fToast!,
                        msg:
                            '$enterMsg ${AppLocalizations.of(context)!.vehicleRcString.toLowerCase()}',
                        duration: 3,
                      );
                    } else if (selectedVehicleType == null) {
                      showToast(
                        context: context,
                        fToast: fToast!,
                        msg:
                            '$enterMsg ${AppLocalizations.of(context)!.vehicleTypeString.toLowerCase()}',
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
                      driverCubit.saveVehicleDetails(
                        vehicleNo: vehicleNumberController.text,
                        vehicleRC: vehicleRcController.text,
                        vehicleTypeId: selectedVehicleType!.id.toString(),
                        vehicleFrontRC: frontRc ?? File(''),
                        vehicleBackRC: backRc ?? File(''),
                        vehiclePhoto: vehiclePhoto ?? File(''),
                      );
                      await driverCubit.submitVehicleDetails();
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
        bloc: driverCubit,
        listener: (final context, final state) {
          if (state is VehicleTypeLoadedState) {
            setState(() {
              vehicleTypeResponse = state.data as VehicleTypeResponseModel?;
            });
            final dataList = vehicleTypeResponse?.data;
            setState(() {
              selectedVehicleType = findVehicleById(dataList!, driverCubit.vehicleTypeId);
              vehicleNumberController.text = driverCubit.vehicleNo ?? '';
              vehicleRcController.text = driverCubit.vehicleRC ?? '';
              frontRc = driverCubit.vehicleFrontRC;
              backRc = driverCubit.vehicleBackRC;
              vehiclePhoto = driverCubit.vehiclePhoto;
            });
          } else if (state is SaveVehicleDetailsLoadedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.animateToPage();
            });
            setState(() {
              loading = false;
            });
          } else if (state is SaveVehicleDetailsLoadingState) {
            setState(() {
              loading = true;
            });
          } else if (state is ErrorState) {
            setState(() {
              loading = false;
              errorMessage = state.errorMessage;
            });
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoFieldWidget(
                focusNode: vehicleNumberFocusNode,
                title: AppLocalizations.of(context)!.vehicleNo,
                controller: vehicleNumberController,
                hint: 'MP20VSXXXX',
                textCapitalization: TextCapitalization.characters,
                inputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp('[A-Z0-9]')),
                  LengthLimitingTextInputFormatter(10), // Max length for format like MP20VS1234
                ],
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(vehicleRcFocusNode);
                },
              ),
              InfoFieldWidget(
                focusNode: vehicleRcFocusNode,
                title: AppLocalizations.of(context)!.vehicleRcString,
                controller: vehicleRcController,
                hint: 'FSSDGGSA3XXXXX',
                textCapitalization: TextCapitalization.characters,
                inputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp('[A-Z0-9]')),
                  LengthLimitingTextInputFormatter(17),
                ],
                textInputAction: TextInputAction.done,
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
                      driverCubit.updateVehicleTypeId(val?.id.toString());
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
                            driverCubit.updateFrontRC(file);
                          });
                        } else {
                          setState(() {
                            backRc = file;
                            driverCubit.updateBackRC(file);
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
                          driverCubit.updateVehiclePhoto(file);
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
              errorMessage != ''
                  ? Padding(
                      padding: EdgeInsetsGeometry.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          errorMessage,
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
      ),
    );
  }
}
