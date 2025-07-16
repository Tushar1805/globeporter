import 'package:core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/authentication/view/login_screen.dart';
import 'package:globeporter/presentation/widgets/status_bar_widget.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_keys.dart';
import 'package:globeporter/resources/app_storage.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final String _selectedCountryCode = '+91';
  final storage = sl<SecureStorage>();
  bool nameReadOnly = false;
  bool emailReadOnly = false;

  void getUserInfo() async {
    final name = await storage.readValue(displayNameKey);
    final email = await storage.readValue(userEmailKey);
    setState(() {
      nameReadOnly = name != null;
      emailReadOnly = email != null;

      nameController.text = name ?? '';
      emailController.text = email ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
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
                readOnly: nameReadOnly,
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
                readOnly: emailReadOnly,
              ),

              const SizedBox(height: 60),

              CustomElevatedButton(
                name: AppLocalizations.of(context)!.registerString,
                borderRadius: 25,
                alignment: Alignment.bottomCenter,
                onPressed: () {
                  String fullNumber = '$_selectedCountryCode${phoneController.text}';
                  debugPrint('Phone number entered: $fullNumber');
                  context.push(otpScreen);
                },
                textPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                nameSize: 22,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
