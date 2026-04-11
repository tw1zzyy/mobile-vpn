// lib/screens/servers_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../providers/config_provider.dart';
import '../providers/server_provider.dart';
import '../services/config_parser.dart';
import '../widgets/server_tile.dart';
import '../widgets/config_tile.dart';
import '../utils/theme.dart';

class ServersScreen extends StatelessWidget {
  const ServersScreen({super.key});

  Future<void> _importConfig(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.path == null) return;
    try {
      final content = await File(file.path!).readAsString();
      final config = ConfigParser.parse(file.path!, content);
      if (context.mounted) {
        await context.read<ConfigProvider>().addConfig(config);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Imported: ${config.name}'),
            backgroundColor: AppTheme.connectedGreen,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer2<ServerProvider, ConfigProvider>(
          builder: (context, serverProv, configProv, _) {
            return ListView(
              padding: const EdgeInsets.only(bottom: 80),
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Free Servers',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                ...serverProv.servers.map(
                  (server) => ServerTile(
                    server: server,
                    isActive: serverProv.activeServerId == server.id,
                    onTap: () {
                      serverProv.setActive(server.id);
                      configProv.setActive(null);
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Text(
                    'My Configs',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                if (configProv.configs.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'No configs yet. Import a .conf file below',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ...configProv.configs.map(
                    (config) => ConfigTile(
                      config: config,
                      isActive: configProv.activeConfigId == config.id,
                      onTap: () {
                        configProv.setActive(config.id);
                        serverProv.clearActive();
                      },
                      onDelete: () => configProv.deleteConfig(config.id),
                    ),
                  ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _importConfig(context),
          backgroundColor: AppTheme.primaryColor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
