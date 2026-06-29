import 'package:frontfile_servease/core/services/app_config.dart';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AdminSecurityService {
  static String get _base => "${AppConfig.baseUrl}/api/admin";

  static Map<String, String> get _headers {
    final token = GetStorage().read('auth_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<List<Map<String, dynamic>>> fetchAll() async {
    try {
      final res = await http.get(
        Uri.parse("$_base/security-deposits"),
        headers: _headers,
      );
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
        headers: _headers,
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
        headers: _headers,
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
