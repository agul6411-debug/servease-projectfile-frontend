import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api/auth';

  Future<Map<String, dynamic>> login(
    String email,
    String password,
    String role,
  ) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email.trim(),
          'password': password,
          'role': role,
        }),
      );

      print('LOGIN URL: $baseUrl/login');
      print('LOGIN STATUS: ${res.statusCode}');
      print('LOGIN BODY: ${res.body}');

      if (res.body.trim().startsWith('<')) {
        return {
          'success': false,
          'message': 'Server route not found (${res.statusCode})',
        };
      }

      final data = jsonDecode(res.body);

      if (res.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'message': data['message'] ?? 'Login successful',
          'token': data['token'],
          'user': data['user'],
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Login failed',
      };
    } catch (e) {
      print('LOGIN ERROR: $e');

      return {
        'success': false,
        'message': 'Login error: $e',
      };
    }
  }
}