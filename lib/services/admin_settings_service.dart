import 'dart:convert';
import 'package:frontfile_servease/services/app_config.dart';
import 'package:http/http.dart' as http;

class AdminSettingsService {
  static String get baseUrl => "${AppConfig.baseUrl}/api/admin/settings";

  static Map<String, String> get _headers => {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  // GET Settings
  static Future<Map<String, dynamic>?> getSettings() async {
    try {
      final res = await http.get(Uri.parse(baseUrl), headers: _headers);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['settings'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // UPDATE Settings
  static Future<bool> updateSettings(Map<String, dynamic> settings) async {
    try {
      final res = await http.put(
        Uri.parse(baseUrl),
        headers: _headers,
        body: jsonEncode(settings),
      );
      final data = jsonDecode(res.body);
      return data['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
