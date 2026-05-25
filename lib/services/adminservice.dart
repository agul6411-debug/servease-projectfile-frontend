import 'dart:convert';

import 'package:frontfile_servease/models/admin_dashboard_model.dart';
import 'package:frontfile_servease/screens/admin/admindashboard.dart';
import 'package:http/http.dart' as http;

class AdminService {
  static const String baseUrl = 'http://localhost:3000';

  Future<AdminDashboardModel?> getDashboardStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/admin/dashboard'),
        headers: {'Content-Type': 'application/json'},
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
