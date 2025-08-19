import 'package:datasource/base_repository.dart';
import 'package:datasource/network/api_call_type.dart';
import 'package:globeporter/presentation/notification/model/notifications_response_model.dart';
import 'package:globeporter/resources/app_api.dart';

class NotificationRepository extends BaseRepository {
  Future<NotificationsResponse> getNotifications({
    required final String lang,
    required final String accessToken,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: getNotificationsUrl,
      accessToken: accessToken,
      requestModel: {
        'lang': lang,
      },
    );

    return NotificationsResponse.fromJson(
      responseData as Map<String, dynamic>?,
    );
  }

  Future<NotificationsResponse> markNotificationsRead({
    required final String lang,
    required final String accessToken,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: markNotificationReadUrl,
      accessToken: accessToken,
      requestModel: {
        'lang': lang,
      },
    );

    return NotificationsResponse.fromJson(
      responseData as Map<String, dynamic>?,
    );
  }

  Future<Map<String, dynamic>> getNotificatinsUnreadCount({
    required final String lang,
    required final String accessToken,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: notificationUnreadCountUrl,
      accessToken: accessToken,
      requestModel: {
        'lang': lang,
      },
    );

    return responseData;
  }
}
