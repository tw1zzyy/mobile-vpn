// lib/services/storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vpn_config.dart';
import '../utils/constants.dart';

class StorageService {
  static Future<List<VpnConfig>> loadConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(AppConstants.vpnConfigsKey);
    if (jsonStr == null) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr) as List<dynamic>;
      return list
          .map((e) => VpnConfig.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveConfig(VpnConfig config) async {
    final configs = await loadConfigs();
    configs.removeWhere((c) => c.id == config.id);
    configs.add(config);
    await _persist(configs);
  }

  static Future<void> deleteConfig(String id) async {
    final configs = await loadConfigs();
    configs.removeWhere((c) => c.id == id);
    await _persist(configs);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.vpnConfigsKey);
  }

  static Future<void> _persist(List<VpnConfig> configs) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(configs.map((c) => c.toJson()).toList());
    await prefs.setString(AppConstants.vpnConfigsKey, jsonStr);
  }

  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }

  static Future<void> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
}
