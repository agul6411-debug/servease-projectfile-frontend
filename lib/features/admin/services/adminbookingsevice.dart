import 'package:frontfile_servease/core/services/app_config.dart';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AdminBookingsService {
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
        Uri.parse('$_base/bookings'),
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
}
