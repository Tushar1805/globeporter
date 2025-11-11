import 'dart:io';

import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:datasource/states/data_state.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:globeporter/basecubit/base_cubit.dart';
import 'package:globeporter/notifications/notification_service.dart';
import 'package:globeporter/presentation/authentication/model/user_details_response_model.dart';
import 'package:globeporter/resources/app_keys.dart';
import 'package:globeporter/resources/app_storage.dart';
import '../repository/auth_repo.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
part '../states/auth_state.dart';

class AuthCubit extends BaseCubit {
  final AuthRepository _authRepository;
  bool isOtpScreen = false;
  AuthCubit(this._authRepository) : super();
  final storage = sl<SecureStorage>();
  UserDetailsResponseModel? userDetails;
  final notificationService = NotificationServices();

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken?.tokenString ?? '');

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<UserDetailsResponseModel?> getUserDetails({final bool force = false}) async {
    if (!force) {
      if (userDetails != null) return userDetails;
    }
    try {
      emit(UserDetailsLoadingState('Getting User details'));
      final accessToken = await storage.safeRead(accessTokenKey);
      final lang = await storage.safeRead(languageCodeKey);
      final response = await _authRepository.getUserDetails(
        accessToken: accessToken ?? '',
        lang: lang ?? 'en',
      );
      userDetails = response;
      emit(UserDetailsLoadedState(data: response));
      return response;
    } catch (e) {
      handleExceptions(e);
      return null;
    }
  }

  Future<File> urlToFile(String imageUrl) async {
    final Directory tempDir = await getTemporaryDirectory();

    final String fileName = basename(imageUrl);
    final File file = File('${tempDir.path}/$fileName');

    final http.Response response = await http.get(Uri.parse(imageUrl));

    await file.writeAsBytes(response.bodyBytes);

    return file;
  }

  Future<void> login({
    required final String dialCode,
    required final String phoneNumber,
  }) async {
    try {
      emit(LoginLoadingState('Login in process'));

      final lang = await storage.safeRead(languageCodeKey);

      final response = await _authRepository.login(
        lang: lang ?? 'en',
        dialCode: dialCode,
        phoneNumber: phoneNumber,
      );

      emit(LoginLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> resendOtp({
    required final String dialCode,
    required final String phoneNumber,
  }) async {
    try {
      emit(ResendOtpLoadingState('Resending OTP'));

      final lang = await storage.safeRead(languageCodeKey);

      final response = await _authRepository.login(
        lang: lang ?? 'en',
        dialCode: dialCode,
        phoneNumber: phoneNumber,
      );

      emit(ResendOtpLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> googleLogin({
    required final String googleId,
    required final String name,
    required final String email,
  }) async {
    try {
      emit(GoogleLoginLoadingState('Login in process'));
      final lang = await storage.safeRead(languageCodeKey);
      var fcmToken = await storage.safeRead(fcmTokenKey);
      if (fcmToken == null || fcmToken == '') {
        final token = await notificationService.getDeviceToken() ?? '_test';

        await storage.saveValue(value: token, key: fcmTokenKey);
        fcmToken = token;
      }

      final response = await _authRepository.googleLogin(
        lang: lang ?? 'en',
        googleId: googleId,
        name: name,
        email: email,
        fcmToken: fcmToken,
      );

      await storage.saveValue(value: response?.token, key: accessTokenKey);
      customPrint("Token: ${response?.token}");

      emit(GoogleLoginLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> register({
    required final int userId,
    required final String name,
    required final String email,
    final String? mobile,
  }) async {
    try {
      emit(RegisterLoadingState('Registration in progress'));

      final lang = await storage.safeRead(languageCodeKey);
      var fcmToken = await storage.safeRead(fcmTokenKey);
      if (fcmToken == null || fcmToken == '') {
        final token = await notificationService.getDeviceToken() ?? '_test';

        await storage.saveValue(value: token, key: fcmTokenKey);
        fcmToken = token;
      }

      final response = await _authRepository.register(
        userId: userId,
        lang: lang ?? 'en',
        name: name,
        email: email,
        fcmToken: fcmToken,
        mobile: mobile,
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
      final lang = await storage.safeRead(languageCodeKey);
      final response = await _authRepository.verifyOtp(
        userId: userId,
        lang: lang ?? 'en',
        otp: otp,
      );

      if (response?.statusCode == 200) {
        final authToken = response?.token;
        await storage.saveValue(value: authToken, key: accessTokenKey);

        final token = await notificationService.getDeviceToken() ?? '';
        await _authRepository.updateFcmToken(
          lang: lang ?? 'en',
          accessToken: authToken ?? '',
          fcmToken: token,
        );
        await storage.saveValue(value: token, key: fcmTokenKey);
        customPrint('FcM Token: $token');
        customPrint("Token: ${response?.token}");
        emit(OtpVerifyLoadedState(data: response));
      } else if (response?.statusCode == 410) {
        emit(ErrorState(response?.message ?? 'Something went wrong'));
      }
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> updateUserType({required final String userType}) async {
    try {
      emit(UserTypeLoadingState('Updating user type'));
      final lang = await storage.safeRead(languageCodeKey);
      final accessToken = await storage.safeRead(accessTokenKey);

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

  Future<String?> makePhoneCall({
    required final String fromNumber,
    required final String toNumber,
  }) async {
    try {
      emit(StartCallLoadingState('Updating user type'));
      final lang = await storage.safeRead(languageCodeKey);
      final accessToken = await storage.safeRead(accessTokenKey);

      final response = await _authRepository.makePhoneCall(
        lang: lang ?? 'en',
        accessToken: accessToken ?? '',
        fromNumber: fromNumber,
        toNumber: toNumber,
      );

      emit(StartCallLoadedState(data: response));
      customPrint("Mobile: ${response['result']['data']['mobile']}");
      return response['result']['data']['mobile'];
    } catch (e) {
      handleExceptions(e);
      return null;
    }
  }

  Future<void> logout() async {
    try {
      final accessToken = await storage.safeRead(accessTokenKey);
      final lang = await storage.safeRead(languageCodeKey);

      await storage.clearAll();
      await storage.saveValue(value: '0', key: ownerDetailsFilledKey);
      await storage.saveValue(value: '0', key: vehicleDetailsFilledKey);
      await storage.saveValue(value: '0', key: driverDetailsFilledKey);
      userDetails = null;

      await FirebaseMessaging.instance.deleteToken();

      _authRepository.logout(accessToken: accessToken ?? '', lang: lang ?? 'en');
      emit(GeneralState('logout'));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> updateMobileNumber({
    required final String dialCode,
    required final String phoneNumber,
  }) async {
    try {
      emit(UpdateMobileLoadingState('Update in process'));

      final lang = await storage.safeRead(languageCodeKey);
      final accessToken = await storage.safeRead(accessTokenKey);

      final response = await _authRepository.updateMobileNumber(
        lang: lang ?? 'en',
        dialCode: dialCode,
        phoneNumber: phoneNumber,
        accessToken: accessToken ?? '',
      );

      emit(UpdateMobileLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> updateVerifyOtp({
    required final String otp,
    required final String mobile,
    required final String dialCode,
  }) async {
    try {
      emit(UpdateMobileVerifyLoadingState('OTP verification in progress'));
      final lang = await storage.safeRead(languageCodeKey);
      final accessToken = await storage.safeRead(accessTokenKey);
      final response = await _authRepository.updateVerifyOtp(
        lang: lang ?? 'en',
        otp: otp,
        mobile: mobile,
        dialCode: dialCode,
        accessToken: accessToken ?? '',
      );

      customPrint("Verify update otp response: ${response.toString()}");

      if (response['status_code'] == 200) {
        final authToken = response['token'];
        await storage.saveValue(value: authToken, key: accessTokenKey);

        emit(UpdateMobileVerifyLoadedState(data: response));
      }
    } catch (e) {
      handleExceptions(e);
    }
  }
}
