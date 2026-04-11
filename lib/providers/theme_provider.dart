// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = true;

  bool get isDark => _isDark;

  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  Future<void> load() async {
    _isDark = await StorageService.getBool(
      AppConstants.darkThemeKey,
      defaultValue: true,
    );
    notifyListeners();
  }

  Future<void> setDark(bool value) async {
    _isDark = value;
    await StorageService.setBool(AppConstants.darkThemeKey, value);
    notifyListeners();
  }
}
