import 'package:frontfile_servease/core/services/app_config.dart';
import 'dart:convert';
import 'package:frontfile_servease/features/admin/models/all_user_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class UserService {
  static String get baseUrl => "${AppConfig.baseUrl}/api";

  static Map<String, String> get _headers {
    final token = GetStorage().read('auth_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // GET: All Active (non-blocked) Users
  static Future<List<UserModel>> getAllUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: _headers,
    );
    _checkStatus(response);
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => UserModel.fromJson(e)).toList();
  }

  // GET: Blocked Users
  static Future<List<UserModel>> getBlockedUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/blocked'),
      headers: _headers,
    );
    _checkStatus(response);
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => UserModel.fromJson(e)).toList();
  }

  // GET: Single User Detail
  static Future<UserModel> getUserById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$id'),
      headers: _headers,
    );
    _checkStatus(response);
    return UserModel.fromJson(jsonDecode(response.body));
  }

  // POST: Add New User
  static Future<UserModel> addUser({
    required String fullName,
    required String email,
    required String password,
    required String role,
    required String phone,
    required String cnic,
    required String address,
    String? profileImage,
  }) async {
    final body = jsonEncode({
      'full_name': fullName,
      'email': email,
      'password': password,
      'role': role,
      'phone': phone,
      'cnic': cnic,
      'address': address,
      'profile_image': null,
    });

    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: _headers,
      body: body,
    );
    _checkStatus(response);
    return UserModel.fromJson(jsonDecode(response.body));
  }

  // PATCH: Block a User
  static Future<void> blockUser(int id) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/users/$id/block'),
      headers: _headers,
    );
    _checkStatus(response);
  }

  // PATCH: Unblock a User
  static Future<void> unblockUser(int id) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/users/$id/unblock'),
      headers: _headers,
    );
    _checkStatus(response);
  }

  // Helper: Status Check
  static void _checkStatus(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      String message = 'Server Error (${response.statusCode})';
      try {
        final body = jsonDecode(response.body);
        if (body['message'] != null) message = body['message'];
      } catch (_) {}
      throw Exception(message);
    }
  }
}
