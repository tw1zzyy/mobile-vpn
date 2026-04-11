// lib/providers/config_provider.dart
import 'package:flutter/material.dart';
import '../models/vpn_config.dart';
import '../services/storage_service.dart';

class ConfigProvider extends ChangeNotifier {
  List<VpnConfig> _configs = [];
  String? _activeConfigId;

  List<VpnConfig> get configs => List.unmodifiable(_configs);
  String? get activeConfigId => _activeConfigId;
  VpnConfig? get activeConfig => _activeConfigId == null
      ? null
      : _configs.where((c) => c.id == _activeConfigId).firstOrNull;

  Future<void> load() async {
    _configs = await StorageService.loadConfigs();
    notifyListeners();
  }

  Future<void> addConfig(VpnConfig config) async {
    await StorageService.saveConfig(config);
    _configs = await StorageService.loadConfigs();
    notifyListeners();
  }

  Future<void> deleteConfig(String id) async {
    if (_activeConfigId == id) _activeConfigId = null;
    await StorageService.deleteConfig(id);
    _configs = await StorageService.loadConfigs();
    notifyListeners();
  }

  Future<void> clearAll() async {
    _activeConfigId = null;
    await StorageService.clearAll();
    _configs = [];
    notifyListeners();
  }

  void setActive(String? id) {
    _activeConfigId = id;
    notifyListeners();
  }
}
