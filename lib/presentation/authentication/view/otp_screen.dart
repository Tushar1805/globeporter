// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:core/app_widgets.dart';
import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:datasource/states/data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/svg.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
// import 'package:globeporter/presentation/authentication/model/login_response_model.dart';
import 'package:globeporter/presentation/authentication/model/otp_response_model.dart';
import 'package:globeporter/presentation/authentication/model/user_type_response_model.dart';
import 'package:globeporter/presentation/widgets/driver_dialog_widget.dart';
import 'package:globeporter/presentation/widgets/status_bar_widget.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_extension_functions.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_keys.dart';
import 'package:globeporter/resources/app_regex.dart';
import 'package:globeporter/resources/app_storage.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.countryCode,
    required this.email,
    required this.phone,
    required this.name,
    required this.userId,
    this.otp,
  });
  final String countryCode;
  final String email;
  final String phone;
  final String name;
  final int? otp;
  final int userId;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();

  bool isNameEditing = false;
  bool isEmailEditing = false;
  bool isValidEmail = false;
  String _selectedCountryCode = '+91';
  final storage = sl<SecureStorage>();
  final authCubit = sl<AuthCubit>();
  bool loading = false;
  FToast? fToast;
  String errorMessage = '';
  Timer? _resendTimer;
  int _remainingSeconds = 30;
  bool _canResend = false;

  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);
    _selectedCountryCode = widget.countryCode;
    phoneController.text = widget.phone;
    nameController.text = widget.name;
    emailController.text = widget.email;
    // otpController.text = widget.otp.toString();
    _startResendOtpTimer();
    super.initState();
  }

  void _startResendOtpTimer() {
    setState(() {
      _remainingSeconds = 30;
      _canResend = false;
    });

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 1) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    phoneController.dispose();
    nameController.dispose();
    emailController.dispose();
    otpController.dispose();
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locale = AppLocalizations.of(context)!;
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Curved Green Header with Logo
              StatusBarWidget(),

              const SizedBox(height: 45),

              // Truck Image
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(driverWithVanSvg, width: size.width * .7),
                ],
              ),

              const SizedBox(height: 35),

              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.onboarding1Title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: primaryColor, fontSize: 28),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Phone Input Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                        border: BoxBorder.all(color: primaryColor, width: 1),
                      ),
                      child: CountryCodePicker(
                        enabled: false,
                        flagWidth: 24,
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        onChanged: (country) {},
                        initialSelection: _selectedCountryCode,
                        favorite: const ['+91'],
                        flagDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        pickerStyle: PickerStyle.bottomSheet,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        style: Theme.of(context).textTheme.bodyMedium,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(phoneNumberRegex),
                          LengthLimitingTextInputFormatter(10),
                        ],
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: locale.enterMobileHint,
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: greyTextColor),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  locale.nameString,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor),
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              CustomTextField(
                textEditingController: nameController,
                readOnly: !isNameEditing,
                inputType: TextInputType.name,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(nameRegex),
                ],
                suffixIcon: GestureDetector(
                  onTap: () {
                    nameFocusNode.requestFocus();
                    setState(() {
                      isNameEditing = true;
                    });
                  },
                  child: Icon(
                    Icons.edit,
                    color: primaryColor,
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  locale.emailString,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor),
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              CustomTextField(
                textEditingController: emailController,
                readOnly: !isEmailEditing,
                onChanged: (final value) {
                  setState(() {
                    isValidEmail = value.isValidEmail();
                  });
                },
                suffixIcon: GestureDetector(
                  onTap: () {
                    emailFocusNode.requestFocus();
                    setState(() {
                      isEmailEditing = true;
                    });
                  },
                  child: Icon(
                    Icons.edit,
                    color: primaryColor,
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  locale.otpString,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor),
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              CustomTextField(
                textEditingController: otpController,
                inputType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                ],
              ),

              const SizedBox(
                height: 8,
              ),

              loading
                  ? SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: _canResend
                          ? GestureDetector(
                              onTap: () async {
                                await authCubit.resendOtp(
                                  dialCode: _selectedCountryCode.replaceAll('+', ''),
                                  phoneNumber: phoneController.text,
                                );
                              },
                              child: Text(
                                locale.resendOtpString, // Make sure this exists
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: primaryColor),
                              ),
                            )
                          : CustomRichText(
                              title: locale.resendOtpIn,
                              value: ' $_remainingSeconds sec',
                              titleStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: greyTextColor),
                              valueStyle: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: primaryColor, fontSize: 16),
                            )
                      //  Text(
                      //     '${locale.resendOtpIn} $_remainingSeconds sec',
                      //     style:
                      //         Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor),
                      //   ),
                      ),

              const SizedBox(height: 30),

              BlocListener(
                bloc: authCubit,
                listener: (final context, final state) async {
                  if (state is OtpVerifyLoadingState ||
                      state is UserTypeLoadingState ||
                      state is ResendOtpLoadingState) {
                    setState(() {
                      loading = true;
                    });
                  } else if (state is ResendOtpLoadedState) {
                    // final data = state.data as LoginResponseModel?;
                    // setState(() {
                    //   otpController.text = data?.otp.toString() ?? '';
                    // });
                    _startResendOtpTimer();

                    setState(() {
                      errorMessage = '';
                      loading = false;
                    });
                  } else if (state is OtpVerifyLoadedState) {
                    final data = state.data as OtpResponseModel?;
                    if (data?.statusCode == 200) {
                      if (data?.userType != null) {
                        if (data?.userType == 2) {
                          await storage.saveValue(
                            value: data?.isAllDocUpload.toString(),
                            key: detailsFilledKey,
                          );
                          await storage.saveValue(
                            value: data?.isDocVerified.toString(),
                            key: isDetailsVerifiedKey,
                          );
                          await storage.saveValue(
                            value: data?.ownerDetailsFilled.toString(),
                            key: ownerDetailsFilledKey,
                          );
                          await storage.saveValue(
                            value: data?.vehicleDetailsFilled.toString(),
                            key: vehicleDetailsFilledKey,
                          );
                          await storage.saveValue(
                            value: data?.driverDetailsFilled.toString(),
                            key: driverDetailsFilledKey,
                          );

                          if (data?.isDocVerified == 1) {
                            context.go(driverDashboard);
                          } else if ((data?.isAllDocUpload == 1)) {
                            context.go(documentVerificationScreen);
                          } else {
                            if (data?.ownerDetailsFilled == 1 &&
                                data?.vehicleDetailsFilled == 1 &&
                                data?.driverDetailsFilled == 1) {
                              // navigate to verify screen
                              context.go(documentVerificationScreen);
                            } else if (data?.ownerDetailsFilled == 1 &&
                                data?.vehicleDetailsFilled == 1) {
                              // navigate to driver tab
                              context.go(ownerDetailsScreen, extra: {
                                'currentIndex': 2,
                              });
                            } else if (data?.ownerDetailsFilled == 1) {
                              // navigate to vehicle tab
                              context.go(ownerDetailsScreen, extra: {
                                'currentIndex': 1,
                              });
                            } else {
                              // naviage to owner tab
                              context.go(ownerDetailsScreen);
                            }
                          }
                        } else {
                          context.go(customerDashboard);
                        }
                      } else {
                        DriverDialog.show(context, authCubit);
                      }
                    } else {
                      showToast(
                        context: context,
                        fToast: fToast!,
                        msg: 'OTP verification failed',
                        duration: 3,
                      );
                    }

                    setState(() {
                      loading = false;
                      errorMessage = '';
                    });
                  } else if (state is UserTypeLoadedState) {
                    final data = state.data as UserTypeResponseModel?;
                    if (data?.statusCode == 200) {
                      if (data?.data?.userType == "2") {
                        context.go(ownerDetailsScreen);
                      } else {
                        context.go(customerDashboard);
                      }
                    }
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
                        name: locale.loginString,
                        borderRadius: 25,
                        alignment: Alignment.bottomCenter,
                        onPressed: () async {
                          if (isNameEditing &&
                              (nameController.text.isEmpty || nameController.text.length < 5)) {
                            showToast(
                              context: context,
                              fToast: fToast!,
                              msg: locale.validNameString,
                              duration: 3,
                            );
                          } else if (isEmailEditing &&
                              (emailController.text.isNotEmpty && !isValidEmail)) {
                            showToast(
                              context: context,
                              fToast: fToast!,
                              msg: locale.valideEmailString,
                              duration: 3,
                            );
                          } else if ((otpController.text.isEmpty ||
                              otpController.text.length < 6)) {
                            showToast(
                              context: context,
                              fToast: fToast!,
                              msg:
                                  "${locale.pleaseEnterString} ${locale.validString.toLowerCase()} ${locale.otpString.toUpperCase()}",
                              duration: 3,
                            );
                          } else {
                            if (isNameEditing || isEmailEditing) {
                              await authCubit.register(
                                userId: widget.userId,
                                name: nameController.text,
                                email: emailController.text,
                              );
                            }
                            await authCubit.verifyOtp(
                              otp: otpController.text,
                              userId: widget.userId,
                            );
                          }
                        },
                        textPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        nameSize: 22,
                      ),
              ),
              const SizedBox(height: 20),

              errorMessage != ''
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: Text(
                          errorMessage,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),

              loading ? LoadingWithoutText() : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
