import 'package:shared_preferences/shared_preferences.dart';

class ThemeStorage {
  static const String _themeKey = 'theme';

  static Future<void> savetheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, isDark.toString());
  }

  static Future<bool> loadtheme() async {
    final prefs = await SharedPreferences.getInstance();
    String? encodedthemes = prefs.getString(_themeKey);

    return encodedthemes == 'true';
  }
}
