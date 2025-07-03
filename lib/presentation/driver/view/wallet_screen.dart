import 'package:core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:globeporter/presentation/driver/cubit/driver_cubit.dart';
import 'package:globeporter/presentation/driver/states/driver_states.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final driverCubit = sl<DriverCubit>();
  String amount = '500';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.35),
        child: CustomStatusBarWidget(
          title: 'Wallet',
          height: size.width * 0.35,
          titlePositionTop: size.width * 0.2,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.width * 0.1,
            ),
            Center(
              child: Image.asset(
                walletImage,
                width: size.width * 0.8,
              ),
            ),
            BlocListener(
              bloc: driverCubit,
              listener: (final context, final state) {
                if (state is AmountDeductedState) {
                  setState(() {
                    amount = state.message;
                  });
                }
              },
              child: CustomText(
                text: 'Balance: $amount rs',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 22),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              'Add an amount to your wallet to continue \n using the services.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 18,
                    color: greyTextColor,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.width * 0.1,
            ),
            CustomElevatedButton(
              name: 'Add Amount',
              borderRadius: 25,
              alignment: Alignment.center,
              onPressed: () {},
              nameSize: 20,
            ),
          ],
        ),
      ),
    );
  }
}
