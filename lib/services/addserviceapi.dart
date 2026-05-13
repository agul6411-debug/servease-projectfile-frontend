// service_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ServiceService {
  static const String baseUrl = 'http://localhost:3000/services';

  // =========================
  // CREATE  →  POST /services
  // =========================
  static Future<Map<String, dynamic>> createService({
    required String name,
    required String description,
    required int price,
    required String category,
    required String icon,
    required bool isActive,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'icon': icon,
        'is_active': isActive ? 1 : 0,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Create failed: ${response.statusCode}');
    }
    return jsonDecode(response.body);
  }

  // =========================
  // READ  →  GET /services
  // =========================
  static Future<List<dynamic>> getServices() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode != 200) {
      throw Exception('Fetch failed: ${response.statusCode}');
    }
    return jsonDecode(response.body);
  }

  // =========================
  // UPDATE  →  PUT /services/:id
  // =========================
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
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'icon': icon,
        'is_active': isActive ? 1 : 0,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Update failed: ${response.statusCode}');
    }
    return jsonDecode(response.body);
  }

  // =========================
  // DELETE  →  DELETE /services/:id
  // =========================
  static Future<Map<String, dynamic>> deleteService(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Delete failed: ${response.statusCode}');
    }
    return jsonDecode(response.body);
  }

  // =========================
  // TOGGLE ACTIVE  →  PUT /services/:id/toggle
  // (or reuse updateService — depends on your backend)
  // =========================
  static Future<Map<String, dynamic>> toggleActive({
    required int id,
    required bool isActive,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id/toggle'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'is_active': isActive ? 1 : 0}),
    );

    if (response.statusCode != 200) {
      throw Exception('Toggle failed: ${response.statusCode}');
    }
    return jsonDecode(response.body);
  }
}
