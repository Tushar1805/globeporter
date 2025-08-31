import 'package:datasource/base_repository.dart';
import 'package:datasource/network/api_call_type.dart';
import 'package:globeporter/presentation/authentication/model/google_login_response_model.dart';
import 'package:globeporter/presentation/authentication/model/login_response_model.dart';
import 'package:globeporter/presentation/authentication/model/otp_response_model.dart';
import 'package:globeporter/presentation/authentication/model/register_response_model.dart';
import 'package:globeporter/presentation/authentication/model/user_details_response_model.dart';
import 'package:globeporter/presentation/authentication/model/user_type_response_model.dart';
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

  Future<GoogleLoginResponseModel?> googleLogin({
    required final String lang,
    required final String googleId,
    required final String name,
    required final String email,
    required final String fcmToken,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: googleLoginUrl,
      requestModel: {
        "lang": lang, // en, mr, hi
        "google_id": googleId,
        "name": name,
        "email": email,
        "fcm_token": fcmToken,
      },
    );
    return GoogleLoginResponseModel.fromJson(
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

  Future<Map<String, dynamic>> updateMobileNumber({
    required final String lang,
    required final String dialCode,
    required final String phoneNumber,
    required final String accessToken,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: updateMobileNumberUrl,
      accessToken: accessToken,
      requestModel: {
        'lang': lang,
        'dial_code': dialCode,
        'mobile': phoneNumber,
      },
    );

    return responseData;
  }

  Future<Map<String, dynamic>> updateVerifyOtp({
    required final String mobile,
    required final String lang,
    required final String otp,
    required final String dialCode,
    required final String accessToken,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: updateVerifyOtpUrl,
      accessToken: accessToken,
      requestModel: {
        'mobile': mobile,
        'lang': lang,
        'otp': otp,
        'dial_code': dialCode,
      },
    );

    return responseData;
  }

  Future<Map<String, dynamic>> makePhoneCall({
    required final String lang,
    required final String accessToken,
    required final String fromNumber,
    required final String toNumber,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: startCallUrl,
      accessToken: accessToken,
      requestModel: {
        'lang': lang,
        'from_number': fromNumber,
        'to_number': toNumber,
      },
    );

    return responseData;
  }

  Future<RegisterResponseModel?> register({
    required final int userId,
    required final String lang,
    required final String name,
    required final String email,
    required final String fcmToken,
    final String? mobile,
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
        'mobile': mobile,
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

  Future<Map<String, dynamic>> updateFcmToken({
    required final String fcmToken,
    required final String lang,
    required final String accessToken,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: fcmTokenUpdateUrl,
      accessToken: accessToken,
      requestModel: {
        'fcm_token': fcmToken,
        'lang': lang,
      },
    );

    return responseData;
  }

  Future<Map<String, dynamic>> logout({
    required final String accessToken,
    required final String lang,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: logoutUrl,
      accessToken: accessToken,
      requestModel: {
        'lang': lang,
      },
    );

    return responseData as Map<String, dynamic>;
  }
}
