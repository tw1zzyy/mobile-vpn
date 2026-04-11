// lib/providers/vpn_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';
import '../models/connection_stats.dart';
import '../models/vpn_config.dart';
import '../services/vpn_service.dart';
import '../services/ip_service.dart';
import 'config_provider.dart';
import 'server_provider.dart';

enum VpnStatus { disconnected, connecting, connected }

class VpnProvider extends ChangeNotifier {
  final ConfigProvider _configProvider;
  final ServerProvider _serverProvider;

  VpnStatus _status = VpnStatus.disconnected;
  ConnectionStats _stats = const ConnectionStats();
  StreamSubscription<VpnStage>? _stageSub;
  Timer? _clockTimer;
  Timer? _statusCheckTimer;
  Timer? _speedTimer;
  DateTime? _connectedAt;
  int _lastTx = 0;
  int _lastRx = 0;

  VpnProvider(this._configProvider, this._serverProvider);

  VpnStatus get status => _status;
  ConnectionStats get stats => _stats;

  String get activeSelectionName {
    final cfg = _configProvider.activeConfig;
    if (cfg != null) return cfg.name;
    final srv = _serverProvider.activeServer;
    if (srv != null) return '${srv.flag} ${srv.country}';
    return 'No server selected';
  }

  bool get hasActiveSelection =>
      _configProvider.activeConfig != null ||
      _serverProvider.activeServer != null;

  Future<void> initialize() async {
    _stageSub = VpnService.statusStream.listen(_onStageChange);
    _statusCheckTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      await _checkRealStatus();
    });
  }

  Future<void> _checkRealStatus() async {
    try {
      final stage = await VpnService.currentStage();
      _onStageChange(stage);
    } catch (_) {}
  }

  void _onStageChange(VpnStage stage) {
    switch (stage) {
      case VpnStage.connected:
        if (_status != VpnStatus.connected) {
          _status = VpnStatus.connected;
          _connectedAt ??= DateTime.now();
          _startTimers();
          _refreshIp();
          notifyListeners();
        }
        break;
      case VpnStage.connecting:
      case VpnStage.waitingConnection:
      case VpnStage.authenticating:
      case VpnStage.reconnect:
      case VpnStage.preparing:
        if (_status != VpnStatus.connecting) {
          _status = VpnStatus.connecting;
          _stopTimers();
          notifyListeners();
        }
        break;
      case VpnStage.disconnected:
      case VpnStage.denied:
      case VpnStage.exiting:
      case VpnStage.noConnection:
      case VpnStage.disconnecting:
        if (_status != VpnStatus.disconnected) {
          _status = VpnStatus.disconnected;
          _stopTimers();
          _connectedAt = null;
          _lastTx = 0;
          _lastRx = 0;
          _stats = ConnectionStats(currentIp: _stats.currentIp);
          notifyListeners();
        }
        break;
    }
  }

  Future<void> connect() async {
    VpnConfig? config = _configProvider.activeConfig;
    if (config == null) {
      final server = _serverProvider.activeServer;
      if (server != null) config = server.toVpnConfig();
    }
    if (config == null) return;

    _status = VpnStatus.connecting;
    notifyListeners();
    try {
      await VpnService.connect(config);
    } catch (e) {
      _status = VpnStatus.disconnected;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> disconnect() async {
    await VpnService.disconnect();
    _status = VpnStatus.disconnected;
    _stopTimers();
    _connectedAt = null;
    _lastTx = 0;
    _lastRx = 0;
    _stats = ConnectionStats(currentIp: _stats.currentIp);
    notifyListeners();
  }

  void _startTimers() {
    // Таймер времени
    _clockTimer?.cancel();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_connectedAt != null) {
        _stats = _stats.copyWith(
          elapsed: DateTime.now().difference(_connectedAt!),
        );
        notifyListeners();
      }
    });

    // Таймер скорости — каждые 2 секунды
    _speedTimer?.cancel();
    _speedTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      await _updateTrafficStats();
    });
  }

  Future<void> _updateTrafficStats() async {
    try {
      // Замеряем трафик через количество байт переданных
      // Используем HTTP запрос к небольшому файлу для замера скорости
      // final now = DateTime.now();
      final tx = _stats.bytesTransmitted;
      final rx = _stats.bytesReceived;

      // Считаем скорость как разницу за 2 секунды
      final uploadSpeed = ((tx - _lastTx) / 2).clamp(0, double.infinity);
      final downloadSpeed = ((rx - _lastRx) / 2).clamp(0, double.infinity);

      _lastTx = tx;
      _lastRx = rx;

      _stats = _stats.copyWith(
        uploadSpeed: uploadSpeed.toDouble(),
        downloadSpeed: downloadSpeed.toDouble(),
      );
      notifyListeners();
    } catch (_) {}
  }

  void _stopTimers() {
    _clockTimer?.cancel();
    _speedTimer?.cancel();
    _clockTimer = null;
    _speedTimer = null;
  }

  Future<void> _refreshIp() async {
    await Future.delayed(const Duration(seconds: 2));
    final ip = await IpService.fetchCurrentIp();
    _stats = _stats.copyWith(currentIp: ip);
    notifyListeners();
  }

  Future<void> fetchInitialIp() async {
    final ip = await IpService.fetchCurrentIp();
    _stats = _stats.copyWith(currentIp: ip);
    notifyListeners();
  }

  @override
  void dispose() {
    _stageSub?.cancel();
    _statusCheckTimer?.cancel();
    _stopTimers();
    super.dispose();
  }
}
