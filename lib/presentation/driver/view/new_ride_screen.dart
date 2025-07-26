// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/location/cubit/location_cubit.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class NewRideScreen extends StatefulWidget {
  const NewRideScreen({super.key});

  @override
  State<NewRideScreen> createState() => _NewRideScreenState();
}

class _NewRideScreenState extends State<NewRideScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final locationCubit = sl<LocationCubit>();
  final TextEditingController currentLocationController = TextEditingController();
  final TextEditingController destinationLocationController = TextEditingController();
  late final List<Placemark> placemarks;

  LatLng source = const LatLng(18.6668, 73.9339); // Genesis
  LatLng destination = const LatLng(21.13435977301947, 79.08025792574747); // Dhantoli Nagpur
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(20.5574253, 78.8386951),
    zoom: 14,
  );
  Position? position;

  int seats = 3;
  DateTime selectedDateTime = DateTime.now();
  String selectedVehicle = 'Car';
  List<Marker>? _markers;
  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  void getCurrentLocation() async {
    try {
      position = await locationCubit.determinePosition();
      debugPrint("Position: ${position?.latitude} :: ${position?.longitude}");
      placemarks = await placemarkFromCoordinates(
        position?.latitude ?? 20.5574253,
        position?.longitude ?? 78.8386951,
      );
      currentLocationController.text = placemarks.isNotEmpty
          ? "${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].postalCode}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}"
          : "";
      source = LatLng(position?.latitude ?? 18.6668, position?.longitude ?? 73.9339);
      final placemarks2 = await placemarkFromCoordinates(
        destination.latitude,
        destination.longitude,
      );
      destinationLocationController.text = placemarks2.isNotEmpty
          ? "${placemarks2[0].street}, ${placemarks2[0].subLocality}, ${placemarks2[0].locality}, ${placemarks2[0].postalCode}, ${placemarks2[0].administrativeArea}, ${placemarks2[0].country}"
          : "";
      final GoogleMapController controller = await _controller.future;
      final icon = await getBytesFromAssets(path: truckIcon, width: 50);
      setState(() {
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
        routeDirections();
        controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
      });
    } catch (e) {
      debugPrint("Error: Getting Location: $e");
    }
  }

  void routeDirections() async {
    //* Route the directions
    await locationCubit
        .routeDirection(
      pickupLat: source.latitude,
      pickupLng: source.longitude,
      dropLat: destination.latitude,
      dropLng: destination.longitude,
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
          position: destination,
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
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:
                          ["Car", "Bike", "Rider", 'Truck', 'Mini Truck', 'Pickup Truck'].map((v) {
                        final isSelected = selectedVehicle == v;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                            onTap: () => setState(() => selectedVehicle = v),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? secondaryColor : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(v,
                                  style:
                                      TextStyle(color: primaryColor, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        );
                      }).toList(),
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
                          currentLocationController.text,
                          style: Theme.of(context).textTheme.bodyMedium,
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
                          child: Text(destinationLocationController.text,
                              style: Theme.of(context).textTheme.bodyMedium)),
                      const Icon(Icons.swap_vert_circle_outlined, size: 18),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Date/Time & Seats
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _pickDateTime,
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 18),
                            const SizedBox(width: 5),
                            Text(
                              DateFormat('dd MMM, hh:mm a').format(selectedDateTime),
                              style: Theme.of(context).textTheme.bodyMedium,
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
                      // const Icon(Icons.currency_rupee, size: 20),
                      // const Text("104",
                      //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      // const SizedBox(width: 10),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      //   decoration: BoxDecoration(
                      //       color: primaryColor, borderRadius: BorderRadius.circular(6)),
                      //   child: Text(AppLocalizations.of(context)!.newString,
                      //       style: TextStyle(color: Colors.white, fontSize: 12)),
                      // ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.offerRideString,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: whiteColor, fontSize: 18),
                        ),
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
