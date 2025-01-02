import 'package:flutter/material.dart';
import 'package:taskly/storage/themeData_storage.dart';

class ThemeProvider extends ChangeNotifier {
  bool _dark = false; // Default to false

  ThemeProvider() {
    // Fetch stored theme asynchronously and update
    _loadTheme();
  }

  // Asynchronously load theme
  Future<void> _loadTheme() async {
    bool storedTheme = await ThemeStorage.loadtheme(); // Load theme
    _dark = storedTheme; // Update the value
    notifyListeners(); // Notify UI
  }

  bool get darkTheme => _dark;

  set darkTheme(bool value) {
    _dark = value;
    ThemeStorage.savetheme(value); // Save updated value
    notifyListeners();
  }
}
