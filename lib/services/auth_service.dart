import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String apiUrl = 'http://localhost:3000/api/auth';

  // ===============================
  // LOGIN
  // ===============================
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // ===============================
  // CUSTOMER REGISTER
  // ===============================
  static Future<Map<String, dynamic>> registerCustomer(
    Map<String, dynamic> userData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/register/customer'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userData),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // ===============================
  // PROVIDER REGISTER
  // ===============================
  static Future<Map<String, dynamic>> registerProvider(
    Map<String, dynamic> userData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/register/provider'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userData),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
}