import 'package:frontfile_servease/core/services/app_config.dart';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AdminCommissionService {
  static String get _base => "${AppConfig.baseUrl}/api/admin";

  static Map<String, String> get _headers {
    final token = GetStorage().read('auth_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // GET all commission payments
  static Future<List<Map<String, dynamic>>> fetchAll() async {
    try {
      final res = await http.get(
        Uri.parse('$_base/commissions'),
        headers: _headers,
      );
      if (res.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(res.body));
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // PUT verify
  static Future<bool> verify(int id) async {
    try {
      final res = await http.put(
        Uri.parse('$_base/commissions/$id/verify'),
        headers: _headers,
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // PUT reject
  static Future<bool> reject(int id) async {
    try {
      final res = await http.put(
        Uri.parse('$_base/commissions/$id/reject'),
        headers: _headers,
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
