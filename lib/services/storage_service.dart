import 'package:flutter/material.dart';
import 'package:pass_strength/themes/dark_mode.dart';
import 'package:pass_strength/themes/light_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }

  static Future<List<String>> loadStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  static Future<void> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool> loadBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static Future<void> saveDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  static Future<double> loadDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key) ?? 6.0;
  }

  static Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String> loadString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? 'Customize...';
  }
}

class HistoryProvider extends ChangeNotifier {
  List<String> _history = [];

  List<String> get history => _history;

  HistoryProvider() {
    loadHistory();
  }

  void addPassword(String password) {
    _history.insert(0, password);
    if (_history.length > 20) _history.removeLast();
    StorageService.saveStringList('history', _history);
    notifyListeners();
  }

  void removePasswordAt(int index) {
    _history.removeAt(index);
    StorageService.saveStringList('history', _history);
    notifyListeners();
  }

  Future<void> loadHistory() async {
    _history = await StorageService.loadStringList('history');
    notifyListeners();
  }
}

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = false;
  ThemeData _themeData = lightMode;
  ThemeData get themeData => _themeData;

  ThemeProvider() {
    loadTheme();
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    _themeData = isDarkMode ? darkMode : lightMode;
    StorageService.saveBool('isDarkMode', isDarkMode);
    notifyListeners();
  }

  Future<void> loadTheme() async {
    isDarkMode = await StorageService.loadBool('isDarkMode');
    _themeData = isDarkMode ? darkMode : lightMode;
    notifyListeners();
  }
}
