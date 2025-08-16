import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/driver/cubit/driver_cubit.dart';
import 'package:globeporter/resources/app_api_keys.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final driverCubit = sl<DriverCubit>();
  final authCubit = sl<AuthCubit>();
  String amount = '500';
  late Razorpay _razorpay;
  final amountTextController = TextEditingController();

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: 'Payment Successfull ${response.paymentId}');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    Fluttertoast.showToast(msg: 'Payment Failed ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    Fluttertoast.showToast(msg: 'External Wallet ${response.walletName}');
  }

  void openCheckout({
    required final int amount,
    required final String contact,
    required final String email,
    required final String name,
    required final String description,
  }) async {
    var options = {
      'key': razorpayKey,
      'amount': amount,
      'currency': 'INR',
      'name': 'Globeporter',
      // 'order_id': 'order_EMBFqjDHEEn80l', // Generate order_id using Orders API
      'description': description,
      'timeout': 600, // in seconds
      'prefill': {'contact': contact, 'email': email},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      customPrint("Error: Payment failed: $e");
    }
  }

  @override
  void initState() {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.35),
        child: CustomStatusBarWidget(
          title: AppLocalizations.of(context)!.walletString,
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
            CustomText(
              text:
                  '${AppLocalizations.of(context)!.balanceString}: ${driverCubit.amount.toString()} ${AppLocalizations.of(context)!.rsString}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 22),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              AppLocalizations.of(context)!.addAmountDescString,
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
              name: AppLocalizations.of(context)!.addAmountString,
              borderRadius: 25,
              alignment: Alignment.center,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: primaryColor),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.enterAmountString,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 24,
                                    color: whiteColor,
                                  ),
                            ),
                            const SizedBox(height: 20),

                            // OTP TextField

                            TextField(
                              controller: amountTextController,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.black, letterSpacing: 2),
                              decoration: InputDecoration(
                                counterText: '',
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.6),
                                hintText: AppLocalizations.of(context)!.enterAmountString,
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Colors.white, width: 2),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Submit button
                            CustomElevatedButton(
                              name: AppLocalizations.of(context)!.submitString,
                              borderRadius: 28,
                              alignment: Alignment.center,
                              onPressed: () {
                                final amount = amountTextController.text.trim();
                                if (amount.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "${AppLocalizations.of(context)!.pleaseEnterString} ${AppLocalizations.of(context)!.validString.toLowerCase()}  ${AppLocalizations.of(context)!.amountString.toLowerCase()}");
                                  return;
                                } else {
                                  context.pop(); // Close dialog
                                  openCheckout(
                                    amount: int.parse(amount) * 100, // Amount in paise
                                    contact: authCubit.userDetails?.data?.mobile ?? '',
                                    email: authCubit.userDetails?.data?.email ?? 'test@gmail.com',
                                    name: authCubit.userDetails?.data?.name ?? 'user name',
                                    description: "Testing payments",
                                  );
                                }
                              },
                              backgroundColor: whiteColor,
                              nameColor: primaryColor,
                              nameSize: 24,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              nameSize: 20,
            ),
          ],
        ),
      ),
    );
  }
}
