import 'package:datasource/states/data_state.dart';

class AmountDeductedState extends SuccessState {
  AmountDeductedState(super.message);
}

class DetailsUpdatedState extends SuccessState {
  DetailsUpdatedState(super.message);
}

class OwnerDetailsLoadingState extends LoadingState {
  OwnerDetailsLoadingState(super.loadingMessage);
}

class OwnerDetailsLoadedState extends LoadedState {
  OwnerDetailsLoadedState({required super.data});
}

class DriverDetailsLoadingState extends LoadingState {
  DriverDetailsLoadingState(super.loadingMessage);
}

class DriverDetailsLoadedState extends LoadedState {
  DriverDetailsLoadedState({required super.data});
}

class VehicleDetailsLoadingState extends LoadingState {
  VehicleDetailsLoadingState(super.loadingMessage);
}

class AllDetailsLoadedState extends LoadedState {
  AllDetailsLoadedState({required super.data});
}

class AllDetailsLoadingState extends LoadingState {
  AllDetailsLoadingState(super.loadingMessage);
}

class VehicleDetailsLoadedState extends LoadedState {
  VehicleDetailsLoadedState({required super.data});
}

class VehicleTypeLoadingState extends LoadingState {
  VehicleTypeLoadingState(super.loadingMessage);
}

class VehicleTypeLoadedState extends LoadedState {
  VehicleTypeLoadedState({required super.data});
}
