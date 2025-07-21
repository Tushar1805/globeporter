import 'dart:io';

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
  UserDetailsResponseModel? userDetails;

  // Owner Fields
  String? ownerName;
  String? ownerPhoneNumber;
  File? ownerFrontAdhaar;
  File? ownerBackAdhaar;
  File? ownerFrontPan;
  File? ownerBackPan;
  File? ownerPhoto;
  bool ownerDetailsFilled = false;

  // Vehicle Fields
  String? vehicleNo;
  String? vehicleRC;
  String? vehicleTypeId;
  File? vehicleFrontRC;
  File? vehicleBackRC;
  File? vehiclePhoto;
  bool vehicleDetailsFilled = false;

  // Driver Fields
  String? driverName;
  String? driverPhoneNumber;
  String? driverLicenceNumber;
  File? driverFrontAdhaar;
  File? driverBackAdhaar;
  File? driverFrontPan;
  File? driverBackPan;
  File? driverFrontLicence;
  File? driverBackLicence;
  File? driverPhoto;
  bool driverDetailsFilled = false;

  void saveOwnerDetails({
    required final String ownerName,
    required final String ownerPhoneNumber,
    required final File ownerFrontAdhaar,
    required final File ownerBackAdhaar,
    required final File ownerFrontPan,
    required final File ownerBackPan,
    required final File ownerPhoto,
  }) {
    this.ownerName = ownerName;
    this.ownerPhoneNumber = ownerPhoneNumber;
    this.ownerFrontAdhaar = ownerFrontAdhaar;
    this.ownerBackAdhaar = ownerBackAdhaar;
    this.ownerFrontPan = ownerFrontPan;
    this.ownerBackPan = ownerBackPan;
    this.ownerPhoto = ownerPhoto;

    ownerDetailsFilled = true;

    emit(OwnerDetailsLoadedState(data: null));
  }

  void saveVehicleDetails({
    required final String vehicleNo,
    required final String vehicleRC,
    required final String vehicleTypeId,
    required final File vehicleFrontRC,
    required final File vehicleBackRC,
    required final File vehiclePhoto,
  }) {
    this.vehicleNo = vehicleNo;
    this.vehicleRC = vehicleRC;
    this.vehicleTypeId = vehicleTypeId;
    this.vehicleFrontRC = vehicleFrontRC;
    this.vehicleBackRC = vehicleBackRC;
    this.vehiclePhoto = vehiclePhoto;

    vehicleDetailsFilled = true;

    emit(VehicleDetailsLoadedState(data: null));
  }

  void saveDriverDetails({
    required final String driverName,
    required final String driverPhoneNumber,
    required final String driverLicenceNumber,
    required final File driverFrontAdhaar,
    required final File driverBackAdhaar,
    required final File driverFrontPan,
    required final File driverBackPan,
    required final File driverFrontLicence,
    required final File driverBackLicence,
    required final File driverPhoto,
  }) {
    this.driverName = driverName;
    this.driverPhoneNumber = driverPhoneNumber;
    this.driverLicenceNumber = driverLicenceNumber;
    this.driverFrontAdhaar = driverFrontAdhaar;
    this.driverBackAdhaar = driverBackAdhaar;
    this.driverFrontPan = driverFrontPan;
    this.driverBackPan = driverBackPan;
    this.driverFrontLicence = driverFrontLicence;
    this.driverBackLicence = driverBackLicence;
    this.driverPhoto = driverPhoto;

    driverDetailsFilled = true;

    emit(DriverDetailsLoadedState(data: null));
  }

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
    if (userDetails != null) return userDetails;
    try {
      emit(UserDetailsLoadingState('Getting User details'));
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _authRepository.getUserDetails(
        accessToken: accessToken ?? '',
        lang: lang,
      );
      userDetails = response;
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

  Future<void> googleLogin({
    required final String googleId,
    required final String name,
    required final String email,
  }) async {
    try {
      emit(GoogleLoginLoadingState('Login in process'));
      final lang = await storage.readValue(languageCodeKey);
      final fcmToken = '_test';

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

  Future<void> getVehicleType() async {
    try {
      emit(VehicleTypeLoadingState('Loading vehicle types'));
      final lang = await storage.readValue(languageCodeKey);
      final response = await _authRepository.getVehicleType(lang: lang ?? 'en');

      emit(VehicleTypeLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> submitOwnerDriverVehiclDetails() async {
    try {
      emit(AllDetailsLoadingState('Submitting details'));
      final accessToken = await storage.readValue(accessTokenKey);
      final lang = await storage.readValue(languageCodeKey);

      final response = await _authRepository.submitOwnerVehiclDriverDetails(
        lang: lang ?? 'en',
        accessToken: accessToken ?? '',
        ownerName: ownerName,
        ownerPhoneNumber: ownerPhoneNumber,
        ownerFrontAdhaar: ownerFrontAdhaar,
        ownerBackAdhaar: ownerBackAdhaar,
        ownerFrontPan: ownerFrontPan,
        ownerBackPan: ownerBackPan,
        ownerPhoto: ownerPhoto,
        vehicleNo: vehicleNo,
        vehicleRC: vehicleRC,
        vehicleTypeId: vehicleTypeId,
        vehicleFrontRC: vehicleFrontRC,
        vehicleBackRC: vehicleBackRC,
        vehiclePhoto: vehiclePhoto,
        driverName: driverName,
        driverPhoneNumber: driverPhoneNumber,
        driverLicenceNumber: driverLicenceNumber,
        driverFrontAdhaar: driverFrontAdhaar,
        driverBackAdhaar: driverBackAdhaar,
        driverFrontPan: driverFrontPan,
        driverBackPan: driverBackPan,
        driverFrontLicence: driverFrontLicence,
        driverBackLicence: driverBackLicence,
        driverPhoto: driverPhoto,
      );

      if (response?['status_code'] == 200) {
        emit(AllDetailsLoadedState(data: response));
      } else {
        emit(ErrorState('Details not submitted'));
      }
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> logout() async {
    try {
      await storage.clearAll();
      userDetails = null;
      emit(GeneralState('logout'));
    } catch (e) {
      handleExceptions(e);
    }
  }
}
