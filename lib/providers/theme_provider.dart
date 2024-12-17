import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _dark = false;

  ThemeProvider({bool? dark}) : _dark = dark ?? false;

  bool get darkTheme => _dark;

  set darkTheme(bool value) {
    _dark = value;
    notifyListeners();
  }
}
