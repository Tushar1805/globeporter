import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/location/location_service.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';

class RuralRequestScreen extends StatefulWidget {
  const RuralRequestScreen({super.key});

  @override
  State<RuralRequestScreen> createState() => _RuralRequestScreenState();
}

class _RuralRequestScreenState extends State<RuralRequestScreen> {
  final TextEditingController currentLocationController = TextEditingController();
  final TextEditingController receiverNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController packagingTypeController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  late final List<Placemark> placemarks;

  void getCurrentLocation() async {
    final position = await determinePosition();
    placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    currentLocationController.text = placemarks.isNotEmpty
        ? "${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].postalCode}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}"
        : "";
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomStatusBarWidget(
              title: AppLocalizations.of(context)!.ruralString,
            ),
            const SizedBox(
              height: 20,
            ),

            //* Pickup location
            CustomText(text: AppLocalizations.of(context)!.pickupLocationString),

            const SizedBox(
              height: 8,
            ),

            CustomLocationBox(
              currentLocationController: currentLocationController,
            ),

            const SizedBox(
              height: 15,
            ),

            CustomText(text: AppLocalizations.of(context)!.packagingTypeString),

            const SizedBox(
              height: 8,
            ),

            CustomTextField(
              textEditingController: packagingTypeController,
            ),
            const SizedBox(
              height: 15,
            ),

            CustomText(text: AppLocalizations.of(context)!.quantityString),

            const SizedBox(
              height: 8,
            ),

            CustomTextField(
              textEditingController: quantityController,
            ),
            const SizedBox(
              height: 12,
            ),
            CustomText(
              text: AppLocalizations.of(context)!.receiverNameString,
              fontSize: 20,
            ),
            const SizedBox(
              height: 8,
            ),
            CustomTextField(
              textEditingController: receiverNameController,
            ),

            const SizedBox(
              height: 15,
            ),
            CustomText(
              text: AppLocalizations.of(context)!.contactNoString,
              fontSize: 20,
            ),
            const SizedBox(
              height: 8,
            ),
            CustomTextField(
              textEditingController: contactNumberController,
            ),

            const SizedBox(
              height: 24,
            ),

            //* Destination location
            CustomText(
              text: AppLocalizations.of(context)!.destinationLocationString,
            ),

            const SizedBox(
              height: 8,
            ),

            CustomLocationBox(
              currentLocationController: currentLocationController,
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

            CustomElevatedButton(
              name: AppLocalizations.of(context)!.submitString,
              borderRadius: 25,
              alignment: Alignment.bottomCenter,
              onPressed: () {},
              textPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              nameSize: 22,
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
