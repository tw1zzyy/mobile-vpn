// lib/providers/server_provider.dart
import 'package:flutter/material.dart';
import '../models/server_model.dart';
import '../utils/constants.dart';

class ServerProvider extends ChangeNotifier {
  final List<ServerModel> _servers = AppConstants.freeServers;
  String? _activeServerId;

  List<ServerModel> get servers => List.unmodifiable(_servers);
  String? get activeServerId => _activeServerId;
  ServerModel? get activeServer => _activeServerId == null
      ? null
      : _servers.where((s) => s.id == _activeServerId).firstOrNull;

  void setActive(String? id) {
    _activeServerId = id;
    notifyListeners();
  }

  void clearActive() {
    _activeServerId = null;
    notifyListeners();
  }
}
