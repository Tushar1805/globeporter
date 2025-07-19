import 'package:datasource/states/data_state.dart';
import 'package:globeporter/basecubit/base_cubit.dart';
import '../repository/auth_repo.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
part '../states/auth_state.dart';


class AuthCubit extends BaseCubit {
  final AuthRepository _authRepository;
  bool isOtpScreen = false;
  AuthCubit(this._authRepository) : super();

  

Future<UserCredential> signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance.login();

  // Create a credential from the access token
  final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken?.tokenString??'');

  // Once signed in, return the UserCredential
  return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
}
}
