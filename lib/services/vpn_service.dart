// lib/services/vpn_service.dart
import 'package:wireguard_flutter/wireguard_flutter.dart';
import 'package:wireguard_flutter/wireguard_flutter_platform_interface.dart';
import '../models/vpn_config.dart';
import '../utils/constants.dart';

class VpnService {
  static final WireGuardFlutterInterface _wg = WireGuardFlutter.instance;
  static bool _initialized = false;

  static Stream<VpnStage> get statusStream => _wg.vpnStageSnapshot;

  static Future<void> initialize() async {
    if (_initialized) return;
    await _wg.initialize(interfaceName: AppConstants.tunnelName);
    _initialized = true;
  }

  static Future<void> connect(VpnConfig config) async {
    await initialize(); // всегда инициализируем перед подключением
    await _wg.startVpn(
      serverAddress: config.endpoint,
      wgQuickConfig: _buildConfig(config),
      providerBundleIdentifier: 'com.example.vpnapp',
    );
  }

  static Future<void> disconnect() async {
    await _wg.stopVpn();
  }

  static Future<VpnStage> currentStage() async {
    return await _wg.stage();
  }

  static String _buildConfig(VpnConfig config) {
    final buffer = StringBuffer();
    buffer.writeln('[Interface]');
    buffer.writeln('PrivateKey = ${config.privateKey}');
    buffer.writeln('Address = ${config.address}');
    if (config.dns.isNotEmpty) buffer.writeln('DNS = ${config.dns}');
    buffer.writeln('');
    buffer.writeln('[Peer]');
    buffer.writeln('PublicKey = ${config.publicKey}');
    if (config.presharedKey.isNotEmpty) {
      buffer.writeln('PresharedKey = ${config.presharedKey}');
    }
    buffer.writeln('Endpoint = ${config.endpoint}');
    buffer.writeln('AllowedIPs = ${config.allowedIPs}');
    buffer.writeln('PersistentKeepalive = 25');
    return buffer.toString();
  }
}
