import 'dart:io';

import 'package:datasource/base_repository.dart';
import 'package:datasource/network/api_call_type.dart';
import 'package:globeporter/presentation/authentication/model/login_response_model.dart';
import 'package:globeporter/presentation/authentication/model/otp_response_model.dart';
import 'package:globeporter/presentation/authentication/model/register_response_model.dart';
import 'package:globeporter/presentation/authentication/model/user_details_response_model.dart';
import 'package:globeporter/presentation/authentication/model/user_type_response_model.dart';
import 'package:globeporter/presentation/authentication/model/vehicle_type_response_model.dart';
import 'package:globeporter/resources/app_api.dart';

class AuthRepository extends BaseRepository {
  Future<UserDetailsResponseModel?> getUserDetails({
    required final String accessToken,
    required final String lang,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      accessToken: accessToken,
      apiUrl: getUserUrl,
      requestModel: {
        'lang': lang,
      },
    );

    return UserDetailsResponseModel.fromJson(
      responseData as Map<String, dynamic>?,
    );
  }

  Future<LoginResponseModel?> login({
    required final String lang,
    required final String dialCode,
    required final String phoneNumber,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: loginUrl,
      requestModel: {
        'lang': lang,
        'dial_code': dialCode,
        'mobile': phoneNumber,
      },
    );

    return LoginResponseModel.fromJson(
      responseData as Map<String, dynamic>?,
    );
  }

  Future<RegisterResponseModel?> register({
    required final int userId,
    required final String lang,
    required final String name,
    required final String email,
    required final String fcmToken,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: registerUrl,
      requestModel: {
        'user_id': userId,
        'lang': lang,
        'name': name,
        'email': email,
        'fcm_token': fcmToken,
      },
    );

    return RegisterResponseModel.fromJson(
      responseData as Map<String, dynamic>?,
    );
  }

  Future<OtpResponseModel?> verifyOtp({
    required final int userId,
    required final String lang,
    required final String otp,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: otpVerificationUrl,
      requestModel: {
        'user_id': userId,
        'lang': lang,
        'otp': otp,
      },
    );

    return OtpResponseModel.fromJson(
      responseData as Map<String, dynamic>?,
    );
  }

  Future<UserTypeResponseModel?> updateUserType({
    required final String userType,
    required final String lang,
    required final String accessToken,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: updateUserTypeUrl,
      accessToken: accessToken,
      requestModel: {
        'user_type': userType,
        'lang': lang,
      },
    );

    return UserTypeResponseModel.fromJson(
      responseData as Map<String, dynamic>?,
    );
  }

  Future<VehicleTypeResponseModel?> getVehicleType({
    required final String lang,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: getVehicleTypeUrl,
      requestModel: {
        'lang': lang,
      },
    );

    return VehicleTypeResponseModel.fromJson(
      responseData as Map<String, dynamic>?,
    );
  }

  Future<Map<String, dynamic>?> submitOwnerVehiclDriverDetails({
    required final String lang,
    required final String accessToken,
    required final String? ownerName,
    required final String? ownerPhoneNumber,
    required final File? ownerFrontAdhaar,
    required final File? ownerBackAdhaar,
    required final File? ownerFrontPan,
    required final File? ownerBackPan,
    required final File? ownerPhoto,
    required final String? vehicleNo,
    required final String? vehicleRC,
    required final String? vehicleTypeId,
    required final File? vehicleFrontRC,
    required final File? vehicleBackRC,
    required final File? vehiclePhoto,
    required final String? driverName,
    required final String? driverPhoneNumber,
    required final String? driverLicenceNumber,
    required final File? driverFrontAdhaar,
    required final File? driverBackAdhaar,
    required final File? driverFrontPan,
    required final File? driverBackPan,
    required final File? driverFrontLicence,
    required final File? driverBackLicence,
    required final File? driverPhoto,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.postWithFile,
      apiUrl: submitOwnerVehicleDriverDetailsUrl,
      accessToken: accessToken,
      requestModel: {
        'lang': lang,
        'owner_name': ownerName,
        'owner_dial_code': '91',
        'owner_mobile': ownerPhoneNumber,
        'driver_name': driverName,
        'driver_dial_code': '91',
        'driver_mobile': driverPhoneNumber,
        'driver_license_number': driverLicenceNumber,
        'vehicle_type_id': vehicleTypeId,
        'vehicle_no': vehicleNo,
        'vehicle_registration': vehicleRC,
      },
      filesWithFieldNames: {
        // 'owner_aadhar_front': ownerFrontAdhaar,
        'aadhar_card': ownerFrontAdhaar,
        // 'owner_aadhar_back': ownerFrontAdhaar,
        'aadhar_card_back': ownerBackAdhaar,
        // 'owner_pan_front': ownerFrontPan,
        'pan_card': ownerFrontPan,
        // 'owner_pan_back': ownerBackAdhaar,
        'pan_card_back': ownerBackAdhaar,
        // 'owner_photo': ownerPhoto,
        'profile_photo': ownerPhoto,
        // 'vehicle_rc_front': vehicleFrontRC,
        'vehicle_rc': vehicleFrontRC,
        'vehicle_rc_back': vehicleBackRC,
        'vehicle_photo': vehiclePhoto,
        // 'driver_aadhar_front': driverFrontAdhaar,
        'driver_aadhar_card': driverFrontAdhaar,
        // 'driver_aadhar_back': driverBackAdhaar,
        'driver_aadhar_card_back': driverBackAdhaar,
        // 'driver_pan_front': driverFrontPan,
        'driver_pan_card': driverFrontPan,
        // 'driver_pan_back': driverBackAdhaar,
        'driver_pan_card_back': driverBackAdhaar,
        'driver_photo': driverPhoto,
      },
    );

    return responseData;
  }

  Future<UserTypeResponseModel?> logout({
    required final String accessToken,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: logoutUrl,
      accessToken: accessToken,
    );

    return UserTypeResponseModel.fromJson(
      responseData as Map<String, dynamic>?,
    );
  }
}
