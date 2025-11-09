import 'package:datasource/states/data_state.dart';

class VehicleTypesLoadingState extends LoadingState {
  VehicleTypesLoadingState(super.loadingMessage);
}

class VehicleTypesLoadedState extends LoadedState {
  VehicleTypesLoadedState({required super.data});
}

class PlaceDriverRideLoadingState extends LoadingState {
  PlaceDriverRideLoadingState(super.loadingMessage);
}

class PlaceDriverRideLoadedState extends LoadedState {
  PlaceDriverRideLoadedState({required super.data});
}

class MyPostedRidesLoadingState extends LoadingState {
  MyPostedRidesLoadingState(super.loadingMessage);
}

class MyPostedRidesLoadedState extends LoadedState {
  MyPostedRidesLoadedState({required super.data});
}

class FindingCustomerLoadingState extends LoadingState {
  FindingCustomerLoadingState(super.loadingMessage);
}

class FindingCustomerLoadedState extends LoadedState {
  FindingCustomerLoadedState({required super.data});
}

class CustomerPostedRidesLoadingState extends LoadingState {
  CustomerPostedRidesLoadingState(super.loadingMessage);
}

class CustomerPostedRidesLoadedState extends LoadedState {
  CustomerPostedRidesLoadedState({required super.data});
}

class CustomerAcceptRejectLoadingState extends LoadingState {
  CustomerAcceptRejectLoadingState(super.loadingMessage);
}

class CustomerAcceptRejectLoadedState extends LoadedState {
  CustomerAcceptRejectLoadedState({required super.data});
}

class CustomerCancelRideLoadingState extends LoadingState {
  CustomerCancelRideLoadingState(super.loadingMessage);
}

class CustomerCancelRideLoadedState extends LoadedState {
  CustomerCancelRideLoadedState({required super.data});
}

class DriverCancelRideLoadingState extends LoadingState {
  DriverCancelRideLoadingState(super.loadingMessage);
}

class DriverCancelRideLoadedState extends LoadedState {
  DriverCancelRideLoadedState({required super.data});
}

class DriverAcceptRejectLoadingState extends LoadingState {
  DriverAcceptRejectLoadingState(super.loadingMessage);
}

class DriverAcceptRejectLoadedState extends LoadedState {
  DriverAcceptRejectLoadedState({required super.data});
}

class RideCancellationReasonsLoadingState extends LoadingState {
  RideCancellationReasonsLoadingState(super.loadingMessage);
}

class RideCancellationReasonsLoadedState extends LoadedState {
  RideCancellationReasonsLoadedState({required super.data});
}

class GenerateOTPLoadingState extends LoadingState {
  GenerateOTPLoadingState(super.loadingMessage);
}

class GenerateOTPLoadedState extends LoadedState {
  GenerateOTPLoadedState({required super.data});
}

class VerifyStartRideOTPLoadingState extends LoadingState {
  VerifyStartRideOTPLoadingState(super.loadingMessage);
}

class VerifyStartRideOTPLoadedState extends LoadedState {
  VerifyStartRideOTPLoadedState({required super.data});
}

class VerifyEndRideOTPLoadingState extends LoadingState {
  VerifyEndRideOTPLoadingState(super.loadingMessage);
}

class VerifyEndRideOTPLoadedState extends LoadedState {
  VerifyEndRideOTPLoadedState({required super.data});
}

class RideOTPNotMatchState extends LoadingState {
  RideOTPNotMatchState(super.loadingMessage);
}

class EndRideLoadingState extends LoadingState {
  EndRideLoadingState(super.loadingMessage);
}

class EndRideLoadedState extends LoadedState {
  EndRideLoadedState({required super.data});
}
