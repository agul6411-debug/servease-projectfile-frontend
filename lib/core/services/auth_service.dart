// ===============================
// auth_service.dart
// ===============================

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

class AuthService {
  // Android Emulator ke liye:
  static const String apiUrl = 'http://localhost:3000';

  // Flutter Web ke liye:
  // static const String apiUrl = 'http://localhost:3000';

  static final GetStorage box = GetStorage();

  // ===============================
  // LOGIN
  // ===============================
  static Future<Map<String, dynamic>> login(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        await box.write('token', data['token']);

        if (data['user'] != null) {
          await box.write('user', jsonEncode(data['user']));
        }

        return {
          'success': true,
          'message': data['message'] ?? 'Login Successful',
          'token': data['token'],
          'user': data['user'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login Failed',
        };
      }
    } catch (e) {
      debugPrint("Login Error: $e");

      return {
        'success': false,
        'message': 'Connection Error',
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

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return {
        'success': true,
        'message': data['message'],
      };
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Registration Failed',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Connection Error',
    };
  }
}
  // ===============================
  // PROVIDER REGISTER
  // ===============================
  static Future<Map<String, dynamic>> registerProvider(
  Map<String, dynamic> data,
) async {
  try {
    final response = await http.post(
      Uri.parse('$apiUrl/register/provider'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    final resData = jsonDecode(response.body);

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return {
        'success': true,
        'message': resData['message'],
      };
    } else {
      return {
        'success': false,
        'message': resData['message'] ?? 'Registration Failed',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Connection Error',
    };
  }
}

  // ===============================
  // LOGOUT
  // ===============================
  static Future<void> logout() async {
    await box.remove('token');
    await box.remove('user');
  }

  // ===============================
  // CHECK LOGIN
  // ===============================
  static bool isLoggedIn() {
    return box.read('token') != null;
  }

  static String? getToken() {
    return box.read('token');
  }

  static Map<String, dynamic>? getUser() {
    final user = box.read('user');

    if (user == null) return null;

    return jsonDecode(user);
  }
}