// lib/widgets/config_tile.dart
import 'package:flutter/material.dart';
import '../models/vpn_config.dart';
import '../utils/theme.dart';

class ConfigTile extends StatelessWidget {
  final VpnConfig config;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ConfigTile({
    super.key,
    required this.config,
    required this.isActive,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(config.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Delete Config'),
                content: Text('Delete "${config.name}"?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) => onDelete(),
      child: ListTile(
        leading: const Icon(
          Icons.description_outlined,
          color: AppTheme.primaryColor,
        ),
        title: Text(
          config.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          config.endpoint,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: Radio<String>(
          value: config.id,
          groupValue: isActive ? config.id : null,
          onChanged: (_) => onTap(),
          activeColor: AppTheme.primaryColor,
        ),
        onTap: onTap,
      ),
    );
  }
}
