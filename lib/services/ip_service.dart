import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/server_model.dart';
import '../utils/constants.dart';

class IpService {
  // Your original IP fetching logic
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

  // The new backend server fetching logic
  static Future<List<ServerModel>> fetchServers() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/servers/'),
        headers: {
          'X-Device-ID': AppConstants.dummyDeviceId,
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['data'];

        // Fix: Explicitly map and cast to List<ServerModel>
        return data
            .map((json) => ServerModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
