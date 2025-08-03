import 'dart:async';
import 'dart:io';

import 'package:core/app_widgets.dart';
import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:datasource/states/data_state.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/location/cubit/location_cubit.dart';
import 'package:globeporter/location/model/route_direction_response.dart'
    show RouteDirectionsResponse;
import 'package:globeporter/location/model/search_places_response.dart';
import 'package:globeporter/location/states/location_states.dart';
import 'package:globeporter/presentation/authentication/model/vehicle_type_response_model.dart'
    as vehicle;
import 'package:globeporter/presentation/customer/cubit/customer_cubit.dart';
import 'package:globeporter/presentation/customer/model/packaging_type_reponse.dart' as package;
import 'package:globeporter/presentation/customer/states/customer_states.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_regex.dart';
import 'package:globeporter/resources/app_utils.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ItemEntry {
  File? imageFile;
  TextEditingController descriptionController;

  ItemEntry({
    this.imageFile,
    required this.descriptionController,
  });
}

class RequestDetailsScreen extends StatefulWidget {
  const RequestDetailsScreen({super.key, required this.type});
  final String? type;

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  final TextEditingController currentLocationController = TextEditingController();
  final TextEditingController destinationLocationController = TextEditingController();
  final TextEditingController receiverNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController packagingTypeController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  late final List<Placemark> placemarks;
  List<ItemEntry> itemEntries = [];
  final customerCubit = sl<CustomerCubit>();
  final locationCubit = sl<LocationCubit>();

  SearchPlacesResponse? searchPlacesResponse;
  RouteDirectionsResponse? routeDirectionsResponse;
  package.PackagingTypeResponse? packagingTypeResponse;
  vehicle.VehicleTypeResponseModel? vehicleTypeResponse;
  package.Data? selectedPackageType;
  vehicle.Data? selectedVehicleType;
  bool loading = false;
  String? errorMessage = '';

