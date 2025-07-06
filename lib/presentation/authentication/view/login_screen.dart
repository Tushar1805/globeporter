import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final String _selectedCountryCode = '+91';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // debugPrint('Height: ${size.height.toString()}');
    // debugPrint('Width: ${size.width.toString()}');
    return Scaffold(
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
                        hintStyle:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor),
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
                Image.asset(
                  googleIcon,
                  width: size.width * .0587,
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
