import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../repository/auth_repo.dart';
part '../states/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {

  final AuthRepository _authRepository;
  bool isOtpScreen = false;
  AuthCubit(this._authRepository) : super(AuthInitial());
}
