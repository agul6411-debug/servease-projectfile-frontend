import 'package:frontfile_servease/services/app_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminBookingsService {
  static String get _base => "${AppConfig.baseUrl}/api/admin";

  static Future<List<Map<String, dynamic>>> fetchAll() async {
    try {
      final res = await http.get(Uri.parse('$_base/bookings'));
      if (res.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(res.body));
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
