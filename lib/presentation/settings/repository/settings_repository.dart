import 'dart:io';

import 'package:datasource/base_repository.dart';
import 'package:datasource/network/api_call_type.dart';
import 'package:globeporter/resources/app_api.dart';

class SettingsRepository extends BaseRepository {
  Future<Map<String, dynamic>> updateProfile({
    required final String lang,
    required final String accessToken,
    required final String name,
    required final String email,
    required final String fcmToken,
    required final String dialCode,
    required final String mobile,
    required final File? profilePic,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.postWithFile,
      apiUrl: updateProfileUrl,
      accessToken: accessToken,
      requestModel: {
        'lang': lang,
        'name': name,
        'email': email,
        'fcm_token': fcmToken,
        'dial_code': dialCode,
        'mobile': mobile,
      },
      filesWithFieldNames: {
        'profile_image': profilePic,
      },
    );

    return responseData;
  }
}
