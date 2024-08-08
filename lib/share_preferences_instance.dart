// lib/share_preferences_instance.dart

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesInstance {
  static SharedPreferences? _preferences;

  static Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static SharedPreferences get instance {
    if (_preferences == null) {
      throw Exception(
          "SharedPreferences has not been initialized. Call initialize() first.");
    }
    return _preferences!;
  }
}
