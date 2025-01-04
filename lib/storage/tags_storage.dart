import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskly/models/tag.dart';

class TagsStorage {
  static const _key = "tags";

  static Future<void> saveTags(List<Tag> tags) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> str = tags.map((e) => jsonEncode(e.toJson())).toList();
    sharedPreferences.setStringList(_key, str);
  }

  static Future<List<Tag>> loadTags() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? str = sharedPreferences.getStringList(_key);
    if (str != null) {
      return str.map((e) => Tag.fromJson(jsonDecode(e))).toList();
    }
    return [];
  }
}
