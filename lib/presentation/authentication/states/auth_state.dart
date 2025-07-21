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

class VehicleTypeLoadingState extends LoadingState {
  VehicleTypeLoadingState(super.loadingMessage);
}

class VehicleTypeLoadedState extends LoadedState {
  VehicleTypeLoadedState({required super.data});
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
