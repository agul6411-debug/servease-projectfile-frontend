import 'package:frontfile_servease/core/services/app_config.dart';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

import 'package:frontfile_servease/features/admin/models/admin_dashboard_model.dart';
import 'package:http/http.dart' as http;

class AdminService {
  static const String baseUrl = AppConfig.baseUrl;

  Future<AdminDashboardModel?> getDashboardStats() async {
    try {
      final token = GetStorage().read('auth_token') ?? '';
      final response = await http.get(
        Uri.parse('$baseUrl/api/admin/dashboard'),
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AdminDashboardModel.fromJson(data);
      }

      return null;
    } catch (e) {
      print('Dashboard Error: $e');
      return null;
    }
  }
}
