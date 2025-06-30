
import 'package:equatable/equatable.dart';
import 'package:globeporter/basecubit/base_cubit.dart';
import '../repository/auth_repo.dart';
part '../states/auth_state.dart';

class AuthCubit extends BaseCubit {
  final AuthRepository _authRepository;
  bool isOtpScreen = false;
  AuthCubit(this._authRepository) : super();
}
