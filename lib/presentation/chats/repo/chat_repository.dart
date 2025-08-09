import 'package:datasource/base_repository.dart';
import 'package:datasource/network/api_call_type.dart';
import 'package:globeporter/resources/app_api.dart';

class ChatRepository extends BaseRepository {
  Future<Map<String, dynamic>> sendNotification({
    required final String lang,
    required final String title,
    required final String message,
    final String? id,
    final String? userId,
    final String? driverId,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: commonSendNotificationUrl,
      requestModel: {
        'lang': lang,
        'title': title,
        'message': message,
        'id': id,
        'user_id': userId,
        'driver_id': driverId,
      },
    );

    return responseData;
  }
}
