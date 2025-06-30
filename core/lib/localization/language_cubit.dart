import 'dart:ui';

import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:globeporter/resources/app_keys.dart';
import 'package:globeporter/resources/app_storage.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(Locale('en'));
  final storage = sl<SecureStorage>();

  Locale? _appLocale;
  Locale? get appLocale => _appLocale;

  Future<void> getLanguage() async {
    final val = await storage.readValue(languageCodeKey);
    _appLocale = Locale(val ?? 'en');
    customPrint('Entered to check Language: ${_appLocale?.languageCode}');
    emit(Locale(val ?? 'en'));
  }

  void changeLanguage(final Locale type) async {
    _appLocale = type;
    if (type == Locale('en')) {
      await storage.saveValue(key: languageCodeKey, value: 'en');
      emit(Locale('en'));
    } else {
      await storage.saveValue(key: languageCodeKey, value: 'hi');
      emit(Locale('hi'));
    }
    customPrint('App Language Changed: ${_appLocale?.languageCode}');
  }
}
