import 'package:datasource/states/data_state.dart';

class NotificationsLoadingState extends LoadingState {
  NotificationsLoadingState(super.loadingMessage);
}

class NotificationsLoadedState extends LoadedState {
  NotificationsLoadedState({required super.data});
}

class MarkNotificationsReadLoadingState extends LoadingState {
  MarkNotificationsReadLoadingState(super.loadingMessage);
}

class MarkNotificationsReadLoadedState extends LoadedState {
  MarkNotificationsReadLoadedState({required super.data});
}

