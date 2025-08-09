import 'package:datasource/states/data_state.dart';

class ChatNotificationLoadingState extends LoadingState {
  ChatNotificationLoadingState(super.loadingMessage);
}

class ChatNotificationLoadedState extends LoadedState {
  ChatNotificationLoadedState({required super.data});
}
