import 'package:frontfile_servease/services/app_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminCommissionService {
  static String get _base => "${AppConfig.baseUrl}/api/admin";

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

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
