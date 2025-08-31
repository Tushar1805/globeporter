// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:core/app_widgets.dart';
import 'package:core/di/service_locator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/customer/cubit/customer_cubit.dart';
import 'package:globeporter/presentation/customer/model/booking_details_response.dart';
import 'package:globeporter/presentation/customer/states/customer_states.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_utils.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class MyRequestDetailsScreen extends StatefulWidget {
  const MyRequestDetailsScreen({
    super.key,
    required this.type,
    required this.bookingId,
  });

  final String? type;
  final String? bookingId;

  @override
  State<MyRequestDetailsScreen> createState() => _MyRequestDetailsScreenState();
}

class _MyRequestDetailsScreenState extends State<MyRequestDetailsScreen> {
  final authCubit = sl<AuthCubit>();
  final customerCubit = sl<CustomerCubit>();
  BookingDetailsResponse? bookingDetailsResponse;

  Stream<String?> listenOtp(String bookingId) {
    final dbRef = FirebaseDatabase.instance.ref("ride_otp/$bookingId/otp");

    return dbRef.onValue.map((event) {
      final data = event.snapshot.value;
      if (data != null) {
        return data.toString(); // OTP as String
      }
      return null;
    });
  }

  void loadBookingDetails() async {
    await customerCubit.getBookingDetails(bookingId: widget.bookingId ?? '1');
  }

  @override
  void initState() {
    loadBookingDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locale = AppLocalizations.of(context)!;

    return BlocConsumer(
      bloc: customerCubit,
      listener: (final context, final state) {
        if (state is BookingDetailsLoadedState) {
          bookingDetailsResponse = state.data as BookingDetailsResponse?;
          setState(() {});
        }
      },
      builder: (context, state) {
        if (state is BookingDetailsLoadingState) {
          return Container(
            color: whiteColor,
            alignment: Alignment.center,
            child: LoadingWithoutText(),
          );
        } else {
          final booking = bookingDetailsResponse?.data;
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
                                booking?.driverData?.profilePhotoUrl ?? sampleNetworkImage,
                              ),
                              backgroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Center(
                            child: Text(
                              booking?.driverData?.name ?? '',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          SizedBox(width: size.width * 0.09),
                          bookingDetailsResponse?.data?.status == 1 && booking?.isBookingActive == 1
                              ? Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        makePhoneCall(
                                          fromNumber: booking?.userData?.mobile ?? '',
                                          toNumber: booking?.driverData?.mobile ?? '',
                                          context: context,
                                        );
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
                                          'senderId': booking?.userId.toString(),
                                          'receiverId': booking?.driverId.toString(),
                                          'senderName': authCubit.userDetails?.data?.name,
                                          'type': 'customer',
                                          'receiverName': booking?.driverData?.name,
                                          'receiverImageUrl': booking?.driverData?.profilePhotoUrl,
                                        });
                                      },
                                      child: Icon(
                                        Icons.chat,
                                        color: whiteColor,
                                        size: 24,
                                      ),
                                    )
                                  ],
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 15,
                      top: size.width * 0.1,
                      child: Text(
                        widget.type == 'urban'
                            ? AppLocalizations.of(context)!.urbanString
                            : AppLocalizations.of(context)!.ruralString,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 22, color: whiteColor),
                      ),
                    ),
                  ],
                )),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  CustomText(text: AppLocalizations.of(context)!.pickupLocationString),
                  const SizedBox(height: 8),
                  ShowLocationWidget(address: booking?.pickupAddress),
                  const CustomDivider(),
                  CustomText(text: AppLocalizations.of(context)!.destinationLocationString),
                  const SizedBox(height: 8),
                  ShowLocationWidget(address: booking?.dropAddress),
                  const CustomDivider(),
                  CustomText(text: AppLocalizations.of(context)!.receiverNameString),
                  const SizedBox(height: 8),
                  CustomTextMedium(text: booking?.receiverName ?? ''),
                  const CustomDivider(),
                  CustomText(text: AppLocalizations.of(context)!.contactNoString),
                  const SizedBox(height: 8),
                  CustomTextMedium(text: booking?.receiverContactNo ?? ''),
                  const CustomDivider(),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomRichText(
                      title: '${AppLocalizations.of(context)!.statusString}: ',
                      value: booking?.bookingStatus,
                      titleStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                      valueStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ),
                  const CustomDivider(),
                  const SizedBox(height: 10),
                  StreamBuilder<String?>(
                    stream: listenOtp(widget.bookingId ?? '1'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CustomTextMedium(text: locale.waitingForOtpString);
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return CustomTextMedium(text: locale.otpNotGeneratedYetString);
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomRichText(
                          title: '${locale.otpString.toUpperCase()}: ',
                          value: snapshot.data,
                          titleStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                          valueStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      );
                    },
                  ),
                  if (widget.type == 'urban') UrbanItemsSection(requestData: booking, size: size),
                  if (widget.type == 'rural') RuralDetailsSection(requestData: booking, size: size),
                  const SizedBox(height: 20),
                  booking?.status == 1 && booking?.isBookingActive == 1
                      ? CustomElevatedButton(
                          name:
                              "${AppLocalizations.of(context)!.trackString} ${AppLocalizations.of(context)!.driverString}",
                          borderRadius: 25,
                          alignment: Alignment.bottomCenter,
                          onPressed: () async {
                            context.pushNamed(trackDriverScreen, extra: {
                              'type': booking?.rideType?.toLowerCase(),
                              'data': booking,
                            });
                          },
                        )
                      : SizedBox.shrink(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class UrbanItemsSection extends StatelessWidget {
  const UrbanItemsSection({
    super.key,
    required this.requestData,
    required this.size,
  });

  final Data? requestData;
  final Size size;

  // Cache map to store futures
  static final Map<String, Future<File>> _fileCache = {};

  Future<File> urlToFile(String imageUrl) async {
    final Directory tempDir = await getTemporaryDirectory();
    final String fileName = basename(imageUrl);
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

class RuralDetailsSection extends StatelessWidget {
  const RuralDetailsSection({super.key, required this.requestData, required this.size});

  final Data? requestData;
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

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        color: primaryColor,
      ),
    );
  }
}
