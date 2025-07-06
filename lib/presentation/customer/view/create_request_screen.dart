import 'dart:async';

import 'package:core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/location/location_service.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final TextEditingController currentLocationController = TextEditingController();
  final Completer<GoogleMapController> _controller = Completer();
  late final List<Placemark> placemarks;
  bool isUrban = true;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(35.6844, 73.0479),
    zoom: 14,
  );

  final List<Marker> _markers = const <Marker>[
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(35.6844, 73.0479),
        infoWindow: InfoWindow(title: 'The title of the marker'))
  ];

  void getCurrentLocation() async {
    final position = await determinePosition();
    debugPrint("Position: ${position.latitude} :: ${position.longitude}");
    placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    currentLocationController.text = placemarks.isNotEmpty
        ? "${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].postalCode}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}"
        : "";
    // placemarks.forEach((place) {
    //   debugPrint("Place: ${place.toJson().toString()} \n");
    // });
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.width * 0.42,
              child: Stack(
                children: [
                  Container(
                    height: size.width * 0.3,
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
                    top: size.width * 0.123,
                    right: 15,
                    child: Center(
                      child: SvgPicture.asset(
                        appLogoSmall,
                        width: MediaQuery.sizeOf(context).width * .25,
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.068,
                    left: size.width * 0.043,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: size.width * 0.12,
                          child: CircleAvatar(
                            radius: size.width * 0.116,
                            backgroundImage: AssetImage(
                              profileImage,
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ),
                        SizedBox(width: 15),
                        SizedBox(
                          height: size.width * 0.125,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.onboarding1Title,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //* Current Location

            CustomText(text: AppLocalizations.of(context)!.currentLocationString),

            const SizedBox(
              height: 20,
            ),

            CustomLocationBox(
              currentLocationController: currentLocationController,
              readOnly: false,
            ),

            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width * 0.35,
                    child: elevatedButton(
                      onPressed: () {
                        setState(() {
                          isUrban = true;
                        });
                      },
                      title: AppLocalizations.of(context)!.urbanString,
                      backgroundColor: isUrban ? primaryColor : whiteColor,
                      textColor: isUrban ? whiteColor : primaryColor,
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  SizedBox(
                    width: size.width * 0.35,
                    child: elevatedButton(
                      onPressed: () {
                        setState(() {
                          setState(() {
                            isUrban = false;
                          });
                        });
                      },
                      title: AppLocalizations.of(context)!.ruralString,
                      backgroundColor: !isUrban ? primaryColor : whiteColor,
                      textColor: !isUrban ? whiteColor : primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            CustomElevatedButton(
              name: AppLocalizations.of(context)!.createRequestString,
              borderRadius: 25,
              alignment: Alignment.center,
              onPressed: () {
                context.push(isUrban ? urbanRequestScreen : ruralRequestScreen);
              },
              nameSize: 20,
              textPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),

            const SizedBox(
              height: 12,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppLocalizations.of(context)!.mapString,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: greyTextColor,
                      fontSize: 20,
                    ),
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            SizedBox(
              width: size.width,
              height: size.width * 0.9,
              child: Image.asset(
                mapImage,
                fit: BoxFit.cover,
              ),
            ),

            // SizedBox(
            //   height: size.height * 0.5,
            //   child: GoogleMap(
            //     initialCameraPosition: _kGooglePlex,
            //     markers: Set<Marker>.of(_markers),
            //     onMapCreated: (final controller) {
            //       _controller.complete(controller);
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget elevatedButton({
    required final VoidCallback onPressed,
    required final String? title,
    required final Color? backgroundColor,
    required final Color? textColor,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
            horizontal: 8, vertical: MediaQuery.of(context).size.height * 0.00704),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            title ?? '',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: textColor, fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
