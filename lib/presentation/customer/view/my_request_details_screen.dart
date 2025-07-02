import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';

class MyRequestDetailsScreen extends StatefulWidget {
  const MyRequestDetailsScreen({super.key, required this.type});
  final String? type;

  @override
  State<MyRequestDetailsScreen> createState() => _MyRequestDetailsScreenState();
}

class _MyRequestDetailsScreenState extends State<MyRequestDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomStatusBarWidget(
              title: AppLocalizations.of(context)!.myRequestString,
              text: CustomRichText(
                title: '${AppLocalizations.of(context)!.myRequestString}: ',
                value: widget.type == 'urban'
                    ? AppLocalizations.of(context)!.urbanString
                    : AppLocalizations.of(context)!.ruralString,
                titleStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 20,
                      color: whiteColor,
                    ),
                valueStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 22,
                      color: whiteColor,
                    ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomText(text: AppLocalizations.of(context)!.pickupLocationString),
            const SizedBox(
              height: 8,
            ),
            ShowLocationWidget(
              address: 'Flat No. 203, Sai Residency, Indore',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Divider(
                color: primaryColor,
              ),
            ),
            CustomText(text: AppLocalizations.of(context)!.destinationLocationString),
            const SizedBox(
              height: 8,
            ),
            ShowLocationWidget(
              address: 'Flat No. 203, Sai Residency, Indore',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Divider(
                color: primaryColor,
              ),
            ),
            CustomText(text: AppLocalizations.of(context)!.receiverNameString),
            const SizedBox(
              height: 8,
            ),
            CustomTextMedium(text: 'Vinod Sharma'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Divider(
                color: primaryColor,
              ),
            ),
            CustomText(text: AppLocalizations.of(context)!.contactNoString),
            const SizedBox(
              height: 8,
            ),
            CustomTextMedium(text: '+91 1234567890'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Divider(
                color: primaryColor,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomRichText(
                title: '${AppLocalizations.of(context)!.statusString}: ',
                value: 'Pending',
                titleStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                valueStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
            widget.type == 'rural'
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Divider(
                      color: primaryColor,
                    ),
                  )
                : SizedBox.shrink(),
            widget.type == 'urban'
                ? const SizedBox(
                    height: 20,
                  )
                : SizedBox.shrink(),
            widget.type == 'urban'
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: size.width * 0.1),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          imageIcon,
                          height: size.width * 0.25,
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            widget.type == 'urban'
                ? const SizedBox(
                    height: 20,
                  )
                : SizedBox.shrink(),
            widget.type == 'urban'
                ? CustomText(text: AppLocalizations.of(context)!.descriptionString)
                : SizedBox.shrink(),
            widget.type == 'urban'
                ? const SizedBox(
                    height: 8,
                  )
                : SizedBox.shrink(),
            widget.type == 'urban'
                ? CustomTextMedium(
                    text:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                  )
                : SizedBox.shrink(),
            widget.type == 'rural'
                ? CustomText(text: AppLocalizations.of(context)!.productTypeString)
                : SizedBox.shrink(),
            widget.type == 'rural'
                ? const SizedBox(
                    height: 8,
                  )
                : SizedBox.shrink(),
            widget.type == 'rural'
                ? CustomTextMedium(text: 'Lorem ipsum dolor sit')
                : SizedBox.shrink(),
            widget.type == 'rural'
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Divider(
                      color: primaryColor,
                    ),
                  )
                : SizedBox.shrink(),
            widget.type == 'rural'
                ? CustomText(text: AppLocalizations.of(context)!.packagingTypeString)
                : SizedBox.shrink(),
            widget.type == 'rural'
                ? const SizedBox(
                    height: 8,
                  )
                : SizedBox.shrink(),
            widget.type == 'rural'
                ? CustomTextMedium(text: 'Lorem ipsum dolor sit')
                : SizedBox.shrink(),
            widget.type == 'rural'
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Divider(
                      color: primaryColor,
                    ),
                  )
                : SizedBox.shrink(),
            widget.type == 'rural'
                ? CustomText(text: AppLocalizations.of(context)!.quantityString)
                : SizedBox.shrink(),
            widget.type == 'rural'
                ? const SizedBox(
                    height: 8,
                  )
                : SizedBox.shrink(),
            widget.type == 'rural'
                ? CustomTextMedium(text: 'Lorem ipsum dolor sit')
                : SizedBox.shrink(),
            widget.type == 'rural'
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Divider(
                      color: primaryColor,
                    ),
                  )
                : SizedBox.shrink(),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
