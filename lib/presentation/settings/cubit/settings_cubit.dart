import 'dart:io';

import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:globeporter/basecubit/base_cubit.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/settings/repository/settings_repository.dart';
import 'package:globeporter/presentation/settings/states/settings_states.dart';
import 'package:globeporter/resources/app_keys.dart';
import 'package:globeporter/resources/app_storage.dart';

class SettingsCubit extends BaseCubit {
  final SettingsRepository _settingsRepository;
  SettingsCubit(this._settingsRepository);
  final storage = sl<SecureStorage>();
  final authCubit = sl<AuthCubit>();

  Future<void> updateProfile({
    required final String name,
    required final String email,
    required final String dialCode,
    required final String mobile,
    required final File? profilePic,
  }) async {
    try {
      emit(UpdateProfileLoadingState('Submitting details'));
      final accessToken = await storage.readValue(accessTokenKey);
      final lang = await storage.readValue(languageCodeKey);
      final fcmToken = '_test';

      final response = await _settingsRepository.updateProfile(
        lang: lang ?? 'en',
        accessToken: accessToken ?? '',
        name: name,
        email: email,
        fcmToken: fcmToken,
        dialCode: dialCode,
        mobile: mobile,
        profilePic: profilePic ?? null,
      );
      customPrint(response.toString());

      await authCubit.getUserDetails(force: true).then(
        (value) {
          emit(UpdateProfileLoadedState(data: response));
        },
      );
    } catch (e) {
      handleExceptions(e);
    }
  }
}
