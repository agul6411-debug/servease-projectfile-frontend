import 'package:frontfile_servease/core/services/app_config.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ProviderSideService {
  static String get baseUrl => "${AppConfig.baseUrl}/api/providerside";

  static Map<String, String> get _headers {
    final token = GetStorage().read('auth_token') ?? '';
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  static Future<Map<String, dynamic>?> fetchData(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/$endpoint"),
        headers: _headers,
      );
      if (response.statusCode == 200) return jsonDecode(response.body);
      debugPrint(
        'ProviderSideService.fetchData failed: ${response.statusCode}',
      );
      return null;
    } catch (e) {
      debugPrint('ProviderSideService.fetchData error: $e');
      return null;
    }
  }
}
