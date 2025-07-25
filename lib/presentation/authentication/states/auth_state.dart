part of '../cubit/auth_cubit.dart';

class AuthLoadingState extends LoadingState {
  AuthLoadingState(super.loadingMessage);
}

class AuthLoadedState extends LoadedState {
  AuthLoadedState({required super.data});
}

class UserDetailsLoadingState extends LoadingState {
  UserDetailsLoadingState(super.loadingMessage);
}

class UserDetailsLoadedState extends LoadedState {
  UserDetailsLoadedState({required super.data});
}

class LoginLoadingState extends LoadingState {
  LoginLoadingState(super.loadingMessage);
}

class LoginLoadedState extends LoadedState {
  LoginLoadedState({required super.data});
}

class GoogleLoginLoadingState extends LoadingState {
  GoogleLoginLoadingState(super.loadingMessage);
}

class GoogleLoginLoadedState extends LoadedState {
  GoogleLoginLoadedState({required super.data});
}


class RegisterLoadingState extends LoadingState {
  RegisterLoadingState(super.loadingMessage);
}

class RegisterLoadedState extends LoadedState {
  RegisterLoadedState({required super.data});
}

class OtpVerifyLoadingState extends LoadingState {
  OtpVerifyLoadingState(super.loadingMessage);
}

class OtpVerifyLoadedState extends LoadedState {
  OtpVerifyLoadedState({required super.data});
}

class UserTypeLoadingState extends LoadingState {
  UserTypeLoadingState(super.loadingMessage);
}

class UserTypeLoadedState extends LoadedState {
  UserTypeLoadedState({required super.data});
}



