// lib/services/ip_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class IpService {
  static Future<String> fetchCurrentIp() async {
    try {
      final response = await http
          .get(Uri.parse(AppConstants.ipApiUrl))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['ip'] as String? ?? '—';
      }
      return '—';
    } catch (_) {
      return '—';
    }
  }
}
