import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';

class ItemDetailsScreen extends StatefulWidget {
  const ItemDetailsScreen({super.key, required this.type});
  final String? type;

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.35),
        child: Stack(
          children: [
            Container(
              height: size.width * 0.35,
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(size.width * 0.127),
                  bottomRight: Radius.circular(size.width * 0.127),
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.05,
              left: size.width * 0.05,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: size.width * 0.1,
                    child: CircleAvatar(
                      radius: size.width * 0.097,
                      backgroundImage: AssetImage(
                        profileImage,
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 15),
                  Center(
                    child: Text(
                      'Vinod Kumar',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: size.width * 0.08,
              bottom: size.width * 0.1,
              child: Image.asset(
                phoneCallIcon,
                width: 24,
                color: whiteColor,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            CustomText(text: AppLocalizations.of(context)!.pickupLocationString),
            const SizedBox(
              height: 4,
            ),
            ShowLocationWidget(
              address: 'Flat No. 203, Sai Residency, Indore',
            ),
            const SizedBox(
              height: 12,
            ),
            CustomText(text: AppLocalizations.of(context)!.destinationLocationString),
            const SizedBox(
              height: 4,
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
            CustomText(text: AppLocalizations.of(context)!.itemDetailsString),
            const SizedBox(
              height: 20,
            ),
            CustomText(
              text: AppLocalizations.of(context)!.itemImageString,
              fontSize: 16,
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
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
            ),
            const SizedBox(
              height: 12,
            ),
            CustomText(text: AppLocalizations.of(context)!.descriptionString),
            const SizedBox(
              height: 8,
            ),
            CustomTextMedium(
              text:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
            ),
            SizedBox(
              height: size.width * 0.1,
            ),
            CustomElevatedButton(
              name: AppLocalizations.of(context)!.goString,
              borderRadius: 5,
              alignment: Alignment.center,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
