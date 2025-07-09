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
