import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  String _language = 'ar';
  double _fontSize = 16.0;
  bool _isPinEnabled = false;
  String _appIcon = 'MMH';

  bool get isDarkMode => _isDarkMode;
  String get language => _language;
  double get fontSize => _fontSize;
  bool get isPinEnabled => _isPinEnabled;
  String get appIcon => _appIcon;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _language = prefs.getString('language') ?? 'ar';
    _fontSize = prefs.getDouble('fontSize') ?? 16.0;
    _isPinEnabled = prefs.getBool('isPinEnabled') ?? false;
    _appIcon = prefs.getString('appIcon') ?? 'MMH';
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
    notifyListeners();
  }

  Future<void> setFontSize(double size) async {
    _fontSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', size);
    notifyListeners();
  }

  Future<void> setPinEnabled(bool value) async {
    _isPinEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPinEnabled', value);
    notifyListeners();
  }

  Future<void> setAppIcon(String icon) async {
    _appIcon = icon;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('appIcon', icon);
    notifyListeners();
  }

  ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: const Color(0xFF1E3A8A),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: _fontSize + 8,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1E293B),
        ),
        bodyLarge: TextStyle(
          fontSize: _fontSize,
          color: const Color(0xFF475569),
        ),
        bodyMedium: TextStyle(
          fontSize: _fontSize - 2,
          color: const Color(0xFF64748B),
        ),
      ),
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF3B82F6),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E293B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF3B82F6),
        foregroundColor: Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: _fontSize + 8,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: _fontSize,
          color: const Color(0xFFE2E8F0),
        ),
        bodyMedium: TextStyle(
          fontSize: _fontSize - 2,
          color: const Color(0xFFCBD5E1),
        ),
      ),
    );
  }
}
