import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  // Define custom colors
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color secondary = Color(0xFFFFC107);

  // Add getters for custom colors
  Color get primary => primaryColor;
  Color get accent => secondary;

  bool _darkModeEnabled = false;

  bool get darkModeEnabled => _darkModeEnabled;

  ThemeData get themeData => _darkModeEnabled
      ? ThemeData.dark().copyWith(
    primaryColor: primary,

    secondaryHeaderColor: accent,
    // Add more customizations as needed...
  )
      : ThemeData.light().copyWith(
    primaryColor: primary,
    secondaryHeaderColor: accent,
    // Add more customizations as needed...
  );

  ThemeProvider() {
    _loadDarkModeSetting();
  }

  Future<void> _loadDarkModeSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _darkModeEnabled = prefs.getBool('darkModeEnabled') ?? false;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkModeEnabled', value);
    _darkModeEnabled = value;
    notifyListeners();
  }
}
