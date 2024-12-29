import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskly/models/kudos.dart';

class KudosService {
  static const String _kudosKey = 'kudos';

  static Future<void> saveKudos(Kudos kudos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kudosKey, jsonEncode(kudos.toJson()));
  }

  static Future<Kudos> loadKudos() async {
    final prefs = await SharedPreferences.getInstance();
    String? encodedKudos = prefs.getString(_kudosKey);
    if (encodedKudos == null) return Kudos(score: 0, history: []);

    return Kudos.fromJson(jsonDecode(encodedKudos));
  }
}