  FToast? fToast;
  String? _sessionToken;
  var uuid = Uuid();
  Timer? _debounce;
  bool _suppressOnChange = true;
  Position? pickupPosition;
  String? dropLat;
  String? dropLng;
  final Completer<GoogleMapController> _controller = Completer();
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(20.5574253, 78.8386951),
    zoom: 14,
  );

  List<Marker>? _markers;
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  Uint8List? customMarker;

  File? image;
  String? fileName;

  void getCurrentLocation() async {
    try {
      pickupPosition = locationCubit.position;
      debugPrint("Position: ${pickupPosition?.latitude} :: ${pickupPosition?.longitude}");
      // placemarks = await placemarkFromCoordinates(
      //     position?.latitude ?? 20.5574253, position?.longitude ?? 78.8386951);
      // currentLocationController.text = placemarks.isNotEmpty
      //     ? "${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].postalCode}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}"
      //     : "";

      currentLocationController.text = locationCubit.currentLocation ?? '';
      final GoogleMapController controller = await _controller.future;
      final icon = await getBytesFromAssets(path: truckIcon, width: 50);
      setState(() {
        _suppressOnChange = false;
        _kGooglePlex = CameraPosition(
          target: LatLng(
              pickupPosition?.latitude ?? 20.5574253, pickupPosition?.longitude ?? 78.8386951),
          zoom: 14,
        );

        _markers = <Marker>[
          Marker(
            icon: BitmapDescriptor.bytes(icon),
            markerId: MarkerId('pickup'),
            position: LatLng(
                pickupPosition?.latitude ?? 20.5574253, pickupPosition?.longitude ?? 78.8386951),
            // infoWindow: InfoWindow(title: 'The title of the marker'),
            flat: true,
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

  void getPackagingType() async {
    await customerCubit.getPackagingType();
  }

  void getVehicleType() async {
    await customerCubit.getVehicleType();
  }

  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);
    getCurrentLocation();
    getPackagingType();
    getVehicleType();
    addNewItem();
    destinationLocationController.addListener(() {
      onChange();
    });
    super.initState();
  }

  void addNewItem() {
    setState(() {
      itemEntries.add(ItemEntry(descriptionController: TextEditingController()));
    });
  }

  void removeItem(int index) {
    setState(() {
      itemEntries[index].descriptionController.dispose();
      itemEntries.removeAt(index);
    });
  }

  Future<File?> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return null;

      final imageTemporary = File(image.path);

      return imageTemporary;
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
    return null;
  }

  void deleteImage() {
    setState(() {
      image = null;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    destinationLocationController.dispose();
    receiverNameController.dispose();
    contactNumberController.dispose();
    quantityController.dispose();
    for (var item in itemEntries) {
      item.descriptionController.dispose();
    }
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

      if (destinationLocationController.text.isNotEmpty) {
        getSuggestion(destinationLocationController.text);
      }
    });
  }

  void getSuggestion(String input) async {
    locationCubit.searchDestinationPlaces(input: input, sesssionToken: _sessionToken);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (final didPop, final result) {
          setState(() {
            searchPlacesResponse = null;
          });

          context.pop();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(size.width * 0.25),
            child: CustomStatusBarWidget(
              title: widget.type == 'urban'
                  ? AppLocalizations.of(context)!.urbanString
                  : AppLocalizations.of(context)!.ruralString,
            ),
          ),
          body: BlocListener(
            bloc: customerCubit,
            listener: (final context, final state) {
              if (state is VehicleTypeLoadedState) {
                vehicleTypeResponse = state.data as vehicle.VehicleTypeResponseModel?;
                setState(() {});
              } else if (state is PackagingTypeLoadedState) {
                packagingTypeResponse = state.data as package.PackagingTypeResponse?;
                setState(() {});
              } else if (state is CustomerRequestLoadingState) {
                setState(() {
                  loading = true;
                });
              } else if (state is CustomerRequestLoadedState) {
                final data = state.data as Map<String, dynamic>;
                if (data['status_code'] == 200) {
                  context.pushReplacementNamed(myRequestScreen, extra: {
                    'type': 'urban',
                    'show': true,
                  });
                }

                setState(() {
                  loading = false;
                  errorMessage = '';
                });
              } else if (state is ErrorState) {
                setState(() {
                  loading = false;
                  errorMessage = state.errorMessage;
                });
              }
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                  //* IF Area is urban
                  widget.type == 'urban'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //* Select items
                            ...itemEntries.asMap().entries.map((entry) {
                              int index = entry.key;
                              ItemEntry item = entry.value;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                        final picked = await pickImage();
                                        if (picked != null) {
                                          setState(() {
                                            item.imageFile = picked;
                                          });
                                        }
                                      },
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: greyTextColor2),
                                      readOnly: true,
                                      controller: TextEditingController(
                                        text: item.imageFile != null
                                            ? item.imageFile!.path.split('/').last
                                            : AppLocalizations.of(context)!.pickImageString,
                                      ),
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        prefixIconConstraints:
                                            BoxConstraints(minHeight: 32, minWidth: 24),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.green),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.green),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 12),
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Image.asset(
                                            imageIcon,
                                            width: 24,
                                            height: 32,
                                          ),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.close),
                                          color: primaryColor,
                                          onPressed: () {
                                            removeItem(index);
                                          },
                                        ),
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
                                    textEditingController: item.descriptionController,
                                    maxLines: 5,
                                  ),
                                ],
                              );
                            }),

                            const SizedBox(
                              height: 8,
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: CustomElevatedButton(
                                name: '+ ${AppLocalizations.of(context)!.addMoreItemsString}',
                                borderRadius: 4,
                                alignment: Alignment.centerRight,
                                onPressed: addNewItem,
                              ),
                            ),

                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            CustomText(text: AppLocalizations.of(context)!.packagingTypeString),
                            const SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: DropdownButtonFormField2<package.Data>(
                                value: selectedPackageType,
                                isExpanded: true,
                                iconStyleData:
                                    IconStyleData(icon: const Icon(Icons.keyboard_arrow_down)),
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: primaryColor),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  maxHeight: MediaQuery.of(context).size.width * 0.5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: secondaryColor,
                                  ),
                                  offset: const Offset(0, -4),
                                  scrollbarTheme: ScrollbarThemeData(
                                    thumbColor: WidgetStateProperty.all(primaryColor),
                                    radius: const Radius.circular(4),
                                  ),
                                ),
                                items: packagingTypeResponse?.data?.map((package.Data? item) {
                                  return DropdownMenuItem<package.Data>(
                                    value: item,
                                    child: Text(
                                      item?.name ?? '',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    selectedPackageType = val;
                                  });
                                },
                              ),
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
                              inputType: TextInputType.number,
                              hint: '10',
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
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
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(nameRegex),
                    ],
                    inputType: TextInputType.name,
                    hint: 'eg. Jon Doe',
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
                    hint: '91XXXXXXXX',
                    inputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(phoneNumberRegex),
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),

                  const SizedBox(
                    height: 12,
                  ),
                  CustomText(
                    text: AppLocalizations.of(context)!.vehicleTypeString,
                    fontSize: 20,
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: DropdownButtonFormField2<vehicle.Data>(
                      value: selectedVehicleType,
                      isExpanded: true,
                      iconStyleData: IconStyleData(icon: const Icon(Icons.keyboard_arrow_down)),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        maxHeight: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: secondaryColor,
                        ),
                        offset: const Offset(0, -4),
                        scrollbarTheme: ScrollbarThemeData(
                          thumbColor: WidgetStateProperty.all(primaryColor),
                          radius: const Radius.circular(4),
                        ),
                      ),
                      items: vehicleTypeResponse?.data?.map((vehicle.Data? item) {
                        return DropdownMenuItem<vehicle.Data>(
                          value: item,
                          child: Text(
                            item?.name ?? '',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedVehicleType = val;
                        });
                      },
                    ),
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
                    currentLocationController: destinationLocationController,
                    readOnly: false,
                  ),
                  BlocConsumer(
                    bloc: locationCubit,
                    listener: (final context, final state) {
                      if (state is SearchDestinationLocationResultState) {
                        setState(() {
                          searchPlacesResponse = state.data as SearchPlacesResponse?;
                        });
                      } else if (state is RouteDirectionsLoadedState) {
                        setState(() {
                          routeDirectionsResponse = state.data as RouteDirectionsResponse?;
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

                                  Future.delayed(Duration(milliseconds: 100), () {
                                    _suppressOnChange = false;
                                  });

                                  try {
                                    List<Location> locations =
                                        await locationFromAddress(selectedDescription);
                                    if (locations.isNotEmpty) {
                                      final latLng =
                                          LatLng(locations[0].latitude, locations[0].longitude);

                                      //* Route the directions
                                      final pickup = locationCubit.position;
                                      await locationCubit
                                          .routeDirection(
                                        pickupLat: pickup?.latitude ?? 20.5574253,
                                        pickupLng: pickup?.longitude ?? 78.838695,
                                        dropLat: locations[0].latitude,
                                        dropLng: locations[0].longitude,
                                      )
                                          .then((final response) {
                                        final points =
                                            response?.routes?[0].overviewPolyline?.points ?? '';
                                        polylineCoordinates = decodePolyline(points);

                                        _polylines.add(
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
                                            position: latLng,
                                            infoWindow: InfoWindow(title: selectedDescription),
                                          ),
                                        );

                                        setState(() {
                                          dropLat = locations[0].latitude.toString();
                                          dropLng = locations[0].longitude.toString();
                                        });
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
                  const SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    height: size.width * 0.8,
                    child: GoogleMap(
                      initialCameraPosition: _kGooglePlex,
                      markers: Set<Marker>.of(_markers ?? []),
                      mapToolbarEnabled: false,
                      myLocationEnabled: true,
                      onMapCreated: (final controller) {
                        _controller.complete(controller);
                      },
                      polylines: _polylines,
                      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  loading
                      ? LoadingWithoutText()
                      : CustomElevatedButton(
                          name: AppLocalizations.of(context)!.submitString,
                          borderRadius: 25,
                          alignment: Alignment.bottomCenter,
                          onPressed: () async {
                            var enterMsg = AppLocalizations.of(context)!.pleaseEnterString;
                            if (receiverNameController.text.isEmpty) {
                              showToast(
                                context: context,
                                fToast: fToast!,
                                msg:
                                    '$enterMsg ${AppLocalizations.of(context)!.receiverNameString.toLowerCase()}',
                                duration: 3,
                              );
                            } else if (contactNumberController.text.isEmpty ||
                                contactNumberController.text.length < 10 ||
                                contactNumberController.text.length > 10) {
                              showToast(
                                context: context,
                                fToast: fToast!,
                                msg:
                                    '$enterMsg ${AppLocalizations.of(context)!.validString} ${AppLocalizations.of(context)!.phoneNumberString.toLowerCase()}',
                                duration: 3,
                              );
                            } else if (selectedVehicleType == null) {
                              showToast(
                                context: context,
                                fToast: fToast!,
                                msg: '$enterMsg ${AppLocalizations.of(context)!.vehicleTypeString}',
                                duration: 3,
                              );
                            } else if (destinationLocationController.text.isEmpty) {
                              showToast(
                                context: context,
                                fToast: fToast!,
                                msg:
                                    '$enterMsg ${AppLocalizations.of(context)!.destinationLocationString}',
                                duration: 3,
                              );
                            } else if (widget.type == 'urban') {
                              if (itemEntries.isEmpty) {
                                showToast(
                                  context: context,
                                  fToast: fToast!,
                                  msg:
                                      '$enterMsg ${AppLocalizations.of(context)!.itemDetailsString}',
                                  duration: 3,
                                );
                              } else if (itemEntries.any((entry) =>
                                  entry.imageFile == null ||
                                  entry.descriptionController.text.trim().isEmpty)) {
                                showToast(
                                  context: context,
                                  fToast: fToast!,
                                  msg:
                                      '$enterMsg ${AppLocalizations.of(context)!.validString} ${AppLocalizations.of(context)!.itemImageString.toLowerCase()} ${AppLocalizations.of(context)!.descriptionString.toLowerCase()}',
                                  duration: 3,
                                );
                              } else {
                                await customerCubit.createUrbanRequest(
                                  vehicleTypeId: selectedVehicleType?.id ?? 3,
                                  receiverName: receiverNameController.text,
                                  receiverContact: contactNumberController.text,
                                  pickupAddress: currentLocationController.text,
                                  dropAddress: destinationLocationController.text,
                                  pickupLat: pickupPosition?.latitude.toString() ?? '',
                                  pickupLng: pickupPosition?.longitude.toString() ?? '',
                                  dropLat: dropLat ?? '',
                                  dropLng: dropLng ?? '',
                                  itemEntries: itemEntries,
                                );
                              }
                            } else {
                              if (quantityController.text.isEmpty) {
                                showToast(
                                  context: context,
                                  fToast: fToast!,
                                  msg:
                                      '$enterMsg ${AppLocalizations.of(context)!.validString} ${AppLocalizations.of(context)!.quantityString.toLowerCase()}',
                                  duration: 3,
                                );
                              } else if (selectedPackageType == null) {
                                showToast(
                                  context: context,
                                  fToast: fToast!,
                                  msg:
                                      '$enterMsg ${AppLocalizations.of(context)!.validString} ${AppLocalizations.of(context)!.packagingTypeString.toLowerCase()}',
                                  duration: 3,
                                );
                              } else {
                                await customerCubit.createRuralRequest(
                                  vehicleTypeId: selectedVehicleType?.id ?? 3,
                                  packageTypeId: selectedPackageType?.id ?? 1,
                                  receiverName: receiverNameController.text,
                                  receiverContact: contactNumberController.text,
                                  quantiry: quantityController.text,
                                  pickupAddress: currentLocationController.text,
                                  dropAddress: destinationLocationController.text,
                                  pickupLat: pickupPosition?.latitude.toString() ?? '',
                                  pickupLng: pickupPosition?.longitude.toString() ?? '',
                                  dropLat: dropLat ?? '',
                                  dropLng: dropLng ?? '',
                                );
                              }
                            }
                          },
                          textPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          nameSize: 22,
                        ),

                  const SizedBox(
                    height: 15,
                  ),

                  errorMessage != null
                      ? Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                          child: Center(
                            child: Text(
                              errorMessage ?? '',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.red,
                                  ),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),

                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
