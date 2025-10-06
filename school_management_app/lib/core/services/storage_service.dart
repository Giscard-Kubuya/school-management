import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;
  
  StorageService(this._prefs, this._secureStorage);
  
  // String operations
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }
  
  String? getString(String key) {
    return _prefs.getString(key);
  }
  
  // Int operations
  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }
  
  int? getInt(String key) {
    return _prefs.getInt(key);
  }
  
  // Bool operations
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }
  
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }
  
  // Remove
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }
  
  // Clear all
  Future<void> clear() async {
    await _prefs.clear();
  }
  
  // Secure storage operations
  Future<void> setSecure(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }
  
  Future<String?> getSecure(String key) async {
    return await _secureStorage.read(key: key);
  }
  
  Future<void> removeSecure(String key) async {
    await _secureStorage.delete(key: key);
  }
  
  Future<void> clearSecure() async {
    await _secureStorage.deleteAll();
  }
}
