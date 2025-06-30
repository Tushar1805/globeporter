import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/authentication/view/login_screen.dart';
import 'package:globeporter/presentation/widgets/driver_dialog_widget.dart';
import 'package:globeporter/presentation/widgets/status_bar_widget.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  String _selectedCountryCode = '+91';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
                SvgPicture.asset(driverWithVan, width: size.width * .7),
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
                  CustomCountryPicker(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      style: Theme.of(context).textTheme.bodyMedium,
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.enterMobileHint,
                        hintStyle:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor),
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.nameString,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      // hintText: enterMobileText,
                      // hintStyle:
                      //     Theme.of(context).textTheme.bodySmall?.copyWith(color: greyTextColor),
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
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.emailString,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    controller: emailController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      // hintText: enterMobileText,
                      // hintStyle:
                      //     Theme.of(context).textTheme.bodySmall?.copyWith(color: greyTextColor),
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
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.otpString,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      // hintText: enterMobileText,
                      // hintStyle:
                      //     Theme.of(context).textTheme.bodySmall?.copyWith(color: greyTextColor),
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
                ],
              ),
            ),

            const SizedBox(height: 30),

            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: () {
                  // Navigator.pushNamed(context, OnboardingScreen.route);
                  // context.push(onboardingScreen);
                  String fullNumber = '$_selectedCountryCode${phoneController.text}';
                  debugPrint('Phone number entered: $fullNumber');
                  showDriverDialog(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    AppLocalizations.of(context)!.loginString,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: whiteColor, fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
