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
