import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  IOSOptions _getIOSOptions() => IOSOptions(
        accountName: 'globeporter',
      );

  Future<void> saveValue({required final String? value, required final String key}) async {
    await FlutterSecureStorage().write(
      key: key,
      value: value,
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    );
  }

  Future<String?> readValue(final String key) => FlutterSecureStorage().read(
        key: key,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );

  Future<void> clearAll() => FlutterSecureStorage().deleteAll();

  Future<void> clearData(final String key) async {
    await FlutterSecureStorage().delete(key: key);
  }
}
