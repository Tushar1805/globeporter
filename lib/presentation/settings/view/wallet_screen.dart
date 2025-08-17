import 'package:core/app_widgets.dart';
import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:datasource/states/data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/settings/cubit/wallet_cubit.dart';
import 'package:globeporter/presentation/settings/model/create_order_response.dart';
import 'package:globeporter/presentation/settings/model/wallet_data_response.dart';
import 'package:globeporter/presentation/settings/states/wallet_states.dart';
import 'package:globeporter/resources/app_api_keys.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final authCubit = sl<AuthCubit>();
  final walletCubit = sl<WalletCubit>();
  bool dialogLoading = false;

  WalletDataResponse? walletData;
  late Razorpay _razorpay;
  final amountTextController = TextEditingController();

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await walletCubit.addMoneyToWallet(
      transactionId: response.paymentId ?? '',
      paymentMode: 'razorpay',
      transactionDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      transactionTime: DateFormat('HH:mm:ss').format(DateTime.now()),
      amount: amountTextController.text,
      paymentStatus: 'Paid',
    );
    await walletCubit.getWalletData();

    customPrint(
        "Payment Success: ${response.data.toString()} \n Payment Id: ${response.paymentId}");
    Fluttertoast.showToast(msg: 'Payment Successfull');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails

    walletCubit.addMoneyToWallet(
      transactionId: response.code.toString(),
      paymentMode: 'razorpay',
      transactionDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      transactionTime: DateFormat('HH:mm:ss').format(DateTime.now()),
      amount: amountTextController.text,
      paymentStatus: 'Failed',
    );

    Fluttertoast.showToast(msg: 'Payment Failed ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    Fluttertoast.showToast(msg: 'External Wallet ${response.walletName}');
  }

  void openCheckout({
    required final int amount,
    required final String orderId,
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
      'order_id': orderId, // Generate order_id using Orders API
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

  void loadWalletData() async {
    await walletCubit.getWalletData();
  }

  @override
  void initState() {
    loadWalletData();
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
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.3),
        child: Stack(
          children: [
            Container(
              height: size.width * 0.3,
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
              top: size.height * 0.055,
              left: size.width * 0.043,
              child: Text(
                locale.walletString,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: whiteColor,
                      fontSize: 24,
                    ),
              ),
            ),
            Positioned(
              bottom: size.width * 0.07,
              right: size.width * 0.07,
              child: GestureDetector(
                onTap: () {
                  context.pushNamed(transactionHistoryScreen);
                },
                child: Center(
                    child: Icon(
                  Icons.receipt_long_outlined,
                  color: whiteColor,
                  size: 30,
                )),
              ),
            ),
          ],
        ),
      ),
      body: BlocConsumer(
        bloc: walletCubit,
        listener: (final context, final state) {
          if (state is WalletDataLoadedState) {
            walletData = state.data as WalletDataResponse?;
          } else if (state is CreateOrderLoadingState) {
            setState(() {
              dialogLoading = true;
            });
          } else if (state is CreateOrderLoadedState) {
            final data = state.data as CreateOrderResponse?;
            if (data?.statusCode == 200) {
              openCheckout(
                amount: data?.data?.amount ?? 100, // Amount in paise
                orderId: data?.data?.orderId ?? 'order_EMBFqjDHEEn80l',
                contact: authCubit.userDetails?.data?.mobile ?? '',
                email: authCubit.userDetails?.data?.email ?? 'test@gmail.com',
                name: authCubit.userDetails?.data?.name ?? 'user name',
                description: "Testing payments",
              );
            }
            setState(() {
              dialogLoading = false;
            });
          } else if (state is ErrorState) {
            Fluttertoast.showToast(msg: state.errorMessage);
            setState(() {
              dialogLoading = false;
            });
          }
        },
        builder: (final context, final state) {
          if (state is WalletDataLoadingState) {
            return Center(
              child: LoadingWithoutText(),
            );
          } else {
            return SingleChildScrollView(
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
                        '${locale.balanceString}: ${walletData?.data?.balance.toString()} ${locale.rsString}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 22),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    locale.addAmountDescString,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 18,
                          color: greyTextColor,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: size.width * 0.1,
                  ),
                  dialogLoading
                      ? LoadingWithoutText()
                      : CustomElevatedButton(
                          name: locale.addAmountString,
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
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          locale.enterAmountString,
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
                                            hintText: locale.enterAmountString,
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
                                              borderSide:
                                                  const BorderSide(color: Colors.white, width: 2),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 20),

                                        // Submit button
                                        CustomElevatedButton(
                                          name: locale.submitString,
                                          borderRadius: 28,
                                          alignment: Alignment.center,
                                          onPressed: () async {
                                            final amount = amountTextController.text.trim();
                                            if (amount.isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "${locale.pleaseEnterString} ${locale.validString.toLowerCase()}  ${locale.amountString.toLowerCase()}");
                                              return;
                                            } else {
                                              context.pop();
                                              await walletCubit.createOrder(
                                                  amount: int.parse(amount));
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
            );
          }
        },
      ),
    );
  }
}
