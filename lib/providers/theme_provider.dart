import 'package:flutter/material.dart';
import '../services/database_service.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isDarkMode = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemeSettings();
  }

  void _loadThemeSettings() {
    final settings = DatabaseService.getSettings();
    _isDarkMode = settings.isDarkMode;
    _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    
    // Save to database
    final settings = DatabaseService.getSettings();
    final updatedSettings = settings.copyWith(isDarkMode: _isDarkMode);
    DatabaseService.saveSettings(updatedSettings);
    
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _isDarkMode = mode == ThemeMode.dark;
    
    // Save to database
    final settings = DatabaseService.getSettings();
    final updatedSettings = settings.copyWith(isDarkMode: _isDarkMode);
    DatabaseService.saveSettings(updatedSettings);
    
    notifyListeners();
  }
}


