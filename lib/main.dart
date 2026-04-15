// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/theme_provider.dart';
import 'providers/config_provider.dart';
import 'providers/server_provider.dart';
import 'providers/vpn_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeProvider = ThemeProvider();
  await themeProvider.load();

  final configProvider = ConfigProvider();
  await configProvider.load();

  final serverProvider = ServerProvider();
  await serverProvider.loadServers();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: configProvider),
        ChangeNotifierProvider.value(value: serverProvider),
        ChangeNotifierProxyProvider2<ConfigProvider, ServerProvider,
            VpnProvider>(
          create: (ctx) => VpnProvider(configProvider, serverProvider),
          update: (ctx, cfg, srv, prev) => prev ?? VpnProvider(cfg, srv),
        ),
      ],
      child: const VpnApp(),
    ),
  );
}
