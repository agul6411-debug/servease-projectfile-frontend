import 'dart:convert';

import 'package:frontfile_servease/models/provider_verification_model.dart';
import 'package:http/http.dart' as http;

class ProviderVerificationService {
  static const String baseUrl = "http://localhost:3000/api/admin";

  // GET PENDING PROVIDERS
  Future<List<ProviderVerificationModel>> getPendingProviders() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/providers/pending"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List providers = data["data"];

        return providers
            .map((e) => ProviderVerificationModel.fromJson(e))
            .toList();
      }

      return [];
    } catch (e) {
      print(e);

      return [];
    }
  }

  // APPROVE
  Future<bool> approveProvider(int id) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/providers/approve/$id"),
      );

      return response.statusCode == 200;
    } catch (e) {
      print(e);

      return false;
    }
  }

  // REJECT
  Future<bool> rejectProvider(int id) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/providers/reject/$id"),
      );

      return response.statusCode == 200;
    } catch (e) {
      print(e);

      return false;
    }
  }
}
