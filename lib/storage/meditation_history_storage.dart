import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskly/utils/date_utils.dart';

class MeditationHistoryStorage {
  static const String _meditHistKey = 'MeditationHistory';

  static Future<void> addToHistory(int timeDiff) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> history = await _getHistoryList(prefs);
      final newEntry = {
        "value": timeDiff.toString(),
        "date": MyDateUtils.getFormattedDate(DateTime.now()),
      };
      history.add(newEntry);
      await _saveHistory(prefs, history);
    } catch (e) {
      print('Error adding meditation history: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await _getHistoryList(prefs);
    } catch (e) {
      print('Error retrieving meditation history: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> _getHistoryList(SharedPreferences prefs) async {
    final String? encodedHistory = prefs.getString(_meditHistKey);
    if (encodedHistory == null) {
      return [];
    }

    try {
      final List<dynamic> decodedList = jsonDecode(encodedHistory);
      return List<Map<String, dynamic>>.from(decodedList);
    } catch (e) {
      print('Error parsing meditation history: $e');
      // If there's an error parsing, return empty list and optionally clear corrupted data
      await prefs.remove(_meditHistKey);
      return [];
    }
  }

  static Future<void> _saveHistory(SharedPreferences prefs, List<Map<String, dynamic>> history) async {
    final String encodedHistory = jsonEncode(history);
    await prefs.setString(_meditHistKey, encodedHistory);
  }
} 
