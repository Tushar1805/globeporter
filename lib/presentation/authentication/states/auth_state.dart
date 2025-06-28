part of '../cubit/auth_cubit.dart';


abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthCodeSent extends AuthState {
  final String verificationId;
  AuthCodeSent(this.verificationId);
}

class AuthLoggedIn extends AuthState {
  AuthLoggedIn();
}

class AuthRegistered extends AuthState {
  AuthRegistered();
}

class AuthLoggedOut extends AuthState {}

class AuthUserNotFound extends AuthState {
  final String phone;
  AuthUserNotFound(this.phone);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
