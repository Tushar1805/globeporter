import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomStatusBarWidget(
              title: AppLocalizations.of(context)!.referEarnString,
              fontSize: 22,
            ),
            SizedBox(
              height: size.width * 0.25,
            ),
            SizedBox(
              height: size.width * 0.7,
              width: size.width * 0.65,
              child: Card(
                elevation: 10,
                color: const Color(0xFFE0FFDD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(21),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        cashAndCoinImage,
                      ),
                      Text(
                        'Refer 1 Friend & Earn \n200 Cashback',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.width * 0.35,
            ),
            CustomElevatedButton(
              name: 'Invite Friends',
              textWidget: Wrap(
                children: [
                  Image.asset(
                    shareIcon,
                    width: 21,
                    height: 21,
                    color: whiteColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Invite Friends",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: whiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              borderRadius: 8,
              alignment: Alignment.center,
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
