import 'package:frontfile_servease/core/services/app_config.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ProviderProfileService {
  static String get _baseUrl => "${AppConfig.baseUrl}/api/providerside";

  static Map<String, String> get _headers {
    final token = GetStorage().read('auth_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // GET: Provider Profile
  static Future<Map<String, dynamic>?> getProfile(int providerId) async {
    try {
      final res = await http.get(
        Uri.parse("$_baseUrl/profile?provider_id=$providerId"),
        headers: _headers,
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
      debugPrint('getProfile failed: ${res.statusCode}');
      return null;
    } catch (e) {
      debugPrint('getProfile error: $e');
      return null;
    }
  }

  // PUT: Update Provider Profile
  static Future<bool> updateProfile({
    required int providerId,
    required String fullName,
    required String phone,
    required String address,
    required String bio,
    required int hourlyRate,
  }) async {
    try {
      final res = await http.put(
        Uri.parse("$_baseUrl/profile?provider_id=$providerId"),
        headers: _headers,
        body: jsonEncode({
          "full_name": fullName,
          "phone": phone,
          "address": address,
          "bio": bio,
          "hourly_rate": hourlyRate,
        }),
      );
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('updateProfile error: $e');
      return false;
    }
  }
}
