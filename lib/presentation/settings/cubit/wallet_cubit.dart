import 'package:core/di/service_locator.dart';
import 'package:globeporter/basecubit/base_cubit.dart';
import 'package:globeporter/presentation/settings/repository/wallet_repository.dart';
import 'package:globeporter/presentation/settings/states/wallet_states.dart';
import 'package:globeporter/resources/app_keys.dart';
import 'package:globeporter/resources/app_storage.dart';

class WalletCubit extends BaseCubit {
  final WalletRepository _walletRepository;
  WalletCubit(this._walletRepository);
  final storage = sl<SecureStorage>();

  Future<void> createOrder({
    required final int amount,
  }) async {
    try {
      emit(CreateOrderLoadingState('Creating order'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);

      final response = await _walletRepository.createOrder(
        lang: lang ?? 'en',
        accessToken: accessToken ?? '',
        amount: amount,
      );

      emit(CreateOrderLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> addMoneyToWallet({
    required final String transactionId,
    required final String paymentMode,
    required final String transactionDate,
    required final String transactionTime,
    required final String amount, //& in rupee
    required final String paymentStatus,
  }) async {
    try {
      emit(AddMoneyToWalletLoadingState('Adding money...'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);

      final response = await _walletRepository.addMoneyToWallet(
        lang: lang ?? 'en',
        accessToken: accessToken ?? '',
        amount: amount,
        transactionId: transactionId,
        paymentMode: paymentMode,
        transactionDate: transactionDate,
        transactionTime: transactionTime,
        paymentStatus: paymentStatus,
      );

      emit(AddMoneyToWalletLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> getWalletData() async {
    try {
      emit(WalletDataLoadingState('Loading wallet data'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);

      final response = await _walletRepository.getWalletData(
        lang: lang ?? 'en',
        accessToken: accessToken ?? '',
      );

      emit(WalletDataLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> getWalletHistory() async {
    try {
      emit(WalletHistoryLoadingState('Loading wallet history'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);

      final response = await _walletRepository.getWalletHistory(
        lang: lang ?? 'en',
        accessToken: accessToken ?? '',
      );

      emit(WalletHistoryLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }
}
