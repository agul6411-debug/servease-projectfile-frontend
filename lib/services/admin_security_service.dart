import 'package:frontfile_servease/services/app_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminSecurityService {
  static String get _base => "${AppConfig.baseUrl}/api/admin";

  static Future<List<Map<String, dynamic>>> fetchAll() async {
    try {
      final res = await http.get(Uri.parse("$_base/security-deposits"));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> verify(int providerId) async {
    try {
      final res = await http.put(
        Uri.parse("$_base/security-deposits/$providerId/verify"),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> reject(int providerId) async {
    try {
      final res = await http.put(
        Uri.parse("$_base/security-deposits/$providerId/reject"),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
