import 'dart:async';
import 'dart:math';

import 'package:core/di/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/location/cubit/location_cubit.dart';
import 'package:globeporter/location/model/search_places_response.dart';
import 'package:globeporter/location/states/location_states.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_keys.dart';
import 'package:globeporter/resources/app_storage.dart';
import 'package:globeporter/resources/app_utils.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:uuid/uuid.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key, this.onSubmitTap});
  final VoidCallback? onSubmitTap;

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final TextEditingController currentLocationController = TextEditingController();
  final Completer<GoogleMapController> _controller = Completer();
  final locationCubit = sl<LocationCubit>();
  final authCubit = sl<AuthCubit>();
  final storage = sl<SecureStorage>();
  SearchPlacesResponse? searchPlacesResponse;
  late final List<geocoding.Placemark> placemarks;
  bool isUrban = true;
  Position? position;
  String? _sessionToken;
  var uuid = Uuid();
  Timer? _debounce;
  bool _suppressOnChange = true;
  final loc.Location _location = loc.Location();
  LatLng? _currentPosition;
  StreamSubscription<loc.LocationData>? _locationSubscription;

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(20.5574253, 78.8386951),
    zoom: 14,
  );

  List<Marker>? _markers;

  void getCurrentLocation() async {
    try {
      position = await locationCubit.determinePosition();
      debugPrint("Position: ${position?.latitude} :: ${position?.longitude}");
      placemarks = await geocoding.placemarkFromCoordinates(
          position?.latitude ?? 20.5574253, position?.longitude ?? 78.8386951);
      currentLocationController.text = placemarks.isNotEmpty
          ? "${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].postalCode}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}"
          : "";
      locationCubit.currentLocation = currentLocationController.text;
      locationCubit.position = position;
      final GoogleMapController controller = await _controller.future;
      setState(() {
        _suppressOnChange = false;
        _kGooglePlex = CameraPosition(
          target: LatLng(position?.latitude ?? 20.5574253, position?.longitude ?? 78.8386951),
          zoom: 14,
        );
        _markers = <Marker>[
          Marker(
            markerId: MarkerId('1'),
            position: LatLng(position?.latitude ?? 20.5574253, position?.longitude ?? 78.8386951),
            // infoWindow: InfoWindow(title: 'The title of the marker'),
          )
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

  Future<void> startTracking() async {
    final permissionGranted = await _location.requestPermission();
    final serviceEnabled = await _location.serviceEnabled() || await _location.requestService();

    if (permissionGranted != loc.PermissionStatus.granted || !serviceEnabled) {
      return;
    }

    _locationSubscription = _location.onLocationChanged.listen((locationData) {
      if (locationData.latitude == null || locationData.longitude == null) return;

      final lat = locationData.latitude!;
      final lng = locationData.longitude!;
      _currentPosition = LatLng(lat, lng);

      locationCubit.updateMyLocation(lat: lat, lng: lng);
      _fetchAndShowNearbyUsers();
    });
  }

  double _calculateDistance(lat1, lon1, lat2, lon2) {
    const R = 6371; // km
    final dLat = (lat2 - lat1) * pi / 180;
    final dLon = (lon2 - lon1) * pi / 180;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  Future<void> _fetchAndShowNearbyUsers() async {
    final data = await locationCubit.fetchNearbyUsers();
    final userId = await storage.readValue(userIdKey);
    final icon = await getBytesFromAssets(path: truckIcon, width: 50);

    if (data == null || _currentPosition == null) return;

    final nearbyMarkers = <Marker>[];

    data.forEach((key, value) {
      if (key == userId) return; // skip own marker

      final lat = value['latitude'] * 1.0;
      final lng = value['longitude'] * 1.0;

      final dist = _calculateDistance(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        lat,
        lng,
      );

      if (dist <= 20) {
        if (value['type'] == 'truck') {
          nearbyMarkers.add(Marker(
            icon: BitmapDescriptor.bytes(icon),
            markerId: MarkerId(key),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: "Nearby User ($dist km)"),
          ));
        } else {
          nearbyMarkers.add(Marker(
            icon: BitmapDescriptor.bytes(icon),
            markerId: MarkerId(key),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: "Nearby User ($dist km)"),
          ));
        }
      }
    });

    setState(() {
      _markers?.addAll(nearbyMarkers);
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    startTracking();

    currentLocationController.addListener(() {
      onChange();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    currentLocationController.dispose();
    _locationSubscription?.cancel();
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
    locationCubit.searchPickupPlaces(input: input, sesssionToken: _sessionToken);
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
                    top: size.width * 0.18,
                    right: size.width * 0.15,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          context.pushNamed(notificationScreen);
                        },
                        child: Icon(
                          Icons.notifications_active_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.width * 0.13,
                    left: size.width * 0.043,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.pushNamed(customerProfileScreen);
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: size.width * 0.12,
                            child: CircleAvatar(
                              radius: size.width * 0.116,
                              backgroundImage: NetworkImage(
                                authCubit.userDetails?.data?.profilePhotoUrl ?? sampleNetworkImage,
                              ),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        SizedBox(
                          height: size.width * 0.15,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.onboarding1Title,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Colors.white,
                                        fontSize: 24,
                                      ),
                                  textAlign: TextAlign.end,
                                ),
                                Text(
                                  authCubit.userDetails?.data?.name ?? 'User name',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.end,
                                ),
                              ],
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
                if (state is SearchPickupLocationResultState) {
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
                            locationCubit.currentLocation = currentLocationController.text;

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
                              List<geocoding.Location> locations =
                                  await geocoding.locationFromAddress(selectedDescription);
                              if (locations.isNotEmpty) {
                                final latLng =
                                    LatLng(locations[0].latitude, locations[0].longitude);
                                // Convert to Position
                                final position = Position(
                                  latitude: latLng.latitude,
                                  longitude: latLng.longitude,
                                  timestamp: DateTime.now(),
                                  accuracy: 1.0,
                                  altitude: 0.0,
                                  heading: 0.0,
                                  speed: 0.0,
                                  speedAccuracy: 0.0,
                                  altitudeAccuracy: 1.0,
                                  headingAccuracy: 1.0,
                                );

                                locationCubit.position = position;

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
                context.push(requestDetailsScreen, extra: {
                  'type': isUrban ? 'urban' : 'rural',
                });
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
                mapToolbarEnabled: false,
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
