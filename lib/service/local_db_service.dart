import 'package:shared_preferences/shared_preferences.dart';

class LocalDbService {
  static const String firstTimeKey = "FIRST_TIME";

  static Future setFirstTime(bool value) async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setBool(firstTimeKey, value);
  }

  static Future<bool> getFirstTime() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    return s.getBool(firstTimeKey) ?? true;
  }
}
