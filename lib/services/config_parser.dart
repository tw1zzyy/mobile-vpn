// lib/services/config_parser.dart
// import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/vpn_config.dart';

class ConfigParser {
  /// Parses a WireGuard .conf file and returns a [VpnConfig].
  /// Throws [FormatException] if required fields are missing.
  static VpnConfig parse(String filePath, String fileContent) {
    final name = path.basenameWithoutExtension(filePath);
    final lines = fileContent.split('\n').map((l) => l.trim()).toList();

    String privateKey = '';
    String address = '';
    String dns = '';
    String publicKey = '';
    String presharedKey = '';
    String endpoint = '';
    String allowedIPs = '0.0.0.0/0, ::/0';

    String section = '';

    for (final line in lines) {
      if (line.isEmpty || line.startsWith('#')) continue;

      if (line.startsWith('[')) {
        section = line.toLowerCase();
        continue;
      }

      final eqIdx = line.indexOf('=');
      if (eqIdx < 0) continue;

      final key = line.substring(0, eqIdx).trim().toLowerCase();
      final value = line.substring(eqIdx + 1).trim();

      if (section == '[interface]') {
        switch (key) {
          case 'privatekey':
            privateKey = value;
            break;
          case 'address':
            address = value;
            break;
          case 'dns':
            dns = value;
            break;
        }
      } else if (section == '[peer]') {
        switch (key) {
          case 'publickey':
            publicKey = value;
            break;
          case 'presharedkey':
            presharedKey = value;
            break;
          case 'endpoint':
            endpoint = value;
            break;
          case 'allowedips':
            allowedIPs = value;
            break;
        }
      }
    }

    if (privateKey.isEmpty) {
      throw const FormatException('Missing PrivateKey in [Interface]');
    }
    if (address.isEmpty) {
      throw const FormatException('Missing Address in [Interface]');
    }
    if (publicKey.isEmpty) {
      throw const FormatException('Missing PublicKey in [Peer]');
    }
    if (endpoint.isEmpty) {
      throw const FormatException('Missing Endpoint in [Peer]');
    }

    return VpnConfig(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      privateKey: privateKey,
      address: address,
      dns: dns,
      publicKey: publicKey,
      presharedKey: presharedKey,
      endpoint: endpoint,
      allowedIPs: allowedIPs,
    );
  }
}
