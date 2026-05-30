import 'dart:convert';
import 'package:frontfile_servease/models/all_user_model.dart';
import 'package:http/http.dart' as http;

class UserService {
  // ✅ Apna base URL yahan set karein
  static const String baseUrl = 'http://localhost:3000/api';

  // ─── Headers ──────────────────────────────────────────────
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // 'Authorization': 'Bearer YOUR_TOKEN', // JWT use ho to uncomment karein
  };

  // ─── GET: All Active (non-blocked) Users ──────────────────
  static Future<List<UserModel>> getAllUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: _headers,
    );
    _checkStatus(response);
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => UserModel.fromJson(e)).toList();
  }

  // ─── GET: Blocked Users ───────────────────────────────────
  static Future<List<UserModel>> getBlockedUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/blocked'),
      headers: _headers,
    );
    _checkStatus(response);
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => UserModel.fromJson(e)).toList();
  }

  // ─── GET: Single User Detail ──────────────────────────────
  static Future<UserModel> getUserById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$id'),
      headers: _headers,
    );
    _checkStatus(response);
    return UserModel.fromJson(jsonDecode(response.body));
  }

  // ─── POST: Add New User (customer / provider) ─────────────
  static Future<UserModel> addUser({
    required String fullName,
    required String email,
    required String password,
    required String role, // 'customer' or 'provider'
    String? phone,
    String? cnic,
    String? address,
    String? profileImage,
  }) async {
    final body = jsonEncode({
      'full_name': fullName,
      'email': email,
      'password': password,
      'role': role,
      if (phone != null) 'phone': phone,
      if (cnic != null) 'cnic': cnic,
      if (address != null) 'address': address,
      if (profileImage != null) 'profile_image': profileImage,
    });

    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: _headers,
      body: body,
    );
    _checkStatus(response);
    return UserModel.fromJson(jsonDecode(response.body));
  }

  // ─── PATCH: Block a User ──────────────────────────────────
  static Future<void> blockUser(int id) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/users/$id/block'),
      headers: _headers,
    );
    _checkStatus(response);
  }

  // ─── PATCH: Unblock a User ────────────────────────────────
  static Future<void> unblockUser(int id) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/users/$id/unblock'),
      headers: _headers,
    );
    _checkStatus(response);
  }

  // ─── Helper: Status Check ─────────────────────────────────
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
