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

  VpnConfig toVpnConfig() => VpnConfig(
    id: 'server_$id',
    name: '$flag $country',
    privateKey: privateKey,
    address: address,
    dns: dns,
    publicKey: publicKey,
    presharedKey: presharedKey,
    endpoint: endpoint,
    allowedIPs: '0.0.0.0/0, ::/0',
  );
}
