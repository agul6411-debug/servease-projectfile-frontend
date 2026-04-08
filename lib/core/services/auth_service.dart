import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

class AuthService {
  static const String apiUrl = 'https://wholesaleapp.sandbox.pk/api';
  static final GetStorage box = GetStorage();

  /// Login user with email and password
  /// Returns true if successful, stores token in storage
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final body = jsonEncode({'email': email, 'password': password});

      final response = await http.post(
        Uri.parse('$apiUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          // Store token in local storage
          box.write('token', data['token']);
          // Store user data if available
          if (data['user'] != null) {
            box.write('user', data['user']);
          }
          return {
            'success': true,
            'message': 'Login successful',
            'token': data['token'],
            'user': data['user'],
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Login failed',
          };
        }
      } else {
        return {'success': false, 'message': 'Login failed. Please try again.'};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
        'error': e.toString(),
      };
    }
  }

  /// Register user with provided data
  static Future<Map<String, dynamic>> register(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'message': responseData['message'] ?? 'Registration successful',
          'data': responseData,
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred during registration: $e',
        'error': e.toString(),
      };
    }
  }

  /// Logout user and clear stored data
  static Future<void> logout() async {
    try {
      // Optional: Call API logout endpoint if it exists
      final token = box.read('token');
      if (token != null) {
        await http.post(
          Uri.parse('$apiUrl/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }
    } catch (e) {
      debugPrint('Logout API call failed: $e');
    } finally {
      // Clear all stored data
      await box.remove('token');
      await box.remove('user');
    }
  }

  /// Get stored authentication token
  static String? getToken() {
    return box.read('token');
  }

  /// Get stored user data
  static Map<String, dynamic>? getUser() {
    return box.read('user');
  }

  /// Check if user is logged in
  static bool isLoggedIn() {
    return getToken() != null;
  }

  /// Get authentication headers for API requests
  static Map<String, String> getAuthHeaders() {
    final token = getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Verify token is still valid (optional API call)
  static Future<bool> verifyToken() async {
    final token = getToken();
    if (token == null) return false;

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/verify-token'),
        headers: getAuthHeaders(),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
