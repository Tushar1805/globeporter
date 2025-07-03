import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class TripInfoScreen extends StatefulWidget {
  const TripInfoScreen({super.key, required this.type});
  final String? type;

  @override
  State<TripInfoScreen> createState() => _TripInfoScreenState();
}

class _TripInfoScreenState extends State<TripInfoScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      widget.type == 'urban'
          ? showCustomDialogOneButton(
              context: context,
              borderRadius: 18,
              title: AppLocalizations.of(context)!.reachedPickupLocationMsgString,
              buttonTitle: AppLocalizations.of(context)!.okString,
              onTap: () {
                context.pop();
                context.pushNamed(startTripScreen, extra: {
                  'type': widget.type,
                });
              },
            )
          : showDynamicItemDialog(
              context: context,
              type: widget.type,
            );
    });
  }

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
                  const SizedBox(width: 15),
                  Center(
                    child: Text(
                      'Vinod Kumar',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  SizedBox(width: size.width * 0.09),
                  Image.asset(
                    phoneCallIcon,
                    width: 24,
                    color: whiteColor,
                  ),
                ],
              ),
            ),
            Positioned(
              right: 15,
              top: size.width * 0.1,
              child: Text(
                widget.type == 'urban'
                    ? AppLocalizations.of(context)!.urbanString
                    : AppLocalizations.of(context)!.ruralString,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: 22, color: whiteColor),
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
            const SizedBox(
              height: 24,
            ),
            CustomText(
              text: AppLocalizations.of(context)!.mapString,
              fontSize: 18,
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: size.width,
              height: size.width * 0.9,
              child: Image.asset(
                mapImage,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
