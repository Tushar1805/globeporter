import 'dart:io';

import 'package:core/app_widgets.dart';
import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:datasource/states/data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/authentication/model/user_details_response_model.dart';
import 'package:globeporter/presentation/settings/cubit/settings_cubit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:globeporter/presentation/settings/states/settings_states.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_extension_functions.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_regex.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  final authCubit = sl<AuthCubit>();
  final settingsCubit = sl<SettingsCubit>();
  bool isEditingName = false;
  bool isEditingEmail = false;
  bool isEditingVehicleNo = false;
  bool isValidEmail = false;
  bool loading = false;
  String errorMessage = '';
  File? profilePhoto;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController vehicleNoController;
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _vehicleNoFocusNode = FocusNode();
  FToast? fToast;
  Data? userData;

  void getProfilePhoto(String url) async {
    profilePhoto = await authCubit.urlToFile(url);
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast!.init(context);
    userData = authCubit.userDetails?.data;
    if (userData?.profilePhotoUrl != null) {
      getProfilePhoto(userData?.profilePhotoUrl);
    }

    nameController = TextEditingController(text: userData?.name ?? '');
    emailController = TextEditingController(text: userData?.email ?? '');
    vehicleNoController = TextEditingController(text: userData?.vehicleDetailData?.vehicleNo);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    vehicleNoController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _vehicleNoFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.width * 0.45,
              child: Stack(
                children: [
                  Container(
                    height: size.width * 0.3326,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(size.width * 0.127),
                        bottomRight: Radius.circular(size.width * 0.127),
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.width * 0.2,
                    left: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: size.width * 0.12,
                      child: CircleAvatar(
                        radius: size.width * 0.116,
                        backgroundImage: profilePhoto != null
                            ? FileImage(profilePhoto!)
                            : (userData?.profilePhotoUrl != null
                                ? NetworkImage(userData!.profilePhotoUrl) as ImageProvider<Object>
                                : AssetImage(profileImage) as ImageProvider<Object>),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        context.pushNamed(
                          normalUploadScreen,
                          extra: {
                            'title':
                                '${AppLocalizations.of(context)!.profileString} ${AppLocalizations.of(context)!.photoString}',
                            'image': profilePhoto,
                            'onImageCaptured': (File? file) {
                              setState(() {
                                profilePhoto = file;
                              });
                              debugPrint("Captured file path: Vehicle:  ${profilePhoto?.path}");
                            },
                          },
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: size.width * 0.18),
                        child: CircleAvatar(
                          radius: 13,
                          backgroundColor: primaryColor,
                          child: CircleAvatar(
                            backgroundColor: whiteColor,
                            radius: 12,
                            child: Image.asset(
                              editIcon,
                              width: 15,
                              height: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ProfileEditCard(
              label: AppLocalizations.of(context)!.nameString,
              value: nameController.text,
              isEditing: isEditingName,
              widget: isEditingName
                  ? SizedBox(
                      width: double.infinity,
                      child: TextField(
                        focusNode: _nameFocusNode,
                        controller: nameController,
                        cursorColor: primaryColor,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                            ),
                        decoration: InputDecoration.collapsed(hintText: "Enter name"),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(nameRegex),
                        ],
                      ),
                    )
                  : null,
              onTap: () {
                setState(() {
                  isEditingName = !isEditingName;
                  if (isEditingName) {
                    _nameFocusNode.requestFocus();
                  } else {
                    _nameFocusNode.unfocus();
                  }
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ProfileEditCard(
              label: AppLocalizations.of(context)!.emailString,
              value: emailController.text,
              isEditing: isEditingEmail,
              widget: isEditingEmail
                  ? SizedBox(
                      width: double.infinity,
                      child: TextField(
                        focusNode: _emailFocusNode,
                        controller: emailController,
                        cursorColor: primaryColor,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                            ),
                        decoration: InputDecoration.collapsed(hintText: "Enter Email"),
                        onChanged: (final value) {
                          setState(() {
                            isValidEmail = value.isValidEmail();
                          });
                        },
                      ),
                    )
                  : null,
              onTap: () {
                setState(() {
                  isEditingEmail = !isEditingEmail;
                  if (isEditingEmail) {
                    _emailFocusNode.requestFocus();
                  } else {
                    _emailFocusNode.unfocus();
                  }
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ProfileEditCard(
              label: AppLocalizations.of(context)!.vehicleIdString,
              value: authCubit.userDetails?.data?.vehicleDetailData?.vehicleRegistration ??
                  'Vehicle Id',
              onTap: () {},
            ),
            const SizedBox(
              height: 20,
            ),
            ProfileEditCard(
              label: AppLocalizations.of(context)!.uploadDocumentString,
              value: 'ravigupta214@gmail.com',
              onTap: () {},
              icon: uploadIcon,
              widget: Row(
                children: [
                  Image.asset(
                    imageIcon,
                    height: 24,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Image',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ProfileEditCard(
              label: AppLocalizations.of(context)!.vehicleNo,
              value: vehicleNoController.text,
              isEditing: isEditingVehicleNo,
              widget: isEditingVehicleNo
                  ? SizedBox(
                      width: double.infinity,
                      child: TextField(
                        focusNode: _vehicleNoFocusNode,
                        controller: vehicleNoController,
                        cursorColor: primaryColor,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                            ),
                        decoration: InputDecoration.collapsed(hintText: "MP20VSXXXX"),
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[A-Z0-9]')),
                          LengthLimitingTextInputFormatter(
                            10,
                          ), // Max length for format like MP20VS1234
                        ],
                      ),
                    )
                  : null,
              onTap: () {
                setState(() {
                  isEditingVehicleNo = !isEditingVehicleNo;
                  if (isEditingVehicleNo) {
                    _vehicleNoFocusNode.requestFocus();
                  } else {
                    _vehicleNoFocusNode.unfocus();
                  }
                });
              },
            ),
            SizedBox(
              height: size.width * 0.1,
            ),
            BlocListener(
              bloc: settingsCubit,
              listener: (final context, final state) {
                if (state is UpdateProfileLoadingState) {
                  setState(() {
                    loading = true;
                  });
                } else if (state is UpdateProfileLoadedState) {
                  setState(() {
                    loading = false;
                    errorMessage = '';
                  });
                  showToast(
                    context: context,
                    fToast: fToast!,
                    msg: AppLocalizations.of(context)!.profileUpdatedString,
                    duration: 3,
                  );
                } else if (state is ErrorState) {
                  setState(() {
                    errorMessage = state.errorMessage;
                    loading = false;
                  });
                }
              },
              child: loading
                  ? SizedBox.shrink()
                  : CustomElevatedButton(
                      name: AppLocalizations.of(context)!.updateString,
                      borderRadius: 25,
                      alignment: Alignment.bottomCenter,
                      onPressed: () async {
                        if (userData?.email != emailController.text &&
                            emailController.text.isNotEmpty &&
                            !isValidEmail) {
                          showToast(
                            context: context,
                            fToast: fToast!,
                            msg: AppLocalizations.of(context)!.valideEmailString,
                            duration: 3,
                          );
                        } else if (userData?.vehicleDetailData?.vehicleNo !=
                                vehicleNoController.text &&
                            !vehicleNoController.text.isValidVehicleNumber()) {
                          showToast(
                            context: context,
                            fToast: fToast!,
                            msg:
                                '${AppLocalizations.of(context)!.pleaseEnterString} ${AppLocalizations.of(context)!.validString} ${AppLocalizations.of(context)!.vehicleNo.toLowerCase()}',
                            duration: 3,
                          );
                        } else {
                          await settingsCubit.updateProfile(
                            name: nameController.text,
                            email: emailController.text,
                            dialCode: userData?.dialCode ?? '91',
                            mobile: userData?.mobile ?? '',
                            profilePic: profilePhoto,
                          );
                        }
                      },
                      textPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      nameSize: 20,
                    ),
            ),
            loading ? LoadingWithoutText() : SizedBox.shrink(),
            errorMessage != ''
                ? Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: Text(
                        errorMessage,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
