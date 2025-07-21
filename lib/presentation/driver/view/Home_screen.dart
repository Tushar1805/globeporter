import 'package:core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/driver/cubit/driver_cubit.dart';
import 'package:globeporter/presentation/driver/states/driver_states.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  String amount = '500';
  final myTrips = [
    {
      'name': 'Vinod Sharma',
      'date': '25 June',
      'pickupLocation': 'Flat No. 203, Sai Residency, Indore',
      'destinationLocation': 'Flat No. 203, Sai Residency, Indore',
      'type': 'urban',
    },
    {
      'name': 'Vinod Sharma',
      'date': '25 June',
      'pickupLocation': 'Flat No. 203, Sai Residency, Indore',
      'destinationLocation': 'Flat No. 203, Sai Residency, Indore',
      'type': 'rural',
    },
    {
      'name': 'Vinod Sharma',
      'date': '25 June',
      'pickupLocation': 'Flat No. 203, Sai Residency, Indore',
      'destinationLocation': 'Flat No. 203, Sai Residency, Indore',
      'type': 'urban',
    },
    {
      'name': 'Vinod Sharma',
      'date': '25 June',
      'pickupLocation': 'Flat No. 203, Sai Residency, Indore',
      'destinationLocation': 'Flat No. 203, Sai Residency, Indore',
      'type': 'urban',
    }
  ];
  final driverCubit = sl<DriverCubit>();
  final authCubit = sl<AuthCubit>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
              top: size.width * 0.15,
              right: size.width * 0.32,
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
              top: size.height * 0.05,
              left: size.width * 0.05,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(driverProfileScreen);
                    },
                    child: CircleAvatar(
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
                  ),
                  SizedBox(width: 15),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.onboarding1Title,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.end,
                        ),
                        SizedBox(
                          width: size.width * 0.35,
                          child: Text(
                            authCubit.userDetails?.data?.name ?? 'User Name',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 15,
              bottom: size.width * 0.08,
              child: GestureDetector(
                onTap: () => context.pushNamed(walletScreen),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  alignment: Alignment.bottomRight,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        coinImage,
                        width: size.width * 0.047,
                        height: size.width * 0.047,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      BlocConsumer(
                        bloc: driverCubit,
                        listener: (final context, final state) {
                          if (state is AmountDeductedState) {
                            setState(() {
                              amount = state.message;
                            });
                          }
                        },
                        builder: (final context, final state) {
                          return Text(
                            '$amount ${AppLocalizations.of(context)!.rsString}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontSize: 20, color: primaryColor),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: myTrips.length,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemBuilder: (final context, final index) {
                final trip = myTrips[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(9),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                trip['name'] ?? '',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontSize: 20,
                                    ),
                              ),
                            ),
                            Text(
                              trip['date'] ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontSize: 15, color: greyTextColor),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          AppLocalizations.of(context)!.pickupLocationString,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        addressRow(address: trip['pickupLocation']),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          AppLocalizations.of(context)!.destinationLocationString,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        addressRow(address: trip['pickupLocation']),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomElevatedButton(
                              name: AppLocalizations.of(context)!.acceptString,
                              borderRadius: 5,
                              alignment: Alignment.centerLeft,
                              onPressed: () {
                                showCustomDialog(
                                  context: context,
                                  borderRadius: 18,
                                  title:
                                      '₹100 ${AppLocalizations.of(context)!.deductionMessageString}',
                                  onTapYes: () {
                                    driverCubit.deductAmount();
                                    context.pop();
                                    context.pushNamed(
                                      itemDetailsScreen,
                                      extra: {'type': trip['type']},
                                    );
                                  },
                                  onTapNo: () {
                                    context.pop();
                                  },
                                );
                              },
                              textPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            ),
                            SizedBox(
                              width: size.width * 0.06,
                            ),
                            CustomElevatedButton(
                              name: AppLocalizations.of(context)!.declineString,
                              borderRadius: 5,
                              alignment: Alignment.centerLeft,
                              backgroundColor: Colors.red,
                              onPressed: () {
                                showReasonDialog(
                                  context: context,
                                  onTap: context.pop,
                                );
                              },
                              textPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget addressRow({required final String? address}) => Row(
        children: [
          Image.asset(
            locationPinImage,
            width: 24,
            height: 32,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              address ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
            ),
          )
        ],
      );
}
