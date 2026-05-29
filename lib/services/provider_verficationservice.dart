import 'dart:convert';
import 'package:frontfile_servease/models/provider_verification_model.dart';
import 'package:http/http.dart' as http;

class ProviderVerificationService {
  static const String _baseUrl =
      'http://localhost:3000/api/admin'; // Replace with your base URL

  Future<List<ProviderVerificationModel>> getPendingProviders() async {
    final response = await http.get(Uri.parse('$_baseUrl/providers/pending'));
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
    );
    final body = jsonDecode(response.body);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message'] ?? 'Failed to approve provider');
    }
  }

  Future<void> rejectProvider(int userId) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/providers/reject/$userId'),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message'] ?? 'Failed to reject provider');
    }
  }
}
