// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/config_provider.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoConnect = false;

  @override
  void initState() {
    super.initState();
    _loadAutoConnect();
  }

  Future<void> _loadAutoConnect() async {
    final val = await StorageService.getBool(AppConstants.autoConnectKey);
    setState(() => _autoConnect = val);
  }

  @override
  Widget build(BuildContext context) {
    final themeProv = context.watch<ThemeProvider>();
    final configProv = context.watch<ConfigProvider>();

    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            SwitchListTile(
              title: const Text('Auto-connect on launch'),
              secondary: const Icon(Icons.bolt, color: AppTheme.primaryColor),
              value: _autoConnect,
              onChanged: (val) async {
                setState(() => _autoConnect = val);
                await StorageService.setBool(AppConstants.autoConnectKey, val);
              },
            ),
            SwitchListTile(
              title: const Text('Dark theme'),
              secondary: const Icon(
                Icons.dark_mode,
                color: AppTheme.primaryColor,
              ),
              value: themeProv.isDark,
              onChanged: (val) => themeProv.setDark(val),
            ),
            ListTile(
              leading: const Icon(Icons.delete_sweep, color: Colors.red),
              title: const Text('Clear all configs'),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear All Configs'),
                    content: const Text(
                      'This will delete all imported configs. Are you sure?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text(
                          'Delete All',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await configProv.clearAll();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All configs cleared')),
                    );
                  }
                }
              },
            ),
            const Divider(),
            const ListTile(
              leading: Icon(
                Icons.info_outline,
                color: AppTheme.primaryColor,
              ),
              title: Text('App version'),
              trailing: Text(
                AppConstants.appVersion,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.vpn_key, color: AppTheme.primaryColor),
              title: Text('Protocol'),
              trailing: Text(
                'WireGuard',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
