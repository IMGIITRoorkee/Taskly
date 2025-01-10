import 'package:shared_preferences/shared_preferences.dart';

class LocalDbService {
  static const String firstTimeKey = "FIRST_TIME";
  static const String email = "EMAIL";

  static Future setFirstTime(bool value) async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setBool(firstTimeKey, value);
  }

  static Future<bool> getFirstTime() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    return s.getBool(firstTimeKey) ?? true;
  }

  static Future setUserEmail(String e) async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString(email, e);
  }

  static Future removeUserEmail() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.remove(email);
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    return s.getString(email);
  }
}
