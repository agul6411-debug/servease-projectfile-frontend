import 'package:frontfile_servease/core/services/app_config.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/acceptance_model.dart';

class AcceptanceService {
  static String get baseUrl => "${AppConfig.baseUrl}/api/admin/providers";

  Future<List<AcceptanceModel>> getAcceptanceList() async {
    try {
      final token = GetStorage().read('auth_token') ?? '';
      final response = await http.get(
        Uri.parse("$baseUrl/acceptance-list"),
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List list = data['data'];
        return list.map((e) => AcceptanceModel.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      debugPrint('AcceptanceService error: $e');
      return [];
    }
  }

  Future<bool> deleteProvider(int id) async {
    try {
      final token = GetStorage().read('auth_token') ?? '';
      final response = await http.delete(
        Uri.parse("$baseUrl/remove-account/$id"),
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('deleteProvider error: $e');
      return false;
    }
  }
}
