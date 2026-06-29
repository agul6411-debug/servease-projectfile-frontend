import 'dart:convert';
import 'package:frontfile_servease/core/services/app_config.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AdminSettingsService {
  static String get baseUrl => "${AppConfig.baseUrl}/api/admin/settings";

  static Map<String, String> get _headers {
    final token = GetStorage().read('auth_token') ?? '';
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
  }


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
