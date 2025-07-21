// ignore_for_file: use_build_context_synchronously

import 'package:core/app_widgets.dart';
import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/svg.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/authentication/model/otp_response_model.dart';
import 'package:globeporter/presentation/authentication/model/user_type_response_model.dart';
import 'package:globeporter/presentation/widgets/driver_dialog_widget.dart';
import 'package:globeporter/presentation/widgets/status_bar_widget.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_keys.dart';
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
  String _selectedCountryCode = '+91';
  final storage = sl<SecureStorage>();
  final authCubit = sl<AuthCubit>();
  bool loading = false;
  FToast? fToast;

  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);
    _selectedCountryCode = widget.countryCode;
    phoneController.text = widget.phone;
    nameController.text = widget.name;
    emailController.text = widget.email;
    otpController.text = widget.otp.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                      AppLocalizations.of(context)!.onboarding1Title,
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
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.enterMobileHint,
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
                  AppLocalizations.of(context)!.nameString,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor),
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              CustomTextField(
                textEditingController: nameController,
                readOnly: true,
              ),

              const SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  AppLocalizations.of(context)!.emailString,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor),
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              CustomTextField(
                textEditingController: emailController,
                readOnly: true,
              ),

              const SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  AppLocalizations.of(context)!.otpString,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor),
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              CustomTextField(
                textEditingController: otpController,
                inputType: TextInputType.number,
              ),

              const SizedBox(height: 30),

              BlocListener(
                bloc: authCubit,
                listener: (final context, final state) async {
                  if (state is OtpVerifyLoadingState || state is UserTypeLoadingState) {
                    setState(() {
                      loading = true;
                    });
                  } else if (state is OtpVerifyLoadedState) {
                    final data = state.data as OtpResponseModel?;
                    if (data?.statusCode == 200) {
                      if (data?.userType != null) {
                        if (data?.userType == 2) {
                          await storage.saveValue(
                            value: data?.detailsFilled ?? false ? '1' : '0',
                            key: detailsFilledKey,
                          );
                          if (data?.detailsFilled ?? false) {
                            context.go(driverDashboard);
                          } else {
                            context.go(ownerDetailsScreen);
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
                  }
                },
                child: loading
                    ? SizedBox.shrink()
                    : CustomElevatedButton(
                        name: AppLocalizations.of(context)!.loginString,
                        borderRadius: 25,
                        alignment: Alignment.bottomCenter,
                        onPressed: () async {
                          await authCubit.verifyOtp(
                            otp: widget.otp.toString(),
                            userId: widget.userId,
                          );
                        },
                        textPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        nameSize: 22,
                      ),
              ),
              const SizedBox(height: 20),

              loading ? LoadingWithoutText() : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
