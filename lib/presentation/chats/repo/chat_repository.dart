import 'package:datasource/base_repository.dart';
import 'package:datasource/network/api_call_type.dart';
import 'package:globeporter/resources/app_api.dart';

class ChatRepository extends BaseRepository {
  Future<Map<String, dynamic>> sendNotification({
    required final String lang,
    required final String title,
    required final String message,
    required final String? receiverId,
    required final String? senderId,
    required final String? receiverName,
    required final String? senderName,
    required final String? receiverImageUrl,
    required final String? userType,
    final String? id,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: commonSendNotificationUrl,
      requestModel: {
        'lang': lang,
        'title': title,
        'message': message,
        'id': id,
        'receiver_id': receiverId,
        'sender_id': senderId,
        "senderName": senderName,
        "receiverName": receiverName,
        "receiverImageUrl": receiverImageUrl,
        "user_type": userType,
      },
    );

    return responseData;
  }
}
