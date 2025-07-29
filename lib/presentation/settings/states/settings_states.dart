import 'package:datasource/states/data_state.dart';

class UpdateProfileLoadingState extends LoadingState {
  UpdateProfileLoadingState(super.loadingMessage);
}

class UpdateProfileLoadedState extends LoadedState {
  UpdateProfileLoadedState({required super.data});
}
