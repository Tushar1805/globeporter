// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:core/app_widgets.dart';
import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:datasource/states/data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/customer/model/booking_details_response.dart' as booking;
import 'package:globeporter/presentation/customer/view/my_request_details_screen.dart';
import 'package:globeporter/presentation/driver/cubit/driver_cubit.dart';
import 'package:globeporter/presentation/driver/model/ride_cancellation_reason_response.dart';
import 'package:globeporter/presentation/driver/states/driver_booking_states.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_extension_functions.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class ItemDetailsScreen extends StatefulWidget {
  const ItemDetailsScreen({super.key, required this.type, required this.bookingId});
  final String? type;
  final String bookingId;

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final driverCubit = sl<DriverCubit>();
  final authCubit = sl<AuthCubit>();
  bool loading = false;
  final dialogLoadingNotifier = ValueNotifier(false);
  int? currentBookingId;
  int? currentReasonId;
  RideCancellationReasonResponse? rideCancellationReasonsResponse;
  booking.BookingDetailsResponse? bookingDetailsResponse;
  FToast? fToast;

  void loadCancellationReasons() async {
    await driverCubit.getCancellationReasons(userType: '2');
  }

  void loadBookingDetails() async {
    await driverCubit.getBookingDetails(bookingId: widget.bookingId);
  }

  // Future<void> makePhoneCall(String phoneNumber) async {
  //   final Uri launchUri = Uri(
  //     scheme: 'tel',
  //     path: phoneNumber,
  //   );
  //   if (await canLaunchUrl(launchUri)) {
  //     await launchUrl(launchUri);
  //   } else {
  //     showToast(
  //       context: context,
  //       fToast: fToast!,
  //       msg: AppLocalizations.of(context)!.unableToMakePhoneCallString,
  //       duration: 5,
  //     );
  //   }
  // }

  Future<void> makePhoneCall(String phoneNumber) async {
    final status = await Permission.phone.request();

    if (status.isGranted) {
      FlutterPhoneDirectCaller.callNumber(phoneNumber);
    } else {
      showToast(
        context: context,
        fToast: fToast!,
        msg: AppLocalizations.of(context)!.phoneCallPermissionDeniedString,
        duration: 5,
      );
    }
  }

  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);
    loadCancellationReasons();
    loadBookingDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer(
      bloc: driverCubit,
      listener: (final context, final state) {
        if (state is BookingDetailsLoadedState) {
          bookingDetailsResponse = state.data as booking.BookingDetailsResponse?;
          setState(() {});
        }
      },
      builder: (final context, final state) {
        if (state is BookingDetailsLoadingState || state is RideCancellationReasonsLoadingState) {
          return Container(
            alignment: Alignment.center,
            color: whiteColor,
            child: LoadingWithoutText(),
          );
        } else {
          return Scaffold(
            backgroundColor: whiteColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(size.width * 0.35),
              child: Stack(
                children: [
                  Container(
                    height: size.width * 0.35,
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
                    top: size.height * 0.05,
                    left: size.width * 0.05,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: size.width * 0.1,
                          child: CircleAvatar(
                            radius: size.width * 0.097,
                            backgroundImage: NetworkImage(
                              authCubit.userDetails?.data?.profilePhotoUrl ?? sampleNetworkImage,
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ),
                        SizedBox(width: 15),
                        Center(
                          child: Text(
                            authCubit.userDetails?.data?.name ?? '',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: size.width * 0.12,
                    bottom: size.width * 0.1,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            makePhoneCall(bookingDetailsResponse?.data?.receiverContactNo ?? '');
                          },
                          child: Image.asset(
                            phoneCallIcon,
                            width: 24,
                            color: whiteColor,
                          ),
                        ),
                        SizedBox(width: size.width * 0.05),
                        GestureDetector(
                          onTap: () {
                            context.pushNamed(chatScreen, extra: {
                              'senderId': bookingDetailsResponse?.data?.driverId != null
                                  ? bookingDetailsResponse?.data?.driverId.toString()
                                  : authCubit.userDetails?.data?.id.toString(),
                              'receiverId': bookingDetailsResponse?.data?.userId.toString(),
                              'senderName': authCubit.userDetails?.data?.name,
                              'type': 'customer',
                              'receiverName': bookingDetailsResponse?.data?.userData?.name,
                              'receiverImageUrl':
                                  bookingDetailsResponse?.data?.userData?.profilePhotoUrl,
                            });
                          },
                          child: Icon(
                            Icons.chat,
                            color: whiteColor,
                            size: 24,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  CustomText(text: AppLocalizations.of(context)!.pickupLocationString),
                  const SizedBox(
                    height: 4,
                  ),
                  ShowLocationWidget(
                    address: bookingDetailsResponse?.data?.pickupAddress,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomText(text: AppLocalizations.of(context)!.destinationLocationString),
                  const SizedBox(
                    height: 4,
                  ),
                  ShowLocationWidget(
                    address: bookingDetailsResponse?.data?.dropAddress,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  //   child: Divider(
                  //     color: primaryColor,
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  if (widget.type == 'urban')
                    UrbanItemsSection(requestData: bookingDetailsResponse?.data, size: size),
                  if (widget.type == 'rural')
                    RuralDetailsSection(requestData: bookingDetailsResponse?.data, size: size),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: size.width * 0.1,
                  ),
                  BlocListener(
                    bloc: driverCubit,
                    listener: (final context, final state) {
                      if (state is ChangeRideStatusLoadingState) {
                        setState(() {
                          loading = true;
                        });
                      } else if (state is ChangeRideStatusLoadedState) {
                        context.pushReplacementNamed(
                          tripInfoScreen,
                          extra: {
                            'type': widget.type,
                            'bookingId': bookingDetailsResponse?.data?.id.toString(),
                          },
                        );
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                    child: loading
                        ? SizedBox.shrink()
                        : CustomElevatedButton(
                            name: AppLocalizations.of(context)!.goString,
                            borderRadius: 5,
                            alignment: Alignment.center,
                            onPressed: () async {
                              await driverCubit.changeRideStatus(
                                bookingId: bookingDetailsResponse?.data?.id ?? 1,
                                status: RideStatus.onTheWay.value,
                              );

                              await driverCubit.getDriverBookings();
                            },
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocListener(
                    bloc: driverCubit,
                    listener: (final context, final state) async {
                      if (state is CheckCancleRideByDriverLoadingState ||
                          state is CancleRideByDriverLoadingState) {
                        setState(() {
                          dialogLoadingNotifier.value = true;
                        });
                      } else if (state is CheckCancleRideByDriverLoadedState) {
                        final data = state.data;
                        if (data['status'] == false) {
                          //* blocking user here
                          showCustomDialogOneButton(
                            barrierDismissible: false,
                            context: context,
                            borderRadius: 18,
                            title: AppLocalizations.of(context)!.cancelledAccountString,
                            buttonTitle: AppLocalizations.of(context)!.confirmString,
                            onTap: () async {
                              context.pop();
                              await authCubit.logout();
                              context.go(loginScreen, extra: {
                                'status': 0,
                              });
                            },
                          );
                        } else if (data['count'] == 3) {
                          showCustomDialogOneButton(
                            barrierDismissible: false,
                            context: context,
                            borderRadius: 18,
                            title: AppLocalizations.of(context)!.cancellationWarningString,
                            buttonTitle: AppLocalizations.of(context)!.okString,
                            onTap: () async {
                              await driverCubit.declineRideByDriver(
                                bookingId: currentBookingId ?? 1,
                                reasonId: currentReasonId ?? 1,
                              );
                              await driverCubit.getDriverBookings();
                              context.pop();
                            },
                          );
                        } else {
                          await driverCubit.cancelRideByDriver(
                            bookingId: currentBookingId ?? 1,
                            reasonId: currentReasonId ?? 1,
                          );
                          await driverCubit.getDriverBookings();
                          context.pop();
                        }
                        setState(() {
                          dialogLoadingNotifier.value = false;
                        });
                      } else if (state is RideCancellationReasonsLoadedState) {
                        rideCancellationReasonsResponse =
                            state.data as RideCancellationReasonResponse?;
                        setState(() {
                          loading = false;
                        });
                      } else if (state is ErrorState) {
                        setState(() {
                          loading = false;
                        });
                        showToast(
                          context: context,
                          fToast: fToast!,
                          msg: state.errorMessage,
                          duration: 5,
                        );
                      }
                    },
                    child: loading
                        ? SizedBox.shrink()
                        : CustomElevatedButton(
                            name: AppLocalizations.of(context)!.cancelString,
                            borderRadius: 5,
                            alignment: Alignment.center,
                            onPressed: () {
                              showReasonDialog(
                                context: context,
                                reasons: rideCancellationReasonsResponse,
                                loadingNotifier: dialogLoadingNotifier,
                                onTap: (final reasonId) async {
                                  setState(() {
                                    currentReasonId = int.parse(reasonId);
                                    currentBookingId = bookingDetailsResponse?.data?.id ?? 1;
                                  });
                                  customPrint(
                                      "Booking Id: $currentBookingId \n ReasonId: $currentReasonId");
                                  // await driverCubit.rejectRide(
                                  //   bookingId: widget.data?.id ?? 1,
                                  //   status: 'Reject',
                                  // );

                                  await driverCubit.checkCancelRideByDriver(
                                    bookingId: bookingDetailsResponse?.data?.id ?? 1,
                                    reasonId: int.parse(reasonId),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                  loading ? LoadingWithoutText() : SizedBox.shrink(),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

// class UrbanDetailsSection extends StatelessWidget {
//   const UrbanDetailsSection({super.key, required this.requestData, required this.size});
//   final pending.Data? requestData;
//   final Size size;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CustomText(
//           text: AppLocalizations.of(context)!.itemDetailsString,
//           fontSize: 16,
//         ),
//         const SizedBox(height: 8),
//         SizedBox(
//           height: size.width * 0.55,
//           child: ListView.separated(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             scrollDirection: Axis.horizontal,
//             itemCount: requestData?.bookingRideItem?.length ?? 0,
//             separatorBuilder: (_, __) => const SizedBox(width: 12),
//             itemBuilder: (context, index) {
//               final item = requestData!.bookingRideItem![index];
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: size.width * 0.4,
//                     height: size.width * 0.5,
//                     decoration: BoxDecoration(
//                       color: secondaryColor,
//                       borderRadius: BorderRadius.circular(10),
//                       image: item.itemImageUrl != null
//                           ? DecorationImage(
//                               image: NetworkImage(item.itemImageUrl!),
//                               fit: BoxFit.cover,
//                             )
//                           : null,
//                     ),
//                     child: item.itemImageUrl == null
//                         ? Center(
//                             child: Icon(Icons.image, size: 40, color: Colors.grey),
//                           )
//                         : null,
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: List.generate(
//               requestData?.bookingRideItem?.length ?? 0,
//               (index) {
//                 final item = requestData!.bookingRideItem![index];
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CustomText(
//                           text: "${AppLocalizations.of(context)!.descriptionString} ${index + 1}"),
//                       const SizedBox(height: 4),
//                       CustomTextMedium(
//                         text: item.description ?? 'No description provided.',
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class UrbanItemsSection extends StatelessWidget {
  const UrbanItemsSection({
    super.key,
    required this.requestData,
    required this.size,
  });

  final booking.Data? requestData;
  final Size size;

  // Cache map to store futures
  static final Map<String, Future<File>> _fileCache = {};

  Future<File> urlToFile(String imageUrl) async {
    final Directory tempDir = await path_provider.getTemporaryDirectory();
    final String fileName = path.basename(imageUrl);
    final File file = File('${tempDir.path}/$fileName');

    if (!await file.exists()) {
      final http.Response response = await http.get(Uri.parse(imageUrl));
      await file.writeAsBytes(response.bodyBytes);
    }

    return file;
  }

  @override
  Widget build(BuildContext context) {
    final items = requestData?.bookingRideItem ?? [];

    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: List.generate(
        items.length,
        (index) {
          final bookingItem = items[index];
          final imageUrl = bookingItem.itemImageUrl;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: '${AppLocalizations.of(context)!.itemDetailsString}: ${index + 1}',
                ),
                const SizedBox(height: 10),
                imageUrl?.isNotEmpty == true
                    ? FutureBuilder<File>(
                        future: _fileCache.putIfAbsent(imageUrl!, () => urlToFile(imageUrl)),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError || !snapshot.hasData) {
                            return const Icon(Icons.broken_image);
                          }

                          final File file = snapshot.data!;

                          return GestureDetector(
                            onTap: () {
                              context.pushNamed(
                                fullImagePreviewScreen,
                                extra: {'imageFile': file},
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  file,
                                  height: size.width * 0.6,
                                  width: double.infinity,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const Icon(Icons.image_not_supported),
                const SizedBox(height: 20),
                CustomText(text: AppLocalizations.of(context)!.descriptionString),
                const SizedBox(height: 8),
                CustomTextMedium(text: bookingItem.description ?? '-'),
                const CustomDivider(),
              ],
            ),
          );
        },
      ),
    );
  }
}

// class RuralDetailsSection extends StatelessWidget {
//   const RuralDetailsSection({super.key, required this.requestData, required this.size});

//   final pending.Data? requestData;
//   final Size size;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CustomText(text: AppLocalizations.of(context)!.productTypeString),
//         const SizedBox(height: 4),
//         // CustomTextMedium(text: requestData?.packageTypeData?.nameEn ?? ''),
//         const SizedBox(height: 8),
//         CustomText(text: AppLocalizations.of(context)!.packagingTypeString),
//         const SizedBox(height: 4),
//         // CustomTextMedium(text: requestData?.packageTypeData?.nameEn ?? ''),
//         const SizedBox(height: 8),
//         CustomText(text: AppLocalizations.of(context)!.quantityString),
//         const SizedBox(height: 4),
//         CustomTextMedium(text: requestData?.qty ?? ''),
//         const SizedBox(height: 8),
//       ],
//     );
//   }
// }

class RuralDetailsSection extends StatelessWidget {
  const RuralDetailsSection({super.key, required this.requestData, required this.size});

  final booking.Data? requestData;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final items = requestData?.bookingRideUserPackage ?? [];

    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        items.length,
        (index) {
          final packageItem = items[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomDivider(),
                CustomText(
                  text: '${AppLocalizations.of(context)!.itemDetailsString}: ${index + 1}',
                ),
                const SizedBox(height: 20),
                CustomText(text: AppLocalizations.of(context)!.packagingTypeString),
                const SizedBox(height: 8),
                CustomTextMedium(text: packageItem.packageTypeData?.name ?? ''),
                const SizedBox(height: 10),
                CustomText(text: AppLocalizations.of(context)!.quantityString),
                const SizedBox(height: 8),
                CustomTextMedium(text: packageItem.qtyData?.qty ?? '-'),
              ],
            ),
          );
        },
      ),
    );
  }
}
