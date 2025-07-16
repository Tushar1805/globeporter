import 'dart:async';
import 'dart:convert';

import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/resources/app_api_keys.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_keys.dart';
import 'package:globeporter/resources/app_storage.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final String _selectedCountryCode = '+91';
  final GoogleSignIn signIn = GoogleSignIn.instance;
  GoogleSignInAccount? _currentUser;
  final _storage = sl<SecureStorage>();

  bool _isAuthorized = false;

// has granted permissions?
  List<String> scopes = <String>[
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  Future<void> _handleAuthenticationError(Object e) async {
    setState(() {
      _currentUser = null;
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => (contact as Map<Object?, dynamic>)['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final List<dynamic> names = contact['names'] as List<dynamic>;
      final Map<String, dynamic>? name = names.firstWhere(
        (dynamic name) => (name as Map<Object?, dynamic>)['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  // Calls the People API REST endpoint for the signed-in user to retrieve information.
  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {});
    customPrint('Entered to get info');
    final Map<String, String>? headers =
        await user.authorizationClient.authorizationHeaders(scopes);
    customPrint(headers.toString());
    if (headers == null) {
      setState(() {});
      return;
    }
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: headers,
    );
    if (response.statusCode != 200) {
      if (response.statusCode == 401 || response.statusCode == 403) {
        setState(() {});
      } else {
        customPrint('People API ${response.statusCode} response: ${response.body}');
        setState(() {});
      }
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
      } else {}
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

    // Check for existing authorization.
    // #docregion CheckAuthorization
    final GoogleSignInClientAuthorization? authorization =
        await user?.authorizationClient.authorizationForScopes(scopes);
    // #enddocregion CheckAuthorization

    setState(() {
      _currentUser = user;
    });

    // If the user has already granted access to the required scopes, call the
    // REST API.
    if (user != null && authorization != null) {
      unawaited(_handleGetContact(user));
    }
  }

  @override
  void initState() {
    super.initState();
    unawaited(signIn
        .initialize(
      clientId: oAuthClientId,
      serverClientId: oAuthServerId,
    )
        .then((_) {
      signIn.authenticationEvents
          .listen(_handleAuthenticationEvent)
          .onError(_handleAuthenticationError);

      /// This example always uses the stream-based approach to determining
      /// which UI state to show, rather than using the future returned here,
      /// if any, to conditionally skip directly to the signed-in state.
      //* Automatice sign in with googel after entering to the screen
      // signIn.attemptLightweightAuthentication();
    }));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: Row(
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
              onPressed: () {
                String fullNumber = '$_selectedCountryCode${phoneController.text}';
                debugPrint('Phone number entered: $fullNumber');
                // Handle your login logic
                context.pushNamed(signUpScreen);
              },
              child: Image.asset(
                arrowForward,
                width: size.width * 0.136,
                height: size.height * 0.017,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
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
                    CustomCountryPicker(),
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
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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
                          await _storage.saveValue(
                              key: displayNameKey, value: account.displayName ?? '');
                          await _storage.saveValue(key: userEmailKey, value: account.email);
                          await _storage.saveValue(key: photoUrlKey, value: account.photoUrl ?? '');
                          await _storage.saveValue(key: idTokenKey, value: idToken);

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
                  Image.asset(
                    facebookIcon,
                    width: size.width * .1,
                  ),
                ],
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

class CustomCountryPicker extends StatefulWidget {
  const CustomCountryPicker({super.key});

  @override
  _CustomCountryPickerState createState() => _CustomCountryPickerState();
}

class _CustomCountryPickerState extends State<CustomCountryPicker> {
  CountryCode _selectedCountryCode = CountryCode.fromDialCode('+91');

  void _showCountryPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: CountryCodePicker(
            onChanged: (country) {
              setState(() {
                _selectedCountryCode = country;
              });
              Navigator.pop(context);
            },
            initialSelection: _selectedCountryCode.code,
            favorite: const ['+91', 'IN'],
            showCountryOnly: false,
            showOnlyCountryWhenClosed: false,
            alignLeft: true,
            textStyle: Theme.of(context).textTheme.bodyMedium,
            flagDecoration: const BoxDecoration(shape: BoxShape.circle),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showCountryPicker,
      child: Container(
        padding: const EdgeInsets.only(left: 5, right: 0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(4),
        ),
        height: 48,
        // width: 100,
        child: Row(
          children: [
            _selectedCountryCode.flagUri != null
                ? ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(100),
                    child: Image.asset(
                      _selectedCountryCode.flagUri!,
                      package: 'country_code_picker',
                      fit: BoxFit.cover,
                      width: 20,
                      height: 20,
                    ),
                  )
                : const SizedBox(),
            const SizedBox(width: 5),
            Text(
              _selectedCountryCode.dialCode ?? '+91',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey, fontSize: 16),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
