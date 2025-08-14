import 'package:datasource/states/data_state.dart';

class CustomerLoadingState extends LoadingState {
  CustomerLoadingState(super.loadingMessage);
}

class CustomerLoadedState extends LoadedState {
  CustomerLoadedState({required super.data});
}

class CustomerGeneralState extends SuccessState{
  CustomerGeneralState(super.message);  
}


class CustomerRequestLoadingState extends LoadingState {
  CustomerRequestLoadingState(super.loadingMessage);
}

class CustomerRequestLoadedState extends LoadedState {
  CustomerRequestLoadedState({required super.data});
}

class PackagingTypeLoadingState extends LoadingState {
  PackagingTypeLoadingState(super.loadingMessage);
}

class PackagingTypeLoadedState extends LoadedState {
  PackagingTypeLoadedState({required super.data});
}

class QuantityLoadingState extends LoadingState {
  QuantityLoadingState(super.loadingMessage);
}

class QuantityLoadedState extends LoadedState {
  QuantityLoadedState({required super.data});
}

class VehicleTypeLoadingState extends LoadingState {
  VehicleTypeLoadingState(super.loadingMessage);
}

class VehicleTypeLoadedState extends LoadedState {
  VehicleTypeLoadedState({required super.data});
}
class CustomerRideBookingsLoadingState extends LoadingState {
  CustomerRideBookingsLoadingState(super.loadingMessage);
}

class CustomerRideBookingsLoadedState extends LoadedState {
  CustomerRideBookingsLoadedState({required super.data});
}


