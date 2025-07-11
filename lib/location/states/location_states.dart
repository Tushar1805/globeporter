import 'package:datasource/states/data_state.dart';

class LocationLoadingState extends LoadingState {
  LocationLoadingState(super.loadingMessage);
}

class LocationLoadedState extends LoadedState {
  LocationLoadedState({required super.data});
}

class SearchPickupLocationResultState extends LoadedState {
  SearchPickupLocationResultState({required super.data});
}
class SearchDestinationLocationResultState extends LoadedState {
  SearchDestinationLocationResultState({required super.data});
}
class RouteDirectionsLoadedState extends LoadedState {
  RouteDirectionsLoadedState({required super.data});
}
