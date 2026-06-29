import 'package:frontfile_servease/core/services/app_config.dart';
import 'dart:convert';
import 'package:frontfile_servease/features/provider/models/provider_verification_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ProviderVerificationService {
  static String get _baseUrl => "${AppConfig.baseUrl}/api/admin";

  static Map<String, String> get _headers {
    final token = GetStorage().read('auth_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<ProviderVerificationModel>> getPendingProviders() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/providers/pending'),
      headers: _headers,
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 && body['success'] == true) {
      return (body['data'] as List)
          .map((e) => ProviderVerificationModel.fromJson(e))
          .toList();
    }
    throw Exception(body['message'] ?? 'Failed to fetch providers');
  }

  Future<void> approveProvider(int userId) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/providers/approve/$userId'),
      headers: _headers,
    );
    final body = jsonDecode(response.body);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message'] ?? 'Failed to approve provider');
    }
  }

  Future<void> rejectProvider(int userId) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/providers/reject/$userId'),
      headers: _headers,
    );
    final body = jsonDecode(response.body);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message'] ?? 'Failed to reject provider');
    }
  }
}
