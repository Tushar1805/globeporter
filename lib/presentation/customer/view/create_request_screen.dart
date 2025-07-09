import 'dart:async';

import 'package:core/di/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/location/cubit/location_cubit.dart';
import 'package:globeporter/location/model/search_places_response.dart';
import 'package:globeporter/location/states/location_states.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final TextEditingController currentLocationController = TextEditingController();
  final Completer<GoogleMapController> _controller = Completer();
  final locationCubit = sl<LocationCubit>();
  SearchPlacesResponse? searchPlacesResponse;
  late final List<Placemark> placemarks;
  bool isUrban = true;
  Position? position;
  String? _sessionToken;
  var uuid = Uuid();
  Timer? _debounce;
  bool _suppressOnChange = false;

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(20.5574253, 78.8386951),
    zoom: 14,
  );

  List<Marker>? _markers;

  void getCurrentLocation() async {
    try {
      position = locationCubit.position;
      debugPrint("Position: ${position?.latitude} :: ${position?.longitude}");
      placemarks = await placemarkFromCoordinates(
          position?.latitude ?? 20.5574253, position?.longitude ?? 78.8386951);
      currentLocationController.text = placemarks.isNotEmpty
          ? "${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].postalCode}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}"
          : "";
      final GoogleMapController controller = await _controller.future;
      setState(() {
        _kGooglePlex = CameraPosition(
          target: LatLng(position?.latitude ?? 20.5574253, position?.longitude ?? 78.8386951),
          zoom: 14,
        );
        _markers = <Marker>[
          Marker(
              markerId: MarkerId('1'),
              position: LatLng(position?.latitude ?? 20.5574253, position?.longitude ?? 78.8386951),
              infoWindow: InfoWindow(title: 'The title of the marker'))
        ];
        controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
      });
    } catch (e) {
      debugPrint("Error: Getting Location: $e");
    }

    // placemarks.forEach((place) {
    //   debugPrint("Place: ${place.toJson().toString()} \n");
    // });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();

    currentLocationController.addListener(() {
      onChange();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    currentLocationController.dispose();
    super.dispose();
  }

  void onChange() {
    if (_suppressOnChange) return;
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (_sessionToken == null) {
        setState(() {
          _sessionToken = uuid.v4();
        });
      }

      if (currentLocationController.text.isNotEmpty) {
        getSuggestion(currentLocationController.text);
      }
    });
  }

  void getSuggestion(String input) async {
    locationCubit.searchPlaces(input: input, sesssionToken: _sessionToken);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: ScrollController(),
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

            BlocConsumer(
              bloc: locationCubit,
              listener: (final context, final state) {
                if (state is SearchLocationResultState) {
                  setState(() {
                    searchPlacesResponse = state.data as SearchPlacesResponse?;
                  });
                }
              },
              builder: (final context, final state) {
                final predictions = searchPlacesResponse?.predictions ?? [];

                if (predictions.isEmpty) return const SizedBox();

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: List.generate(
                      predictions.length,
                      (index) {
                        final place = predictions[index];
                        return InkWell(
                          onTap: () async {
                            final selectedDescription = place.description ?? '';

                            // Suppress onChange
                            _suppressOnChange = true;
                            currentLocationController.text = selectedDescription;

                            setState(() {
                              searchPlacesResponse = null;
                              _sessionToken = null;
                            });

                            FocusScope.of(context).unfocus();

                            // Allow onChange again after a short delay (e.g. next event loop)
                            Future.delayed(Duration(milliseconds: 100), () {
                              _suppressOnChange = false;
                            });

                            try {
                              List<Location> locations =
                                  await locationFromAddress(selectedDescription);
                              if (locations.isNotEmpty) {
                                final latLng =
                                    LatLng(locations[0].latitude, locations[0].longitude);

                                setState(() {
                                  _markers = <Marker>[
                                    Marker(
                                      markerId: MarkerId('selected_location'),
                                      position: latLng,
                                      infoWindow: InfoWindow(title: selectedDescription),
                                    ),
                                  ];
                                });

                                final GoogleMapController mapController = await _controller.future;
                                mapController.animateCamera(CameraUpdate.newLatLng(latLng));
                              }
                            } catch (e) {
                              debugPrint('Error getting location: $e');
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey)),
                            ),
                            child: Text(
                              place.description ?? '',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
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
              height: size.height * 0.5,
              child: GoogleMap(
                initialCameraPosition: _kGooglePlex,
                markers: Set<Marker>.of(_markers ?? []),
                myLocationEnabled: true,
                onMapCreated: (final controller) {
                  _controller.complete(controller);
                },
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
                  ),
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
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
