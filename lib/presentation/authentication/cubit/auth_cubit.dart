import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:datasource/states/data_state.dart';
import 'package:globeporter/basecubit/base_cubit.dart';
import 'package:globeporter/presentation/authentication/model/user_details_response_model.dart';
import 'package:globeporter/resources/app_keys.dart';
import 'package:globeporter/resources/app_storage.dart';
import '../repository/auth_repo.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
part '../states/auth_state.dart';

class AuthCubit extends BaseCubit {
  final AuthRepository _authRepository;
  bool isOtpScreen = false;
  AuthCubit(this._authRepository) : super();

  final storage = sl<SecureStorage>();

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken?.tokenString ?? '');

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<UserDetailsResponseModel?> getUserDetails({required final String lang}) async {
    try {
      emit(UserDetailsLoadingState('Getting User details'));
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _authRepository.getUserDetails(
        accessToken: accessToken ?? '',
        lang: lang,
      );
      emit(UserDetailsLoadedState(data: response));
      return response;
    } catch (e) {
      handleExceptions(e);
      return null;
    }
  }

  Future<void> login({
    required final String langCode,
    required final String dialCode,
    required final String phoneNumber,
  }) async {
    try {
      emit(LoginLoadingState('Login in process'));

      final response = await _authRepository.login(
        lang: langCode,
        dialCode: dialCode,
        phoneNumber: phoneNumber,
      );

      emit(LoginLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> register({
    required final int userId,
    required final String langCode,
    required final String name,
    required final String email,
  }) async {
    try {
      emit(RegisterLoadingState('Registration in progress'));
      final fcmToken = '_test';

      final response = await _authRepository.register(
        userId: userId,
        lang: langCode,
        name: name,
        email: email,
        fcmToken: fcmToken,
      );

      emit(RegisterLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> verifyOtp({
    required final String otp,
    required final int userId,
  }) async {
    try {
      emit(OtpVerifyLoadingState('OTP verification in progress'));
      final lang = await storage.readValue(languageCodeKey);
      final response = await _authRepository.verifyOtp(
        userId: userId,
        lang: lang ?? 'en',
        otp: otp,
      );

      await storage.saveValue(value: response?.token, key: accessTokenKey);
      customPrint("Token: ${response?.token}");
      emit(OtpVerifyLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> updateUserType({required final String userType}) async {
    try {
      emit(UserTypeLoadingState('Updating user type'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);

      final response = await _authRepository.updateUserType(
        userType: userType,
        lang: lang ?? 'en',
        accessToken: accessToken ?? '',
      );

      emit(UserTypeLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> logout() async {
    try {
      await storage.clearAll();
    } catch (e) {
      handleExceptions(e);
    }
  }
}
