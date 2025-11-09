import 'dart:async';
import 'package:core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:globeporter/location/cubit/location_cubit.dart';
import 'package:globeporter/location/model/search_places_response.dart';
import 'package:globeporter/location/states/location_states.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:uuid/uuid.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final locationCubit = sl<LocationCubit>();
  final TextEditingController locationController = TextEditingController();
  final Completer<GoogleMapController> _mapController = Completer();

  LatLng? selectedLatLng;
  SearchPlacesResponse? searchPlacesResponse;

  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(20.5574253, 78.8386951),
    zoom: 14,
  );

  Timer? _debounce;
  bool _suppressOnChange = false;
  String? _sessionToken;
  final uuid = Uuid();

  @override
  void initState() {
    super.initState();
    locationController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    locationController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (_suppressOnChange) return;

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      final input = locationController.text.trim();
      if (input.isEmpty) {
        setState(() => searchPlacesResponse = null);
        return;
      }
      _sessionToken ??= uuid.v4();
      locationCubit.searchPickupPlaces(
        input: input,
        sesssionToken: _sessionToken,
      );
    });
  }

  Future<void> _moveToLocation(LatLng latLng) async {
    final controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  Future<void> _onPlaceSelected(String placeDescription) async {
    try {
      // Stop triggering listener
      _suppressOnChange = true;
      locationController.text = placeDescription;

      // Hide list & reset
      setState(() {
        searchPlacesResponse = null;
        _sessionToken = null;
      });

      FocusScope.of(context).unfocus();
      await Future.delayed(const Duration(milliseconds: 200));
      _suppressOnChange = false;

      final locations = await geocoding.locationFromAddress(placeDescription);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        final latLng = LatLng(loc.latitude, loc.longitude);

        setState(() => selectedLatLng = latLng);
        await _moveToLocation(latLng);
      }
    } catch (e) {
      debugPrint('❌ Error fetching geocode: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Drop Location'),
        foregroundColor: whiteColor,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _mapController.complete(controller),
            onTap: (latLng) => setState(() => selectedLatLng = latLng),
            markers: selectedLatLng != null
                ? {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: selectedLatLng!,
                    )
                  }
                : {},
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
          ),

          /// 🔍 Location search input
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: CustomLocationBox(
              currentLocationController: locationController,
              readOnly: false,
              fillColor: whiteColor,
              hint: 'Enter Location',
            ),
          ),

          /// 📍 Predictions List
          BlocConsumer(
            bloc: locationCubit,
            listener: (context, state) {
              if (state is SearchPickupLocationResultState) {
                setState(() {
                  searchPlacesResponse = state.data as SearchPlacesResponse?;
                });
              }
            },
            builder: (context, state) {
              final predictions = searchPlacesResponse?.predictions ?? [];
              if (predictions.isEmpty) return const SizedBox();

              return Positioned(
                top: 65,
                left: 25,
                right: 25,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: predictions.length,
                    itemBuilder: (context, index) {
                      final place = predictions[index];
                      return ListTile(
                        title: Text(place.description ?? ''),
                        onTap: () => _onPlaceSelected(place.description ?? ''),
                      );
                    },
                  ),
                ),
              );
            },
          ),

          /// ✅ Confirm Button
          if (selectedLatLng != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: IgnorePointer(
                key: const ValueKey('location_input'),
                ignoring: false,
                child: CustomElevatedButton(
                  name: 'Select This Location',
                  borderRadius: 12,
                  alignment: Alignment.center,
                  onPressed: () {
                    context.pop({
                      'lat': selectedLatLng!.latitude,
                      'lng': selectedLatLng!.longitude,
                      'loc': locationController.text,
                    });
                  },
                  nameSize: 18,
                  textPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
