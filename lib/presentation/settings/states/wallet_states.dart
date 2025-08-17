import 'package:datasource/states/data_state.dart';

class CreateOrderLoadingState extends LoadingState {
  CreateOrderLoadingState(super.loadingMessage);
}

class CreateOrderLoadedState extends LoadedState {
  CreateOrderLoadedState({required super.data});
}

class AddMoneyToWalletLoadingState extends LoadingState {
  AddMoneyToWalletLoadingState(super.loadingMessage);
}

class AddMoneyToWalletLoadedState extends LoadedState {
  AddMoneyToWalletLoadedState({required super.data});
}

class WalletDataLoadingState extends LoadingState {
  WalletDataLoadingState(super.loadingMessage);
}

class WalletDataLoadedState extends LoadedState {
  WalletDataLoadedState({required super.data});
}
class WalletHistoryLoadingState extends LoadingState {
  WalletHistoryLoadingState(super.loadingMessage);
}

class WalletHistoryLoadedState extends LoadedState {
  WalletHistoryLoadedState({required super.data});
}
