import 'package:core/di/service_locator.dart';
import 'package:core/localization/language_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class SelectLangScreen extends StatefulWidget {
  const SelectLangScreen({super.key, this.onPop});
  final bool? onPop;

  @override
  State<SelectLangScreen> createState() => _SelectLangScreenState();
}

class _SelectLangScreenState extends State<SelectLangScreen> {
  String? selectedLanguage = 'en';
  late final LanguageCubit languageCubit;

  @override
  void initState() {
    super.initState();
    languageCubit = sl<LanguageCubit>();
    setState(() {
      selectedLanguage = languageCubit.appLocale?.languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: whiteColor,
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: MediaQuery.of(context).padding.top + 30,
          bottom: 50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.selectLanguage,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: primaryColor, fontSize: 28),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.selectLanguageDesc,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: greyTextColor, fontSize: 16),
            ),
            const SizedBox(height: 40),

            // English Option
            _buildLangCard(
              label: 'English',
              value: 'en',
              selected: selectedLanguage == 'en',
              icon: Icons.language,
              backgroundImage: buildingSvg, // replace with your image
              fontSize: 38,
            ),
            const SizedBox(height: 30),

            // Hindi Option
            _buildLangCard(
              label: 'हिंदी',
              value: 'hi',
              selected: selectedLanguage == 'hi',
              icon: Icons.translate,
              backgroundImage: tajMahalSvg, // replace with your image
              fontSize: 47,
            ),
            const SizedBox(height: 30),

            // Marathi Option
            _buildLangCard(
              label: 'मराठी',
              value: 'mr',
              selected: selectedLanguage == 'mr',
              icon: Icons.translate,
              backgroundImage: redfortSvg, // replace with your image
              fontSize: 47,
            ),

            const Spacer(),
            (widget.onPop ?? false)
                ? SizedBox.shrink()
                : CustomElevatedButton(
                    name: AppLocalizations.of(context)!.continueString,
                    borderRadius: 25,
                    alignment: Alignment.center,
                    onPressed: () {
                      context.push(onboardingScreen1);
                    },
                    textPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    nameSize: 22,
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
    required double fontSize,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = value;

          languageCubit.changeLanguage(Locale(selectedLanguage ?? 'en'));
          if (widget.onPop ?? false) {
            debugPrint('Popping back from here');
            context.pop();
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: selected
              ? [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4))]
              : [],
        ),
        padding: const EdgeInsets.only(left: 16, right: 16, top: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioTheme(
              data: RadioThemeData(
                fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white;
                  }
                  return Colors.white;
                }),
              ),
              child: Radio<String>(
                value: value,
                groupValue: selectedLanguage,
                activeColor: Colors.white,
                onChanged: (val) {
                  setState(() {
                    selectedLanguage = val!;
                  });
                  languageCubit.changeLanguage(Locale(selectedLanguage ?? 'en'));
                },
              ),
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
                            Text(
                              label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              value == 'en' ? 'Aa' : 'अ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: whiteColor, fontSize: fontSize, height: 1),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                    children: [
                      Opacity(
                        opacity: label == 'मराठी' ? 1 : 0.3,
                        child: SvgPicture.asset(
                          backgroundImage,
                          height: MediaQuery.of(context).size.height * 0.07,
                          fit: BoxFit.contain,
                        ),
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
