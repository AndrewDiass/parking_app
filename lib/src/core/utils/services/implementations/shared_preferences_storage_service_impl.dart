import 'package:shared_preferences/shared_preferences.dart';

import '../interfaces/i_storage_service.dart';

class SharedPreferencesStorageService implements IMemoryStorageService {
  static SharedPreferences? _preferences;

  static Future<SharedPreferences> getInstance() async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
    return _preferences!;
  }

  @override
  Future<bool> delete({required String keyName}) async {
    final prefs = await getInstance();
    return await prefs.remove(keyName);
  }

  @override
  dynamic read({
    required String keyName,
  }) async {
    final prefs = await getInstance();
    return await prefs.getString(keyName);
  }

  @override
  Future<bool> write({required String keyName, required String value}) async {
    final prefs = await getInstance();
    return await prefs.setString(keyName, value);
  }
}
