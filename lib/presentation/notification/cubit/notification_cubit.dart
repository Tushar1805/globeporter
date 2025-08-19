import 'package:core/di/service_locator.dart';
import 'package:globeporter/basecubit/base_cubit.dart';
import 'package:globeporter/presentation/notification/repository/notification_repository.dart';
import 'package:globeporter/presentation/notification/states/notification_states.dart';
import 'package:globeporter/resources/app_keys.dart';
import 'package:globeporter/resources/app_storage.dart';

class NotificationCubit extends BaseCubit {
  final NotificationRepository _notificationRepository;
  bool isOtpScreen = false;
  NotificationCubit(this._notificationRepository) : super();
  final storage = sl<SecureStorage>();

  Future<void> getNotifications() async {
    try {
      emit(NotificationsLoadingState('Loading'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _notificationRepository.getNotifications(
        lang: lang ?? 'en',
        accessToken: accessToken ?? '',
      );

      emit(NotificationsLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> markNotificationsRead() async {
    try {
      emit(MarkNotificationsReadLoadingState('Loading'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _notificationRepository.markNotificationsRead(
        lang: lang ?? 'en',
        accessToken: accessToken ?? '',
      );

      emit(MarkNotificationsReadLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> getNotificatinsUnreadCount() async {
    try {
      emit(NotificationUnreadCountLoadingState('Loading'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _notificationRepository.getNotificatinsUnreadCount(
        lang: lang ?? 'en',
        accessToken: accessToken ?? '',
      );

      emit(NotificationUnreadCountLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }
}
