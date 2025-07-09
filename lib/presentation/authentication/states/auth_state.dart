part of '../cubit/auth_cubit.dart';

class AuthLoadingState extends LoadingState {
  AuthLoadingState(super.loadingMessage);
}

class AuthLoadedState extends LoadedState {
  AuthLoadedState({required super.data});
}
