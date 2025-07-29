import 'package:datasource/states/data_state.dart';

class AmountDeductedState extends SuccessState {
  AmountDeductedState(super.message);
}

class DetailsUpdatedState extends SuccessState {
  DetailsUpdatedState(super.message);
}

class LoadAllDataLoadingState extends LoadingState {
  LoadAllDataLoadingState(super.loadingMessage);
}

class LoadAllDataLoadedState extends LoadedState {
  LoadAllDataLoadedState({required super.data});
}

class SaveOwnerDetailsLoadingState extends LoadingState {
  SaveOwnerDetailsLoadingState(super.loadingMessage);
}

class SaveOwnerDetailsLoadedState extends LoadedState {
  SaveOwnerDetailsLoadedState({required super.data});
}

class SaveDriverDetailsLoadingState extends LoadingState {
  SaveDriverDetailsLoadingState(super.loadingMessage);
}

class SaveDriverDetailsLoadedState extends LoadedState {
  SaveDriverDetailsLoadedState({required super.data});
}

class SaveVehicleDetailsLoadingState extends LoadingState {
  SaveVehicleDetailsLoadingState(super.loadingMessage);
}

class SaveVehicleDetailsLoadedState extends LoadedState {
  SaveVehicleDetailsLoadedState({required super.data});
}

class AllDetailsLoadedState extends LoadedState {
  AllDetailsLoadedState({required super.data});
}

class AllDetailsLoadingState extends LoadingState {
  AllDetailsLoadingState(super.loadingMessage);
}

class VehicleTypeLoadingState extends LoadingState {
  VehicleTypeLoadingState(super.loadingMessage);
}

class VehicleTypeLoadedState extends LoadedState {
  VehicleTypeLoadedState({required super.data});
}

class GetOwnerDetailsLoadingState extends LoadingState {
  GetOwnerDetailsLoadingState(super.loadingMessage);
}

class GetOwnerDetailsLoadedState extends LoadedState {
  GetOwnerDetailsLoadedState({required super.data});
}

class GetDriverDetailsLoadingState extends LoadingState {
  GetDriverDetailsLoadingState(super.loadingMessage);
}

class GetDriverDetailsLoadedState extends LoadedState {
  GetDriverDetailsLoadedState({required super.data});
}

class GetVehicleDetailsLoadingState extends LoadingState {
  GetVehicleDetailsLoadingState(super.loadingMessage);
}

class GetVehicleDetailsLoadedState extends LoadedState {
  GetVehicleDetailsLoadedState({required super.data});
}

class VerificationStatusLoadingState extends LoadingState {
  VerificationStatusLoadingState(super.loadingMessage);
}

class VerificationStatusLoadedState extends LoadedState {
  VerificationStatusLoadedState({required super.data});
}


class ReSubmitDocumentsLoadingState extends LoadingState {
  ReSubmitDocumentsLoadingState(super.loadingMessage);
}

class ReSubmitDocumentsLoadedState extends LoadedState {
  ReSubmitDocumentsLoadedState({required super.data});
}

class AllDocumentsLoadingState extends LoadingState {
  AllDocumentsLoadingState(super.loadingMessage);
}

class AllDocumentsLoadedState extends LoadedState {
  AllDocumentsLoadedState({required super.data});
}
