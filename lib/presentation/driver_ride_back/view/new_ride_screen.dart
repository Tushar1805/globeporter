// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:core/app_widgets.dart';
import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/location/cubit/location_cubit.dart';
import 'package:globeporter/location/model/search_places_response.dart';
import 'package:globeporter/location/states/location_states.dart';
import 'package:globeporter/presentation/authentication/model/vehicle_type_response_model.dart';
import 'package:globeporter/presentation/driver_ride_back/cubit/driver_ride_back_cubit.dart';
import 'package:globeporter/presentation/driver_ride_back/states/driver_ride_back_state.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_utils.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class NewRideScreen extends StatefulWidget {
  const NewRideScreen({super.key});

  @override
  State<NewRideScreen> createState() => _NewRideScreenState();
}

class _NewRideScreenState extends State<NewRideScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final locationCubit = sl<LocationCubit>();
  final driverRideBackCubit = sl<DriverRideBackCubit>();
  final TextEditingController currentLocationController = TextEditingController();
  final TextEditingController destinationLocationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  late final List<geocoding.Placemark> placemarks;
  SearchPlacesResponse? searchPlacesResponse;
  VehicleTypeResponseModel? vehicleTypeResponseModel;
  bool _suppressOnChange = true;
  String? _sessionToken;
  String? moveDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String? moveTime = DateFormat('HH:mm:ss').format(DateTime.now());

  var uuid = Uuid();
  Timer? _debounce;
  FToast? fToast;

  LatLng source = const LatLng(18.6668, 73.9339); // Genesis
  // LatLng destination = const LatLng(21.13435977301947, 79.08025792574747); // Dhantoli Nagpur
  LatLng? destination; // Dhantoli Nagpur
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(20.5574253, 78.8386951),
    zoom: 14,
  );
  Position? position;

  int seats = 3;
  DateTime selectedDateTime = DateTime.now();
  String? selectedVehicle;
  int? selectedVehicleId;
  List<Marker>? _markers;
  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  void getCurrentLocation() async {
    try {
      position = await locationCubit.determinePosition();
      debugPrint("Position: ${position?.latitude} :: ${position?.longitude}");

      try {
        placemarks = await geocoding.placemarkFromCoordinates(
          position!.latitude,
          position!.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          currentLocationController.text =
              "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.postalCode ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";
        } else {
          currentLocationController.text = "Current location unavailable";
        }
      } catch (e) {
        debugPrint("⚠️ Geocoding failed: $e");
        currentLocationController.text = "Unable to fetch address";
      }
      source = LatLng(position?.latitude ?? 18.6668, position?.longitude ?? 73.9339);
      // final placemarks2 = await geocoding.placemarkFromCoordinates(
      //   destination.latitude,
      //   destination.longitude,
      // );
      // destinationLocationController.text = placemarks2.isNotEmpty
      //     ? "${placemarks2[0].street}, ${placemarks2[0].subLocality}, ${placemarks2[0].locality}, ${placemarks2[0].postalCode}, ${placemarks2[0].administrativeArea}, ${placemarks2[0].country}"
      //     : "";
      final GoogleMapController controller = await _controller.future;
      final icon = await getBytesFromAssets(path: truckIcon, width: 50);
      setState(() {
        _suppressOnChange = false;
        _kGooglePlex = CameraPosition(
          target: LatLng(position?.latitude ?? 20.5574253, position?.longitude ?? 78.8386951),
          zoom: 14,
        );

        _markers = <Marker>[
          Marker(
            icon: BitmapDescriptor.bytes(icon),
            markerId: MarkerId('pickup'),
            position: LatLng(position?.latitude ?? 20.5574253, position?.longitude ?? 78.8386951),
            // infoWindow: InfoWindow(title: 'The title of the marker'),
            flat: true,
          )
        ];
        // routeDirections();
        controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
      });
    } catch (e) {
      debugPrint("Error: Getting Location: $e");
    } finally {
      if (mounted) setState(() => _suppressOnChange = false);
    }
  }

  void routeDirections() async {
    //* Route the directions
    await locationCubit
        .routeDirection(
      pickupLat: source.latitude,
      pickupLng: source.longitude,
      dropLat: destination!.latitude,
      dropLng: destination!.longitude,
    )
        .then((final response) {
      setState(() {});
      final points = response?.routes?[0].overviewPolyline?.points ?? '';
      polylineCoordinates = decodePolyline(points);

      polylines.add(
        Polyline(
          polylineId: PolylineId("route"),
          points: polylineCoordinates,
          color: Colors.black,
          width: 5,
        ),
      );

      _markers?.add(
        Marker(
          markerId: MarkerId('drop'),
          position: destination!,
          infoWindow: InfoWindow(title: 'Home'),
        ),
      );

      setState(() {});
    });
  }

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );
      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          moveDate = DateFormat('yyyy-MM-dd').format(selectedDateTime);
          moveTime = DateFormat('HH:mm:ss').format(selectedDateTime);
        });
      }
    }
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

      if (destinationLocationController.text.isNotEmpty) {
        getSuggestion(destinationLocationController.text);
      }
    });
  }

  void getSuggestion(String input) async {
    locationCubit.searchPickupPlaces(input: input, sesssionToken: _sessionToken);
  }

  void getVehicleTypes() async {
    await driverRideBackCubit.getVehicleTypes();
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast!.init(context);

    getCurrentLocation();
    destinationLocationController.addListener(() {
      onChange();
    });
    getVehicleTypes();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    currentLocationController.dispose();
    destinationLocationController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: (final controller) {
              _controller.complete(controller);
            },
            initialCameraPosition: _kGooglePlex,
            markers: Set<Marker>.of(_markers ?? []),
            mapToolbarEnabled: false,
            myLocationEnabled: false,
            polylines: polylines,
            onTap: (LatLng tappedLatLng) async {
              try {
                // reverse-geocode to human-readable address
                final placemarks = await geocoding.placemarkFromCoordinates(
                  tappedLatLng.latitude,
                  tappedLatLng.longitude,
                );
                String selectedAddress = "";
                if (placemarks.isNotEmpty) {
                  final place = placemarks.first;
                  selectedAddress =
                      "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.administrativeArea}, ${place.country}";
                }

                // update textfield + cubit
                setState(() {
                  _suppressOnChange = true;
                  destinationLocationController.text = selectedAddress;
                  locationCubit.currentLocation = selectedAddress;
                  destination = tappedLatLng;
                  _markers?.add(
                    Marker(
                      markerId: const MarkerId('selected_location'),
                      position: tappedLatLng,
                      infoWindow: InfoWindow(title: selectedAddress),
                    ),
                  );
                });

                setState(() {
                  searchPlacesResponse = null;
                  _sessionToken = null;
                });

                FocusScope.of(context).unfocus();
                routeDirections();

                // animate camera to new location
                final GoogleMapController mapController = await _controller.future;

                customPrint("Destination lat: ${destination?.latitude}");
                customPrint("Destination lng: ${destination?.longitude}");
                customPrint("Destination address: ${destinationLocationController.text}");
                mapController.animateCamera(CameraUpdate.newLatLng(tappedLatLng));
              } catch (e) {
                debugPrint("Error selecting location from map: $e");
              }
            },
          ),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: context.pop,
                    child: Icon(
                      Icons.arrow_back_ios_new,
                    ),
                  )
                ],
              ),
            ),
          ),

          // Bottom sheet
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Vehicle Tabs
                  BlocListener(
                    bloc: driverRideBackCubit,
                    listener: (final context, final state) {
                      if (state is VehicleTypesLoadedState) {
                        vehicleTypeResponseModel = state.data as VehicleTypeResponseModel?;
                        selectedVehicle = vehicleTypeResponseModel?.data?[0]?.name;
                        selectedVehicleId = vehicleTypeResponseModel?.data?[0]?.id;
                        setState(() {});
                      }
                    },
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: (vehicleTypeResponseModel?.data != null
                            ? vehicleTypeResponseModel!.data!
                                .where((vehicle) => vehicle != null)
                                .map((vehicle) {
                                final isSelected = selectedVehicleId == vehicle?.id;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedVehicleId = vehicle?.id;
                                        selectedVehicle = vehicle?.name;
                                      });
                                    },
                                    child: Container(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isSelected ? secondaryColor : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: primaryColor, width: 1),
                                      ),
                                      child: Row(
                                        children: [
                                          // Image.network(
                                          //   vehicle?.imageUrl ?? '',
                                          //   height: 24,
                                          //   width: 24,
                                          //   errorBuilder: (context, error, stackTrace) => Icon(
                                          //       Icons.directions_car,
                                          //       color: primaryColor,
                                          //       size: 20),
                                          // ),
                                          // const SizedBox(width: 6),
                                          Text(
                                            vehicle?.name ?? '',
                                            style: TextStyle(
                                              color: primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList()
                            : []),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Source & Destination
                  Row(
                    children: [
                      const Icon(Icons.circle, size: 10, color: Colors.blue),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          currentLocationController.text.isEmpty
                              ? 'Fetching your location...'
                              : currentLocationController.text,
                          style: theme.bodyMedium,
                        ),
                      ),
                      const Icon(
                        Icons.my_location,
                        size: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.green),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: locale.enterYourDestinationString,
                            hintStyle: theme.bodyMedium?.copyWith(
                              color: Colors.grey.shade500,
                            ),
                          ),
                          controller: destinationLocationController,
                          style: theme.bodyMedium,
                        ),
                      ),
                      const Icon(Icons.swap_vert_circle_outlined, size: 18),
                    ],
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
                                  destinationLocationController.text = selectedDescription;

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

                                      destination = latLng;
                                      routeDirections();

                                      setState(() {
                                        _markers?.add(Marker(
                                          markerId: MarkerId('selected_location'),
                                          position: latLng,
                                          infoWindow: InfoWindow(title: selectedDescription),
                                        ));
                                      });

                                      final GoogleMapController mapController =
                                          await _controller.future;
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
                  const SizedBox(height: 14),

                  // Date/Time & Seats
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _pickDateTime,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              DateFormat('dd MMM, hh:mm a').format(selectedDateTime),
                              style: theme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      // const Spacer(),
                      // const Icon(Icons.chair, size: 18),
                      // const SizedBox(width: 5),
                      // IconButton(
                      //   icon: const Icon(Icons.remove),
                      //   onPressed: () => setState(() {
                      //     if (seats > 1) seats--;
                      //   }),
                      // ),
                      // Text("$seats"),
                      // IconButton(
                      //   icon: const Icon(Icons.add),
                      //   onPressed: () => setState(() => seats++),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Fare and Offer Button
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 40,
                        child: CustomTextField(
                          padding: EdgeInsets.zero,
                          textEditingController: priceController,
                          hint: '100',
                          prefixIcon: const Icon(Icons.currency_rupee, size: 20),
                          textStyle: theme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      BlocConsumer(
                        bloc: driverRideBackCubit,
                        listener: (final context, final state) {
                          if (state is PlaceDriverRideLoadedState) {
                            showToast(
                              context: context,
                              fToast: fToast!,
                              msg: locale.requestSuccessfullyPostedString,
                              duration: 3,
                            );
                            context.pop();
                          }
                        },
                        builder: (final context, final state) {
                          if (state is PlaceDriverRideLoadingState) return LoadingWithoutText();
                          return ElevatedButton(
                            onPressed: () async {
                              if (destinationLocationController.text.isEmpty) {
                                showToast(
                                  context: context,
                                  fToast: fToast!,
                                  msg:
                                      '${locale.pleaseEnterString} ${locale.destinationLocationString.toLowerCase()}',
                                  duration: 3,
                                );
                              } else if (priceController.text.isEmpty) {
                                showToast(
                                  context: context,
                                  fToast: fToast!,
                                  msg:
                                      '${locale.pleaseEnterString} ${locale.amountString.toLowerCase()}',
                                  duration: 3,
                                );
                              } else {
                                await driverRideBackCubit.placeDriverBookingRide(
                                  vehicleTypeId: selectedVehicleId ?? 1,
                                  pickupAddress: currentLocationController.text,
                                  // pickupAddress: 'Q-27, Okhla, New Delhi, 110025, Delhi, India',
                                  dropAddress: destinationLocationController.text,
                                  pickupLat: source.latitude.toString(),
                                  pickupLng: source.longitude.toString(),
                                  // pickupLat: '28.568279922288895',
                                  // pickupLng: '77.28683285415173',
                                  dropLat: destination?.latitude.toString() ?? '',
                                  dropLng: destination?.longitude.toString() ?? '',
                                  price: priceController.text,
                                  moveDate: moveDate ?? '',
                                  moveTime: moveTime ?? '',
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                            ),
                            child: Text(
                              locale.postRequestString,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: whiteColor, fontSize: 18),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
