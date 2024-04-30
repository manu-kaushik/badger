import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final LocalStorage instance = LocalStorage._internal();

  late SharedPreferences preferences;

  LocalStorage._internal();

  factory LocalStorage() {
    return instance;
  }

  Future<void> initialize() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future<bool> getBool(String key) {
    return Future.value(preferences.getBool(key) ?? false);
  }

  Future<void> setBool(String key, bool value) {
    return preferences.setBool(key, value);
  }

  Future<int> getInt(String key) {
    return Future.value(preferences.getInt(key) ?? 0);
  }

  Future<void> setInt(String key, int value) {
    return preferences.setInt(key, value);
  }

  Future<String> getString(String key) {
    return Future.value(preferences.getString(key) ?? '');
  }

  Future<void> setString(String key, String value) {
    return preferences.setString(key, value);
  }

  Future<List<String>> getStringList(String key) {
    return Future.value(preferences.getStringList(key) ?? []);
  }

  Future<void> setStringList(String key, List<String> value) {
    return preferences.setStringList(key, value);
  }

  Future<void> remove(String key) {
    return preferences.remove(key);
  }
}
