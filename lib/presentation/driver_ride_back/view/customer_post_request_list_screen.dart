// ignore_for_file: use_build_context_synchronously

import 'package:core/app_widgets.dart';
import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/location/background_location_service.dart';
import 'package:globeporter/location/cubit/location_cubit.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/driver/model/ride_cancellation_reason_response.dart';
import 'package:globeporter/presentation/driver/widgets/address_row_widget.dart';
import 'package:globeporter/presentation/driver_ride_back/cubit/driver_ride_back_cubit.dart';
import 'package:globeporter/presentation/driver_ride_back/model/customer_posted_ride_list_model.dart';
import 'package:globeporter/presentation/driver_ride_back/states/driver_ride_back_state.dart';
import 'package:globeporter/presentation/notification/cubit/notification_cubit.dart';
import 'package:globeporter/presentation/notification/states/notification_states.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_keys.dart';
import 'package:globeporter/resources/app_storage.dart';
import 'package:globeporter/resources/app_utils.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class PostRequestCustomerScreen extends StatefulWidget {
  const PostRequestCustomerScreen({super.key});

  @override
  State<PostRequestCustomerScreen> createState() =>
      _PostRequestCustomerScreenState();
}

class _PostRequestCustomerScreenState extends State<PostRequestCustomerScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final notificationCubit = sl<NotificationCubit>();
  final driverRideBackCubit = sl<DriverRideBackCubit>();
  final locationCubit = sl<LocationCubit>();
  final authCubit = sl<AuthCubit>();
  int notificationUnreadCount = 0;
  late AnimationController _notificationAnimationController;
  late Animation<double> _notificationScaleAnimation;
  CustomerPostedRidesListModel? customerPostedRidesListModel;
  RideCancellationReasonResponse? rideCancellationReason;
  final dialogLoadingNotifier = ValueNotifier(false);
  FToast? fToast;
  final storage = sl<SecureStorage>();
  Map<String, dynamic> appliedFilters = {};
  Map<String, dynamic>? selectedLocation;
  RangeValues priceRange = const RangeValues(0, 2000);
  double distance = 10;
  String orderBy = 'asc';
  String selectedAddress = 'Select Drop Location';

  void loadData() async {
    await driverRideBackCubit.getCustomerPostedRides(
      radius: '10',
      currentLat: locationCubit.position?.latitude.toString() ?? '',
      currentLng: locationCubit.position?.longitude.toString() ?? '',
    );
    await notificationCubit.getNotificatinsUnreadCount();
    await driverRideBackCubit.getCancellationReasons(userType: '1');
  }

  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);
    loadData();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _scaleAnimation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutCubicEmphasized);

    _notificationAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _notificationScaleAnimation = CurvedAnimation(
        parent: _notificationAnimationController, curve: Curves.easeOutBack);
    super.initState();
  }

  Future<void> startCustomerTracking({
    required String customerId,
  }) async {
    await initializeBackgroundService();
    final service = FlutterBackgroundService();
    final lang = await storage.safeRead(languageCodeKey);
    final token = await storage.safeRead(accessTokenKey);

    // Send config data to background isolate
    service.invoke('updateConfig', {
      'userId': customerId,
      'role': 'customer', // ✅ differentiate in DB
      'type': 'customer',
      'active': true,
      'token': token,
      'lang': lang,
    });

    // Start as foreground
    service.startService();
  }

  void _applyFilters() {
    driverRideBackCubit.getCustomerPostedRides(
      radius: distance.toString(),
      currentLat: locationCubit.position?.latitude.toString() ?? '',
      currentLng: locationCubit.position?.longitude.toString() ?? '',
      dropLat:
          selectedLocation != null ? selectedLocation!['lat'].toString() : '',
      dropLng:
          selectedLocation != null ? selectedLocation!['lng'].toString() : '',
      price: appliedFilters['Price'] != null ? priceRange.end.toString() : '',
      orderByColumn: appliedFilters['Price'] != null ? 'price' : '',
      orderByType: appliedFilters['Order By'] ?? 'asc',
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.35),
        child: Stack(
          children: [
            Container(
              height: size.width * 0.25,
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
              top: size.height * 0.055,
              right: 15,
              child: Center(
                child: SvgPicture.asset(
                  appLogoSmall,
                  width: MediaQuery.sizeOf(context).width * .25,
                ),
              ),
            ),
            Positioned(
              top: size.width * 0.1,
              left: size.width * 0.043,
              child: Text(
                locale.postedRidesString,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: whiteColor,
                      fontSize: 24,
                    ),
              ),
            ),
            BlocListener(
              bloc: notificationCubit,
              listener: (final context, final state) {
                if (state is NotificationUnreadCountLoadedState) {
                  setState(() {
                    notificationUnreadCount = state.data['noti_unread_count'];
                  });
                  _notificationAnimationController.forward(from: 0);
                }
              },
              child: Positioned(
                top: size.width * 0.1,
                right: size.width * 0.32,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      context.pushNamed(notificationScreen);
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Icon(
                            Icons.notifications_active_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: ScaleTransition(
                            scale: _notificationScaleAnimation,
                            child: UnreadBadge(
                              count: notificationUnreadCount,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: BlocConsumer(
        bloc: driverRideBackCubit,
        listener: (final context, final state) {
          if (state is RideCancellationReasonsLoadedState) {
            rideCancellationReason =
                state.data as RideCancellationReasonResponse?;
          } else if (state is CustomerPostedRidesLoadedState) {
            customerPostedRidesListModel =
                state.data as CustomerPostedRidesListModel?;
            _animationController.forward(from: 0);
          } else if (state is CustomerAcceptRejectLoadedState) {
            final data = state.data;
            showToast(
              context: context,
              fToast: fToast!,
              msg: data['message'],
              duration: 5,
            );
            if (data['status_code'] == 200) {
              driverRideBackCubit.getCustomerPostedRides(
                radius: '10',
                currentLat: locationCubit.position?.latitude.toString() ?? '',
                currentLng: locationCubit.position?.longitude.toString() ?? '',
              );
            }
          } else if (state is CustomerCancelRideLoadedState) {
            context.pop();
            driverRideBackCubit.getCustomerPostedRides(
              radius: '10',
              currentLat: locationCubit.position?.latitude.toString() ?? '',
              currentLng: locationCubit.position?.longitude.toString() ?? '',
            );
          }
        },
        builder: (final context, final state) {
          if (state is CustomerPostedRidesLoadingState) {
            return Center(
              child: LoadingWithoutText(),
            );
          }
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filters',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.tune_outlined,
                          color: Colors.black87),
                      onPressed: () => _showFilterBottomSheet(context),
                    ),
                  ],
                ),
              ),

              // 🔹 Active filters row (if any)
              if (appliedFilters.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: appliedFilters.entries.map((entry) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: primaryColor),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${entry.key}: ${entry.value}',
                                style: const TextStyle(fontSize: 13),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () {
                                  setState(
                                      () => appliedFilters.remove(entry.key));
                                  _applyFilters();
                                },
                                child: const Icon(Icons.close, size: 16),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              if (appliedFilters.isNotEmpty)
                const SizedBox(
                  height: 10,
                ),
              (customerPostedRidesListModel?.data?.length ?? 0) == 0
                  ? Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.hourglass_empty_outlined,
                              color: primaryColor,
                              size: 40,
                            ),
                            Text(
                              locale.noPostedRides,
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount:
                            customerPostedRidesListModel?.data?.length ?? 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        itemBuilder: (final context, final index) {
                          final ride =
                              customerPostedRidesListModel?.data?[index];
                          final driverData = ride?.driverData;
                          return ScaleTransition(
                            scale: _scaleAnimation,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(9),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .pickupLocationString,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    AddressRowWidget(
                                        address: ride?.pickupAddress),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .destinationLocationString,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    AddressRowWidget(
                                        address: ride?.dropAddress),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .priceString,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        Text(
                                          ": ₹${ride?.price?.toString()}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                        ),
                                      ],
                                    ),
                                    ride?.isCustomerAcceptRide == 0
                                        ? SizedBox.shrink()
                                        : Card(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            color: Colors.grey.shade100,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 24,
                                                    backgroundColor:
                                                        primaryColor,
                                                    backgroundImage: driverData
                                                                    ?.profilePhotoUrl !=
                                                                null &&
                                                            (driverData
                                                                    ?.profilePhotoUrl
                                                                    ?.isNotEmpty ??
                                                                false)
                                                        ? NetworkImage(driverData
                                                                ?.profilePhotoUrl ??
                                                            '')
                                                        : null,
                                                    child: (driverData
                                                                    ?.profilePhotoUrl ==
                                                                null ||
                                                            (driverData
                                                                    ?.profilePhotoUrl
                                                                    ?.isEmpty ??
                                                                false))
                                                        ? const Icon(
                                                            Icons.person,
                                                            color: Colors.white)
                                                        : null,
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          driverData?.name ??
                                                              'Jon Doe',
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15),
                                                        ),
                                                        Text(
                                                          driverData?.email ??
                                                              '',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.call,
                                                        color: primaryColor),
                                                    onPressed: () {
                                                      makePhoneCall(
                                                        // Customer number
                                                        fromNumber: authCubit
                                                                .userDetails
                                                                ?.data
                                                                ?.mobile ??
                                                            '',
                                                        // Driver Number
                                                        toNumber: driverData
                                                                ?.mobile ??
                                                            '',
                                                        context: context,
                                                      );
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.message,
                                                        color: primaryColor),
                                                    onPressed: () {
                                                      context.pushNamed(
                                                          chatScreen,
                                                          extra: {
                                                            // customer
                                                            'senderId': ride
                                                                        ?.driverId !=
                                                                    null
                                                                ? ride?.driverId
                                                                    .toString()
                                                                : authCubit
                                                                    .userDetails
                                                                    ?.data
                                                                    ?.id
                                                                    .toString(),
                                                            // driver
                                                            'receiverId':
                                                                driverData?.id
                                                                    .toString(),
                                                            'senderName':
                                                                authCubit
                                                                    .userDetails
                                                                    ?.data
                                                                    ?.name,
                                                            'type': 'customer',
                                                            'receiverName':
                                                                driverData
                                                                    ?.name,
                                                            'receiverImageUrl':
                                                                driverData
                                                                    ?.profilePhotoUrl,
                                                          });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    ride?.isCustomerAcceptRide == 1
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomElevatedButton(
                                                name: AppLocalizations.of(
                                                        context)!
                                                    .cancelString,
                                                borderRadius: 5,
                                                alignment: Alignment.centerLeft,
                                                backgroundColor: Colors.red,
                                                onPressed: () {
                                                  showReasonDialog(
                                                    context: context,
                                                    reasons:
                                                        rideCancellationReason,
                                                    loadingNotifier:
                                                        dialogLoadingNotifier,
                                                    onTap:
                                                        (final reasonId) async {
                                                      await driverRideBackCubit
                                                          .customerCancelRide(
                                                        bookingId: ride?.id
                                                                .toString() ??
                                                            '1',
                                                        bookingCancellationId:
                                                            reasonId,
                                                      );
                                                    },
                                                  );
                                                },
                                                textPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.06,
                                              ),
                                              ride?.isBookingActive == 0
                                                  ? SizedBox.shrink()
                                                  : CustomElevatedButton(
                                                      name: AppLocalizations.of(
                                                              context)!
                                                          .trackString,
                                                      borderRadius: 5,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      onPressed: () async {
                                                        await startCustomerTracking(
                                                          customerId: authCubit
                                                                  .userDetails
                                                                  ?.data
                                                                  ?.id
                                                                  ?.toString() ??
                                                              '1',
                                                        ).then((_) {
                                                          context.pushNamed(
                                                              customerSideTrackScreen,
                                                              extra: {
                                                                'data': ride,
                                                              });
                                                        });
                                                      },
                                                      textPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 10,
                                                              vertical: 4),
                                                    )
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomElevatedButton(
                                                name: AppLocalizations.of(
                                                        context)!
                                                    .acceptString,
                                                borderRadius: 5,
                                                alignment: Alignment.centerLeft,
                                                onPressed: () {
                                                  showCustomDialog(
                                                    context: context,
                                                    borderRadius: 18,
                                                    title: locale
                                                        .areYouSureYouWantToAcceptRideString,
                                                    onTapYes: () async {
                                                      driverRideBackCubit
                                                          .customerAcceptRejectRide(
                                                        bookingId: ride?.id
                                                                .toString() ??
                                                            '1',
                                                        status: 'Accept',
                                                      );
                                                      context.pop();
                                                    },
                                                    onTapNo: () {
                                                      context.pop();
                                                    },
                                                  );
                                                },
                                                textPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.06,
                                              ),
                                              CustomElevatedButton(
                                                name: AppLocalizations.of(
                                                        context)!
                                                    .declineString,
                                                borderRadius: 5,
                                                alignment: Alignment.centerLeft,
                                                backgroundColor: Colors.red,
                                                onPressed: () {
                                                  showCustomDialog(
                                                    context: context,
                                                    borderRadius: 18,
                                                    title: locale
                                                        .areYouSureYouWantToRejectRideString,
                                                    onTapYes: () async {
                                                      driverRideBackCubit
                                                          .customerAcceptRejectRide(
                                                        bookingId: ride?.id
                                                                .toString() ??
                                                            '1',
                                                        status: 'Reject',
                                                      );
                                                      context.pop();
                                                    },
                                                    onTapNo: () {
                                                      context.pop();
                                                    },
                                                  );
                                                },
                                                textPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4),
                                              )
                                            ],
                                          )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Center(
                      child: Text(
                        'Filter Options',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Location
                    ListTile(
                      leading: const Icon(Icons.location_on_outlined),
                      title: Text(selectedAddress),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        final data =
                            await context.pushNamed(locationPickerScreen)
                                as Map<String, dynamic>?;

                        if (data != null && data['loc'] != null) {
                          // ✅ Update inside the bottom sheet (temporary UI)
                          setModalState(() {
                            selectedLocation = data;
                            selectedAddress = data['loc'].toString();
                            appliedFilters['Location'] = selectedAddress;
                          });

                          // ✅ Also update in the main screen’s state (persistent)
                          if (mounted) {
                            setState(() {
                              selectedLocation = data;
                              selectedAddress = data['loc'].toString();
                              appliedFilters['Location'] = selectedAddress;
                            });
                          }
                        }
                      },
                    ),
                    const Divider(),

                    // Price range
                    const Text('Price Range'),
                    RangeSlider(
                      min: 0,
                      max: 2000,
                      divisions: 19,
                      values: priceRange,
                      labels: RangeLabels(
                        '₹${priceRange.start.round()}',
                        '₹${priceRange.end.round()}',
                      ),
                      onChanged: (value) {
                        setModalState(() => priceRange = value);
                      },
                    ),

                    // Distance
                    const SizedBox(height: 8),
                    const Text('Distance (km)'),
                    Slider(
                      min: 1,
                      max: 50,
                      divisions: 49,
                      value: distance,
                      label: '${distance.round()} km',
                      onChanged: (val) {
                        setModalState(() => distance = val);
                      },
                    ),

                    // Order By
                    const SizedBox(height: 8),
                    const Text('Order By'),
                    Row(
                      children: [
                        ChoiceChip(
                          selectedColor: primaryColor.withAlpha(200),
                          label: const Text('Ascending'),
                          selected: orderBy == 'asc',
                          onSelected: (_) =>
                              setModalState(() => orderBy = 'asc'),
                        ),
                        const SizedBox(width: 10),
                        ChoiceChip(
                          selectedColor: primaryColor.withAlpha(200),
                          label: const Text('Descending'),
                          selected: orderBy == 'desc',
                          onSelected: (_) =>
                              setModalState(() => orderBy = 'desc'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    CustomElevatedButton(
                      name: 'Apply Filters',
                      borderRadius: 12,
                      alignment: Alignment.center,
                      onPressed: () {
                        context.pop();
                        setState(() {
                          appliedFilters['Price'] =
                              '₹${priceRange.start.round()} - ₹${priceRange.end.round()}';
                          // appliedFilters['Price'] = priceRange.end.round().toString();
                          appliedFilters['Distance'] = '${distance.round()} km';
                          appliedFilters['Order By'] = orderBy;
                        });
                        customPrint(appliedFilters['Price']);
                        _applyFilters();
                      },
                      nameSize: 20,
                      textPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
