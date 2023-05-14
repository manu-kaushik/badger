import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();

  late SharedPreferences _preferences;

  LocalStorage._internal();

  factory LocalStorage() {
    return _instance;
  }

  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<bool> getBool(String key) {
    return Future.value(_preferences.getBool(key) ?? false);
  }

  Future<void> setBool(String key, bool value) {
    return _preferences.setBool(key, value);
  }

  Future<int> getInt(String key) {
    return Future.value(_preferences.getInt(key) ?? 0);
  }

  Future<void> setInt(String key, int value) {
    return _preferences.setInt(key, value);
  }

  Future<String> getString(String key) {
    return Future.value(_preferences.getString(key) ?? '');
  }

  Future<void> setString(String key, String value) {
    return _preferences.setString(key, value);
  }

  Future<List<String>> getStringList(String key) {
    return Future.value(_preferences.getStringList(key) ?? []);
  }

  Future<void> setStringList(String key, List<String> value) {
    return _preferences.setStringList(key, value);
  }

  Future<void> remove(String key) {
    return _preferences.remove(key);
  }
}
