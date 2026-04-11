// lib/widgets/server_tile.dart
import 'package:flutter/material.dart';
import '../models/server_model.dart';
import '../utils/theme.dart';

class ServerTile extends StatelessWidget {
  final ServerModel server;
  final bool isActive;
  final VoidCallback onTap;

  const ServerTile({
    super.key,
    required this.server,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(server.flag, style: const TextStyle(fontSize: 28)),
      title: Text(
        server.country,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        server.endpoint,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: Radio<String>(
        value: server.id,
        groupValue: isActive ? server.id : null,
        onChanged: (_) => onTap(),
        activeColor: AppTheme.primaryColor,
      ),
      onTap: onTap,
    );
  }
}
