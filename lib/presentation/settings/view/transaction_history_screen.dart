import 'package:core/app_widgets.dart';
import 'package:core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/settings/cubit/wallet_cubit.dart';
import 'package:globeporter/presentation/settings/model/wallet_history_response.dart';
import 'package:globeporter/presentation/settings/states/wallet_states.dart';
import 'package:globeporter/presentation/widgets/transaction_card_widget.dart';
import 'package:globeporter/resources/app_widgets.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen>
    with TickerProviderStateMixin {
  final walletCubit = sl<WalletCubit>();
  WalletHistoryResponse? walletHistory;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  void loadTransactions() async {
    await walletCubit.getWalletHistory();
  }

  @override
  void initState() {
    loadTransactions();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _scaleAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOutCubicEmphasized);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.25),
        child: CustomStatusBarWidget(
          title: locale.transactionHistoryString,
        ),
      ),
      body: BlocConsumer(
        bloc: walletCubit,
        listener: (final context, final state) {
          if (state is WalletHistoryLoadedState) {
            walletHistory = state.data as WalletHistoryResponse?;
            _animationController.forward(from: 0);
          }
        },
        builder: (final context, final state) {
          if (state is WalletHistoryLoadingState) {
            return Center(
              child: LoadingWithoutText(),
            );
          } else {
            return ListView.builder(
              itemCount: walletHistory?.data?.length,
              itemBuilder: (final context, final index) {
                final transaction = walletHistory?.data?[index];
                return ScaleTransition(
                    scale: _scaleAnimation, child: TransactionCard(transaction: transaction));
              },
            );
          }
        },
      ),
    );
  }
}
