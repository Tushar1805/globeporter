import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repo.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  bool isOtpScreen = false;
  AuthCubit(this._authRepository) : super(AuthInitial());
}
