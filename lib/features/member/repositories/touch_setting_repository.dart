import 'package:shared_preferences/shared_preferences.dart';

class TouchSettingsRepository {
  static const _threeTouchesKey = 'three_touches';
  static const _fourTouchesKey = 'four_touches';
  static const _fiveTouchesKey = 'five_touches';
  static const _sixTouchesKey = 'six_touches';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> saveThreeTouchesMessage(String message) async {
    final prefs = await _prefs;
    prefs.setString(_threeTouchesKey, message);
  }

  Future<String?> getThreeTouchesMessage() async {
    final prefs = await _prefs;
    return prefs.getString(_threeTouchesKey);
  }

  // Similar methods for fourTouches, fiveTouches, and sixTouches

  Future<void> saveFourTouchesMessage(String message) async {
    final prefs = await _prefs;
    prefs.setString(_fourTouchesKey, message);
  }

  Future<String?> getFourTouchesMessage() async {
    final prefs = await _prefs;
    return prefs.getString(_fourTouchesKey);
  }

  Future<void> saveFiveTouchesMessage(String message) async {
    final prefs = await _prefs;
    prefs.setString(_fiveTouchesKey, message);
  }

  Future<String?> getFiveTouchesMessage() async {
    final prefs = await _prefs;
    return prefs.getString(_fiveTouchesKey);
  }

  Future<void> saveSixTouchesMessage(String message) async {
    final prefs = await _prefs;
    prefs.setString(_sixTouchesKey, message);
  }

  Future<String?> getSixTouchesMessage() async {
    final prefs = await _prefs;
    return prefs.getString(_sixTouchesKey);
  }
}
