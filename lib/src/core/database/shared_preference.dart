// ignore_for_file:  constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

///
abstract class LocalPreference {
  ///
  static late SharedPreferences _sharedPreferences;

  ///
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  /// is logged in key
  static const String KEY_IS_LOGIN = 'is_logged_in';

  /// user id  key
  static const String KEY_USER_ID = 'key_user_id';

  /// passed onboarding  key
  static const String KEY_ON_BOARDED = 'key_on_boarded';

  /// user name  key
  static const String KEY_USER_NAME = 'key_user_name';

  /// user email  key
  static const String KEY_USER_EMAIL = 'key_user_email';

  /// value of logged in
  static bool get isLoggedIn => _sharedPreferences.getBool(KEY_IS_LOGIN) ?? false;

  /// value of logged in
  static bool get hasOnboarded => _sharedPreferences.getBool(KEY_ON_BOARDED) ?? false;

  /// value of user name in
  static String get displayName => _sharedPreferences.getString(KEY_USER_NAME) ?? '';

  /// value of user name in
  static String get email => _sharedPreferences.getString(KEY_USER_EMAIL) ?? '';

  /// value of user name in
  static String get userID => _sharedPreferences.getString(KEY_USER_ID) ?? '';

  /// write a bool value of a key into storage
  static Future<void> writeBoolToStorage({required String key, required bool value}) async {
    await _sharedPreferences.setBool(key, value);
  }

  /// write a bool value of a key into storage
  static Future<void> writeIntToStorage({required String key, required int value}) async {
    await _sharedPreferences.setInt(key, value);
  }

  /// write a String value of a key into storage
  static Future<void> writeStringToStorage({required String key, required String value}) async {
    await _sharedPreferences.setString(key, value);
  }
}
