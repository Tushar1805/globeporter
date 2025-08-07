import 'package:datasource/states/data_state.dart';

class AmountDeductedState extends SuccessState {
  AmountDeductedState(super.message);
}

class PendingBookingsLoadingState extends LoadingState {
  PendingBookingsLoadingState(super.loadingMessage);
}

class PendingBookingsLoadedState extends LoadedState {
  PendingBookingsLoadedState({required super.data});
}

class DriverBookingsLoadingState extends LoadingState {
  DriverBookingsLoadingState(super.loadingMessage);
}

class DriverBookingsLoadedState extends LoadedState {
  DriverBookingsLoadedState({required super.data});
}

class AcceptOrRejectLoadingState extends LoadingState {
  AcceptOrRejectLoadingState(super.loadingMessage);
}

class AcceptOrRejectLoadedState extends LoadedState {
  AcceptOrRejectLoadedState({required super.data});
}

class ChangeRideStatusLoadingState extends LoadingState {
  ChangeRideStatusLoadingState(super.loadingMessage);
}

class ChangeRideStatusLoadedState extends LoadedState {
  ChangeRideStatusLoadedState({required super.data});
}

class RideCancellationReasonsLoadingState extends LoadingState {
  RideCancellationReasonsLoadingState(super.loadingMessage);
}

class RideCancellationReasonsLoadedState extends LoadedState {
  RideCancellationReasonsLoadedState({required super.data});
}

class CancleRideByDriverLoadingState extends LoadingState {
  CancleRideByDriverLoadingState(super.loadingMessage);
}

class CancleRideByDriverLoadedState extends LoadedState {
  CancleRideByDriverLoadedState({required super.data});
}

class DeclineRideByDriverLoadingState extends LoadingState {
  DeclineRideByDriverLoadingState(super.loadingMessage);
}

class DeclineRideByDriverLoadedState extends LoadedState {
  DeclineRideByDriverLoadedState({required super.data});
}

class CheckCancleRideByDriverLoadingState extends LoadingState {
  CheckCancleRideByDriverLoadingState(super.loadingMessage);
}

class CheckCancleRideByDriverLoadedState extends LoadedState {
  CheckCancleRideByDriverLoadedState({required super.data});
}
