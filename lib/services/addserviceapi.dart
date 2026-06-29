import 'package:frontfile_servease/core/services/app_config.dart';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ServiceApiService {
  static String get _baseUrl => "${AppConfig.baseUrl}/api";

  static Map<String, String> get _headers {
    final token = GetStorage().read('auth_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // GET all services
  static Future<List<dynamic>> getServices() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/services'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is List) return body;
      if (body is Map && body['data'] is List) return body['data'] as List;
      return [];
    }
    throw Exception('Failed to load services: ${response.statusCode}');
  }

  // POST create service
  static Future<Map<String, dynamic>> createService({
    required String name,
    required String description,
    required int price,
    required String category,
    required String icon,
    required bool isActive,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/services'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'icon': icon,
        'is_active': isActive,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to create service: ${response.statusCode}');
  }

  // PUT update service
  static Future<Map<String, dynamic>> updateService({
    required int id,
    required String name,
    required String description,
    required int price,
    required String category,
    required String icon,
    required bool isActive,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/services/$id'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'icon': icon,
        'is_active': isActive,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to update service: ${response.statusCode}');
  }

  // PATCH toggle active status
  static Future<void> toggleActive({
    required int id,
    required bool isActive,
  }) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/services/$id/toggle'),
      headers: _headers,
      body: jsonEncode({'is_active': isActive}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to toggle service: ${response.statusCode}');
    }
  }

  // DELETE service
  static Future<void> deleteService(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/services/$id'),
      headers: _headers,
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete service: ${response.statusCode}');
    }
  }
}
