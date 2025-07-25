// ignore_for_file: use_build_context_synchronously

import 'package:core/app_widgets.dart';
import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:datasource/states/data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/authentication/model/register_response_model.dart';
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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen(
      {super.key,
      required this.phoneNumber,
      required this.countryCode,
      required this.userId,
      this.otp});
  final String phoneNumber;
  final String countryCode;
  final int userId;
  final int? otp;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final authCubit = sl<AuthCubit>();
  String _selectedCountryCode = '+91';
  final storage = sl<SecureStorage>();
  bool isValidEmail = false;
  FToast? fToast;
  bool loading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast!.init(context);
    phoneController.text = widget.phoneNumber;
    _selectedCountryCode = widget.countryCode;
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

              const SizedBox(height: 15),

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
                inputType: TextInputType.name,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(nameRegex),
                ],
              ),

              const SizedBox(
                height: 12,
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
                onChanged: (final value) {
                  setState(() {
                    isValidEmail = value.isValidEmail();
                  });
                },
              ),

              const SizedBox(height: 60),

              BlocListener(
                bloc: authCubit,
                listener: (final context, final state) {
                  if (state is RegisterLoadingState) {
                    setState(() {
                      loading = true;
                    });
                  } else if (state is RegisterLoadedState) {
                    final data = state.data as RegisterResponseModel?;

                    if (data?.registrationDone == 1) {
                      context.push(otpScreen, extra: {
                        'countryCode': widget.countryCode,
                        'email': emailController.text,
                        'name': nameController.text,
                        'phone': widget.phoneNumber,
                        'userId': data?.userId,
                        'otp': widget.otp,
                      });
                    } else {
                      showToast(
                        context: context,
                        fToast: fToast!,
                        msg: AppLocalizations.of(context)!.registrationFailedString,
                        duration: 3,
                      );
                    }
                    setState(() {
                      loading = false;
                    });
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
                        name: AppLocalizations.of(context)!.registerString,
                        borderRadius: 25,
                        alignment: Alignment.bottomCenter,
                        onPressed: () async {
                          final langCode = await storage.readValue(languageCodeKey);
                          if (nameController.text.isEmpty && nameController.text.length < 5) {
                            showToast(
                              context: context,
                              fToast: fToast!,
                              msg: AppLocalizations.of(context)!.validNameString,
                              duration: 3,
                            );
                          } else if (!isValidEmail) {
                            showToast(
                              context: context,
                              fToast: fToast!,
                              msg: AppLocalizations.of(context)!.valideEmailString,
                              duration: 3,
                            );
                          } else {
                            await authCubit.register(
                              userId: widget.userId,
                              langCode: langCode ?? 'en',
                              name: nameController.text,
                              email: emailController.text,
                            );
                          }
                        },
                        textPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        nameSize: 22,
                      ),
              ),

              loading ? LoadingWithoutText() : SizedBox.shrink(),

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

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
