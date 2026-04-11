// lib/models/vpn_config.dart
class VpnConfig {
  final String id;
  final String name;
  final String privateKey;
  final String address;
  final String dns;
  final String publicKey;
  final String presharedKey;
  final String endpoint;
  final String allowedIPs;

  VpnConfig({
    required this.id,
    required this.name,
    required this.privateKey,
    required this.address,
    required this.dns,
    required this.publicKey,
    this.presharedKey = '',
    required this.endpoint,
    this.allowedIPs = '0.0.0.0/0, ::/0',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'privateKey': privateKey,
    'address': address,
    'dns': dns,
    'publicKey': publicKey,
    'presharedKey': presharedKey,
    'endpoint': endpoint,
    'allowedIPs': allowedIPs,
  };

  factory VpnConfig.fromJson(Map<String, dynamic> json) => VpnConfig(
    id: json['id'] as String,
    name: json['name'] as String,
    privateKey: json['privateKey'] as String,
    address: json['address'] as String,
    dns: json['dns'] as String,
    publicKey: json['publicKey'] as String,
    presharedKey: json['presharedKey'] as String? ?? '',
    endpoint: json['endpoint'] as String,
    allowedIPs: json['allowedIPs'] as String? ?? '0.0.0.0/0, ::/0',
  );

  VpnConfig copyWith({
    String? id,
    String? name,
    String? privateKey,
    String? address,
    String? dns,
    String? publicKey,
    String? presharedKey,
    String? endpoint,
    String? allowedIPs,
  }) => VpnConfig(
    id: id ?? this.id,
    name: name ?? this.name,
    privateKey: privateKey ?? this.privateKey,
    address: address ?? this.address,
    dns: dns ?? this.dns,
    publicKey: publicKey ?? this.publicKey,
    presharedKey: presharedKey ?? this.presharedKey,
    endpoint: endpoint ?? this.endpoint,
    allowedIPs: allowedIPs ?? this.allowedIPs,
  );
}
