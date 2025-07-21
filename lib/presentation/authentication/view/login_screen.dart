// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:core/app_widgets.dart';
import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:country_phone_validator/country_phone_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/authentication/model/login_response_model.dart';
import 'package:globeporter/resources/app_api_keys.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_keys.dart';
import 'package:globeporter/resources/app_storage.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  String _selectedCountryCode = '+91';
  final GoogleSignIn signIn = GoogleSignIn.instance;
  GoogleSignInAccount? _currentUser;
  final _storage = sl<SecureStorage>();
  final authCubit = sl<AuthCubit>();
  FToast? fToast;

  bool _isAuthorized = false;
  bool loading = false;

  Future<void> _handleAuthenticationError(Object e) async {
    setState(() {
      _currentUser = null;
    });
  }

  Future<void> _handleAuthenticationEvent(GoogleSignInAuthenticationEvent event) async {
    // #docregion CheckAuthorization
    final GoogleSignInAccount? user = // ...
        // #enddocregion CheckAuthorization
        switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };

    setState(() {
      _currentUser = user;
    });
  }

  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);
    unawaited(signIn
        .initialize(
      clientId: oAuthClientId,
      serverClientId: oAuthServerId,
    )
        .then((_) {
      signIn.authenticationEvents
          .listen(_handleAuthenticationEvent)
          .onError(_handleAuthenticationError);
    }));
    super.initState();
  }

  bool isPhoneValid({
    required final String phone,
    required final String dialCode,
  }) {
    final isValid = CountryUtils.validatePhoneNumber(phone, dialCode);

    customPrint("$dialCode $phone : isValid: $isValid");
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: loading
            ? SizedBox.shrink()
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Large enough for pill shape
                      ),
                      padding: const EdgeInsets.all(14),
                    ),
                    onPressed: () async {
                      final langCode = await _storage.readValue(languageCodeKey);
                      if (phoneController.text.isEmpty) {
                        showToast(
                          context: context,
                          fToast: fToast!,
                          msg: AppLocalizations.of(context)!.validEnterPhoneNumberString,
                          duration: 3,
                        );
                      } else {
                        final validPhone = isPhoneValid(
                          phone: phoneController.text,
                          dialCode: _selectedCountryCode,
                        );

                        if (!validPhone) {
                          showToast(
                            context: context,
                            fToast: fToast!,
                            msg: AppLocalizations.of(context)!.validPhoneNumberString,
                            duration: 3,
                          );
                        } else {
                          await authCubit.login(
                            langCode: langCode ?? 'en',
                            dialCode: _selectedCountryCode.replaceAll('+', ''),
                            phoneNumber: phoneController.text,
                          );
                        }
                      }
                    },
                    child: Image.asset(
                      arrowForward,
                      width: size.width * 0.136,
                      height: size.height * 0.017,
                    ),
                  ),
                ],
              ),
        body: BlocListener(
          bloc: authCubit,
          listener: (final context, final state) async {
            if (state is LoginLoadingState) {
              setState(() {
                loading = true;
              });
            } else if (state is LoginLoadedState) {
              final data = state.data as LoginResponseModel?;

              if (data?.data?.email == null) {
                context.pushNamed(signUpScreen, extra: {
                  'countryCode': _selectedCountryCode,
                  'phoneNumber': phoneController.text,
                  'userId': data?.data?.id,
                  'otp': data?.otp,
                });
              } else {
                await _storage.saveValue(value: data?.data?.userType.toString(), key: userTypeKey);
                customPrint("GET User type from api: ${data?.data?.userType.toString()}");
                context.pushNamed(otpScreen, extra: {
                  'countryCode': _selectedCountryCode,
                  'email': data?.data?.email,
                  'phone': phoneController.text,
                  'name': data?.data?.name,
                  'userId': data?.data?.id,
                  'otp': data?.otp
                });
              }
              setState(() {
                loading = false;
              });
            }
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Curved Green Header with Logo
                Stack(
                  children: [
                    Container(
                      height: size.width * 0.5,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(124),
                          bottomRight: Radius.circular(124),
                        ),
                      ),
                    ),
                    Positioned(
                      top: size.width * 0.25,
                      left: 0,
                      right: 0,
                      child: SvgPicture.asset(
                        appLogoSmall,
                        width: MediaQuery.sizeOf(context).width * .4,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 45),

                // Truck Image
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      driverWithVanSvg,
                      width: size.width * .7,
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.onboarding1Title,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.enterMobileString,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20),
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
                          flagWidth: 24,
                          textStyle: Theme.of(context).textTheme.bodyMedium,
                          onChanged: (country) {
                            customPrint('Changed country code to : ${country.dialCode}');
                            setState(() {
                              _selectedCountryCode = country.dialCode.toString();
                            });
                          },
                          initialSelection: _selectedCountryCode,
                          favorite: const ['+91'],
                          flagDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          pickerStyle: PickerStyle.bottomSheet,
                        ),
                      ),
                      // CustomCountryPicker(
                      //   countrycode: _selectedCountryCode,
                      //   onCountryChanged: (country) {
                      //     customPrint('Changed country code to : ${country.dialCode}');
                      //     setState(() {
                      //       _selectedCountryCode = country.dialCode.toString();
                      //     });
                      //     context.pop();
                      //   },
                      // ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.enterMobileHint,
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: greyTextColor),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: primaryColor),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: primaryColor),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.width * 0.1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width * .1,
                      child: const Divider(
                        color: Color(0xFF737272),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      AppLocalizations.of(context)!.orSignUpString,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 16, color: Color(0xFF737272)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: size.width * .1,
                      child: const Divider(
                        color: Color(0xFF737272),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        try {
                          final account = await GoogleSignIn.instance.authenticate();

                          final auth = account.authentication;

                          final idToken = auth.idToken;

                          if (idToken != null) {
                            setState(() {
                              _currentUser = account;
                              _isAuthorized = true;
                            });

                            customPrint('Signed in as ${account.displayName}');
                          } else {
                            throw Exception("Invalid authentication. No tokens returned.");
                          }
                          customPrint(
                            'Text: ${_currentUser?.displayName}, ${_currentUser?.email}, ${_currentUser?.id}, ${_currentUser?.photoUrl}',
                          );
                        } catch (e) {
                          customPrint('Something went wrong');
                        }

                        if (_isAuthorized) {
                          context.pushNamed(signUpScreen);
                        }
                      },
                      child: Image.asset(
                        googleIcon,
                        width: size.width * .0587,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final user = await authCubit.signInWithFacebook();
                        customPrint(user);
                      },
                      child: Image.asset(
                        facebookIcon,
                        width: size.width * .1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                loading ? LoadingWithoutText() : SizedBox.shrink(),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
