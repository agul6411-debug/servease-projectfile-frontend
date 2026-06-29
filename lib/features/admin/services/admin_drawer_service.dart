import 'package:frontfile_servease/core/services/app_config.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:frontfile_servease/features/admin/models/admin_drawer_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AdminDrawerService {
  String get baseUrl => "${AppConfig.baseUrl}/api/admin/dashboard";

  static Map<String, String> get _headers {
    final token = GetStorage().read('auth_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<AdminDrawerModel?> getDrawerData() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: _headers,
      );


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AdminDrawerModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('AdminDrawerService error: $e');
      return null;
    }
  }
}
