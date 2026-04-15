// lib/models/server_model.dart
import 'vpn_config.dart';

class ServerModel {
  final String id;
  final String flag;
  final String country;
  final String endpoint;
  final String publicKey;
  final String privateKey;
  final String address;
  final String dns;
  final String presharedKey;

  const ServerModel({
    required this.id,
    required this.flag,
    required this.country,
    required this.endpoint,
    required this.publicKey,
    required this.privateKey,
    required this.address,
    required this.dns,
    required this.presharedKey,
  });

  factory ServerModel.fromJson(Map<String, dynamic> json) {
    return ServerModel(
      id: json['id']?.toString() ?? '',
      flag: json['flag'] ?? '🌐',
      country: json['country'] ?? 'Unknown',
      endpoint: json['endpoint'] ?? '',
      publicKey: json['public_key'] ?? json['publicKey'] ?? '',
      privateKey: json['private_key'] ?? json['privateKey'] ?? '',
      address: json['address'] ?? '',
      dns: json['dns'] ?? '1.1.1.1',
      presharedKey: json['preshared_key'] ?? json['presharedKey'] ?? '',
    );
  }

  VpnConfig toVpnConfig() {
    return VpnConfig(
      name: country, // Use the country name as the tunnel name
      address: address,
      dns: dns,
      publicKey: publicKey,
      privateKey: privateKey,
      endpoint: endpoint,
      presharedKey: presharedKey, id: '',
    );
  }
}
