import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/location/location_service.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class UrbanRequestScreen extends StatefulWidget {
  const UrbanRequestScreen({super.key});

  @override
  State<UrbanRequestScreen> createState() => _UrbanRequestScreenState();
}

class _UrbanRequestScreenState extends State<UrbanRequestScreen> {
  final TextEditingController currentLocationController = TextEditingController();
  final TextEditingController itemDescriptionController = TextEditingController();
  final TextEditingController receiverNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  late final List<Placemark> placemarks;

  File? image;
  String? fileName;

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

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemporary = File(image.path);

      setState(() {
        this.image = imageTemporary;
        fileName = path.basename(image.path);
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

  void deleteImage() {
    setState(() {
      image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomStatusBarWidget(
              title: AppLocalizations.of(context)!.urbanString,
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
              height: 20,
            ),

            CustomText(
              text: AppLocalizations.of(context)!.selectItemsString,
              fontSize: 20,
            ),
            const SizedBox(
              height: 8,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                onTap: () async {
                  await pickImage();
                },
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor2),
                readOnly: true,
                controller: TextEditingController(
                  text: image != null ? fileName : AppLocalizations.of(context)!.pickImageString,
                ),
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  prefixIconConstraints: BoxConstraints(minHeight: 32, minWidth: 24),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Image.asset(
                      imageIcon,
                      width: 24,
                      height: 32,
                    ),
                  ),
                  suffixIcon: image != null
                      ? IconButton(
                          icon: Icon(Icons.close),
                          color: primaryColor,
                          onPressed: () {
                            deleteImage();
                          },
                        )
                      : SizedBox.shrink(),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),

            CustomText(
              text: AppLocalizations.of(context)!.descriptionString,
              fontSize: 20,
            ),
            const SizedBox(
              height: 8,
            ),

            CustomTextField(
              textEditingController: itemDescriptionController,
              maxLines: 5,
            ),

            const SizedBox(
              height: 8,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomElevatedButton(
                name: '+ ${AppLocalizations.of(context)!.addMoreItemsString}',
                borderRadius: 4,
                alignment: Alignment.centerRight,
                onPressed: () {},
              ),
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
              height: 12,
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
              onPressed: () {
                context.pushNamed(myRequestScreen, extra: {
                  'type': 'urban',
                });
              },
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
