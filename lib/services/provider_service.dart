// provider_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProviderService {
  static const String baseUrl = 'http://localhost:3000/register/providers';

  // =========================
  // CREATE  →  POST /providers
  // =========================
  static Future<Map<String, dynamic>> createProvider({
    required String name,
    required String profession,
    required String providerId,
    required String phone,
    required String location,
    required String submitted,
    required String status,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'profession': profession,
        'provider_id': providerId,
        'phone': phone,
        'location': location,
        'submitted': submitted,
        'status': status,
      }),
    );
    return jsonDecode(response.body);
  }

  // =========================
  // READ  →  GET /providers
  // =========================
  static Future<List<dynamic>> getProviders() async {
    final response = await http.get(Uri.parse(baseUrl));
    return jsonDecode(response.body);
  }

  // =========================
  // UPDATE  →  PUT /providers/:id
  // =========================
  static Future<Map<String, dynamic>> updateProvider({
    required int id,
    required String name,
    required String profession,
    required String providerId,
    required String phone,
    required String location,
    required String submitted,
    required String status,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'profession': profession,
        'provider_id': providerId,
        'phone': phone,
        'location': location,
        'submitted': submitted,
        'status': status,
      }),
    );
    return jsonDecode(response.body);
  }

  // =========================
  // DELETE  →  DELETE /providers/:id
  // =========================
  static Future<Map<String, dynamic>> deleteProvider(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    return jsonDecode(response.body);
  }

  Future<Object?> registerProvider(Map<String, Object?> map) async {}
}
