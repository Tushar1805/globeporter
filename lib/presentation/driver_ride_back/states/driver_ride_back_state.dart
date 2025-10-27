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
