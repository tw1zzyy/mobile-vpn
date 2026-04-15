import 'package:flutter/material.dart';
import '../models/server_model.dart';
import '../services/ip_service.dart'; // Use the correct name here

class ServerProvider extends ChangeNotifier {
  List<ServerModel> _servers = [];
  ServerModel? _activeServer; // Tracks the selected server
  bool _isLoading = false;

  List<ServerModel> get servers => _servers;
  ServerModel? get activeServer => _activeServer; // Fixes 'activeServer' error
  bool get isLoading => _isLoading;
  // Add this line right below your other getters:
  String? get activeServerId => _activeServer?.id;

  Future<void> loadServers() async {
    _isLoading = true;
    notifyListeners();
    _servers = await IpService.fetchServers();
    _isLoading = false;
    notifyListeners();
  }

  // Fixes 'setActive' error
  void setActive(ServerModel server) {
    _activeServer = server;
    notifyListeners();
  }

  // Fixes 'clearActive' error
  void clearActive() {
    _activeServer = null;
    notifyListeners();
  }
}
