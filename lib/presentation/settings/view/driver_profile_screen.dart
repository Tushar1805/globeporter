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
import 'package:globeporter/resources/app_utils.dart';
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
  bool isEditingPhone = false;
  bool isPhoneVerified = false;
  bool loading = false;
  File? profilePhoto;

  UserDetailsResponseModel? userDetails;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController vehicleNoController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _vehicleNoFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  FToast? fToast;

  void getProfilePhoto(String url) async {
    profilePhoto = await authCubit.urlToFile(url);
  }

  void getProfileData() async {
    await authCubit.getUserDetails(force: true);
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast!.init(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    vehicleNoController.dispose();
    phoneController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _vehicleNoFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      body: BlocConsumer(
        bloc: authCubit,
        listener: (final context, final state) {
          if (state is UserDetailsLoadedState) {
            userDetails = state.data as UserDetailsResponseModel?;
            if (userDetails?.data?.profilePhotoUrl != null) {
              getProfilePhoto(userDetails?.data?.profilePhotoUrl);
            }
            nameController = TextEditingController(text: userDetails?.data?.name ?? '');
            emailController = TextEditingController(text: userDetails?.data?.email ?? '');
            vehicleNoController =
                TextEditingController(text: userDetails?.data?.vehicleDetailData?.vehicleNo);
            phoneController = TextEditingController(text: userDetails?.data?.mobile ?? '');
            setState(() {});
          }
        },
        builder: (context, state) {
          if (state is UserDetailsLoadingState) {
            return Center(
              child: LoadingWithoutText(),
            );
          } else {
            return SingleChildScrollView(
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
                              // backgroundImage: profilePhoto != null
                              //     ? FileImage(profilePhoto!)
                              //     : (userDetails?.data?.profilePhotoUrl != null
                              //         ? NetworkImage(userData!.profilePhotoUrl) as ImageProvider<Object>
                              //         : AssetImage(profileImage) as ImageProvider<Object>),
                              backgroundImage: NetworkImage(
                                  userDetails?.data?.profilePhotoUrl ?? sampleNetworkImage),
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
                                  'title': '${locale.profileString} ${locale.photoString}',
                                  'image': profilePhoto,
                                  'onImageCaptured': (File? file) {
                                    setState(() {
                                      profilePhoto = file;
                                    });
                                    debugPrint(
                                        "Captured file path: Vehicle:  ${profilePhoto?.path}");
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
                    label: locale.nameString,
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
                    label: locale.emailString,
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
                    label: locale.phoneNumberString,
                    value: phoneController.text,
                    isEditing: isEditingPhone,
                    widget: isEditingPhone
                        ? SizedBox(
                            width: double.infinity,
                            child: TextField(
                              focusNode: _phoneFocusNode,
                              controller: phoneController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(phoneNumberRegex),
                                LengthLimitingTextInputFormatter(10),
                              ],
                              keyboardType: TextInputType.number,
                              cursorColor: primaryColor,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 16,
                                  ),
                              decoration:
                                  InputDecoration.collapsed(hintText: locale.enterPhoneString),
                              onChanged: (final value) {},
                            ),
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        isEditingPhone = !isEditingPhone;
                        if (isEditingPhone) {
                          _phoneFocusNode.requestFocus();
                        } else {
                          _phoneFocusNode.unfocus();
                        }
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ProfileEditCard(
                    label: locale.vehicleIdString,
                    value: authCubit.userDetails?.data?.vehicleDetailData?.vehicleRegistration ??
                        'Vehicle Id',
                    onTap: () {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ProfileEditCard(
                    label: "${locale.uploadedString} ${locale.documentsString}",
                    value: 'ravigupta214@gmail.com',
                    onTap: () {
                      context.pushNamed(viewDocumentsScreen);
                    },
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
                    label: locale.vehicleNo,
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
                  userDetails?.data?.mobile != phoneController.text && !isPhoneVerified
                      ? BlocListener(
                          bloc: authCubit,
                          listener: (final context, final state) async {
                            if (state is UpdateMobileLoadingState) {
                              setState(() {
                                loading = true;
                              });
                            } else if (state is UpdateMobileLoadedState) {
                              showOtpDialog(
                                context: context,
                                borderRadius: 18,
                                maxLength: 6,
                                title: "${locale.verifyString} ${locale.phoneNumberString}",
                                onOtpSubmit: (otp) async {
                                  await authCubit.updateVerifyOtp(
                                    dialCode:
                                        userDetails?.data?.dialCode?.replaceAll('+', '') ?? '91',
                                    mobile: phoneController.text,
                                    otp: otp,
                                  );
                                  context.pop();
                                },
                              );

                              setState(() {
                                loading = false;
                              });
                            } else if (state is UpdateMobileVerifyLoadedState) {
                              context.pop();
                              await authCubit.getUserDetails();
                              showToast(
                                context: context,
                                fToast: fToast!,
                                msg: "${locale.phoneNumberString} ${locale.verifiedString}",
                                duration: 3,
                              );
                              setState(() {
                                loading = false;
                                isPhoneVerified = true;
                              });
                            } else if (state is ErrorState) {
                              showToast(
                                context: context,
                                fToast: fToast!,
                                msg: state.errorMessage,
                                duration: 5,
                              );
                              setState(() {
                                loading = false;
                              });
                            }
                          },
                          child: loading
                              ? SizedBox.shrink()
                              : CustomElevatedButton(
                                  name: locale.verifyString,
                                  borderRadius: 25,
                                  alignment: Alignment.bottomCenter,
                                  onPressed: () async {
                                    if (userDetails?.data?.mobile != phoneController.text) {
                                      final validPhone = isPhoneValid(
                                        phone: phoneController.text,
                                        dialCode: "+${userDetails?.data?.dialCode ?? '91'}",
                                      );

                                      if (!validPhone) {
                                        showToast(
                                          context: context,
                                          fToast: fToast!,
                                          msg: AppLocalizations.of(context)!.validPhoneNumberString,
                                          duration: 3,
                                        );
                                      } else {
                                        await authCubit.updateMobileNumber(
                                          dialCode:
                                              userDetails?.data?.dialCode?.replaceAll('+', '') ??
                                                  '91',
                                          phoneNumber: phoneController.text,
                                        );
                                      }
                                    }
                                  },
                                  textPadding:
                                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  nameSize: 20,
                                ),
                        )
                      : BlocListener(
                          bloc: settingsCubit,
                          listener: (final context, final state) {
                            if (state is UpdateProfileLoadingState) {
                              setState(() {
                                loading = true;
                              });
                            } else if (state is UpdateProfileLoadedState) {
                              setState(() {
                                loading = false;
                              });
                              showToast(
                                context: context,
                                fToast: fToast!,
                                msg: locale.profileUpdatedString,
                                duration: 3,
                              );
                            } else if (state is ErrorState) {
                              showToast(
                                context: context,
                                fToast: fToast!,
                                msg: state.errorMessage,
                                duration: 3,
                              );
                              setState(() {
                                loading = false;
                              });
                            }
                          },
                          child: loading
                              ? SizedBox.shrink()
                              : CustomElevatedButton(
                                  name: locale.updateString,
                                  borderRadius: 25,
                                  alignment: Alignment.bottomCenter,
                                  onPressed: () async {
                                    if (userDetails?.data?.email != emailController.text &&
                                        emailController.text.isNotEmpty &&
                                        !isValidEmail) {
                                      showToast(
                                        context: context,
                                        fToast: fToast!,
                                        msg: locale.valideEmailString,
                                        duration: 3,
                                      );
                                    } else if (userDetails?.data?.vehicleDetailData?.vehicleNo !=
                                            vehicleNoController.text &&
                                        !vehicleNoController.text.isValidVehicleNumber()) {
                                      showToast(
                                        context: context,
                                        fToast: fToast!,
                                        msg:
                                            '${locale.pleaseEnterString} ${locale.validString} ${locale.vehicleNo.toLowerCase()}',
                                        duration: 3,
                                      );
                                    } else {
                                      await settingsCubit.updateProfile(
                                        name: nameController.text,
                                        email: emailController.text,
                                        dialCode: userDetails?.data?.dialCode ?? '91',
                                        mobile: userDetails?.data?.mobile ?? '',
                                        profilePic: profilePhoto,
                                      );
                                    }
                                  },
                                  textPadding:
                                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  nameSize: 20,
                                ),
                        ),
                  loading ? LoadingWithoutText() : SizedBox.shrink(),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
