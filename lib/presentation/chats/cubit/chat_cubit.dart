import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:globeporter/basecubit/base_cubit.dart';
import 'package:globeporter/presentation/chats/repo/chat_repository.dart';
import 'package:globeporter/presentation/chats/states/chat_states.dart';
import 'package:globeporter/resources/app_keys.dart';
import 'package:globeporter/resources/app_storage.dart';

class ChatCubit extends BaseCubit {
  final ChatRepository _chatRepository;
  bool isOtpScreen = false;
  ChatCubit(this._chatRepository) : super();
  final storage = sl<SecureStorage>();

  Future<void> sendNotification({
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
    try {
      emit(ChatNotificationLoadingState('Loading'));
      final lang = await storage.readValue(languageCodeKey);
      // final accessToken = await storage.readValue(accessTokenKey);
      final response = await _chatRepository.sendNotification(
        lang: lang ?? 'en',
        title: title,
        message: message,
        id: id,
        receiverId: receiverId,
        senderId: senderId,
        receiverName: receiverName,
        senderName: senderName,
        receiverImageUrl: receiverImageUrl,
        userType: userType,
      );
      customPrint('Chat Notification Response: ${response.toString()}');

      emit(ChatNotificationLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }
}
