import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/index.dart';
import 'onboarding_screen.dart';

class SelectLangScreen extends StatefulWidget {
  static const String route = '/select-lang';
  const SelectLangScreen({super.key});

  @override
  State<SelectLangScreen> createState() => _SelectLangScreenState();
}

class _SelectLangScreenState extends State<SelectLangScreen> {
  String selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: CustomColors.whiteColor,
        padding: EdgeInsets.only(left: 20, right: 20, top: MediaQuery.of(context).padding.top + 30, bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Select Your Language',
              style: TextStyle(fontSize: 28, color: CustomColors.primaryColor, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your selected language can be changed\nanytime from Settings.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: CustomColors.greyTextColor),
            ),
            const SizedBox(height: 32),

            // English Option
            _buildLangCard(
              label: 'English',
              value: 'en',
              selected: selectedLanguage == 'en',
              icon: Icons.language,
              backgroundImage: 'assets/svg/buildings.svg', // replace with your image
            ),
            const SizedBox(height: 30),

            // Hindi Option
            _buildLangCard(
              label: 'हिंदी',
              value: 'hi',
              selected: selectedLanguage == 'hi',
              icon: Icons.translate,
              backgroundImage: 'assets/svg/tajmahal.svg', // replace with your image
            ),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              onPressed: () {
                Navigator.pushNamed(context, OnboardingScreen.route);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: CustomColors.whiteColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLangCard({
    required String label,
    required String value,
    required bool selected,
    required IconData icon,
    required String backgroundImage,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = value;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
          boxShadow: selected ? [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4))] : [],
        ),
        padding: const EdgeInsets.only(left: 16, right: 16, top: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Radio<String>(
                  value: value,
                  groupValue: selectedLanguage,
                  activeColor: Colors.white,
                  onChanged: (val) {
                    setState(() {
                      selectedLanguage = val!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
                            Text(
                              value == 'en' ? 'Aa' : 'अ',
                              style: const TextStyle(fontSize: 72, color: Colors.white, height: 1, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (backgroundImage.isNotEmpty)
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [Opacity(opacity: 0.3, child: SvgPicture.asset(backgroundImage, height: 80, fit: BoxFit.contain))],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
