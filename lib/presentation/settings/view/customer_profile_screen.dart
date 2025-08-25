// ignore_for_file: use_build_context_synchronously

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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:globeporter/presentation/authentication/model/user_details_response_model.dart';
import 'package:globeporter/presentation/settings/cubit/settings_cubit.dart';
import 'package:globeporter/presentation/settings/states/settings_states.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_extension_functions.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_regex.dart';
import 'package:globeporter/resources/app_utils.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  final authCubit = sl<AuthCubit>();
  final settingsCubit = sl<SettingsCubit>();
  bool isEditingName = false;
  bool isEditingEmail = false;
  bool isEditingPhone = false;
  bool isValidEmail = false;
  bool isPhoneVerified = false;
  bool loading = false;
  File? profilePhoto;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
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
    phoneController = TextEditingController(text: userData?.mobile ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
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
                          'title': '${locale.profileString} ${locale.photoString}',
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
                      decoration: InputDecoration.collapsed(hintText: locale.enterNameString),
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
                      decoration: InputDecoration.collapsed(hintText: locale.enterEmailString),
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
                      decoration: InputDecoration.collapsed(hintText: locale.enterPhoneString),
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
          Spacer(),
          userData?.mobile != phoneController.text && !isPhoneVerified
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
                            dialCode: userData?.dialCode?.replaceAll('+', '') ?? '91',
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
                            if (userData?.mobile != phoneController.text) {
                              final validPhone = isPhoneValid(
                                phone: phoneController.text,
                                dialCode: "+${userData?.dialCode ?? '91'}",
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
                                  dialCode: userData?.dialCode?.replaceAll('+', '') ?? '91',
                                  phoneNumber: phoneController.text,
                                );
                              }
                            }
                          },
                          textPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                  child: loading ||
                          (userData?.email == emailController.text &&
                              userData?.mobile == phoneController.text &&
                              userData?.name == nameController.text)
                      ? SizedBox.shrink()
                      : CustomElevatedButton(
                          name: locale.updateString,
                          borderRadius: 25,
                          alignment: Alignment.bottomCenter,
                          onPressed: () async {
                            if (userData?.email != emailController.text &&
                                emailController.text.isNotEmpty &&
                                !isValidEmail) {
                              showToast(
                                context: context,
                                fToast: fToast!,
                                msg: locale.valideEmailString,
                                duration: 3,
                              );
                            } else if (userData?.mobile != phoneController.text) {
                              final validPhone = isPhoneValid(
                                phone: phoneController.text,
                                dialCode: userData?.dialCode ?? '91',
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
                                  dialCode: userData?.dialCode?.replaceAll('+', '') ?? '91',
                                  phoneNumber: phoneController.text,
                                );
                              }
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
          SizedBox(
            height: size.width * 0.1,
          ),
        ],
      ),
    );
  }
}
