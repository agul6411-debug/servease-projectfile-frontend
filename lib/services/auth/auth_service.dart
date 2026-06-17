import 'dart:convert';
import 'package:frontfile_servease/services/app_config.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static String get baseUrl => "${AppConfig.baseUrl}/api/auth";

  static Map<String, String> get _headers => {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  // ── Send OTP (Registration) ──────────────────────────
  static Future<Map<String, dynamic>> sendOtp({
    required String email,
    required String fullName,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/send-otp"),
        headers: _headers,
        body: jsonEncode({"email": email, "full_name": fullName}),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {"success": false, "message": "Network error"};
    }
  }

  // ── Verify OTP ───────────────────────────────────────
  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/verify-otp"),
        headers: _headers,
        body: jsonEncode({"email": email, "otp": otp}),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {"success": false, "message": "Network error"};
    }
  }

  // ── Forgot Password (Send reset link) ───────────────
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/forgot-password"),
        headers: _headers,
        body: jsonEncode({"email": email}),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {"success": false, "message": "Network error"};
    }
  }

  // ── Reset Password ────────────────────────────────────
  static Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/reset-password"),
        headers: _headers,
        body: jsonEncode({"token": token, "new_password": newPassword}),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {"success": false, "message": "Network error"};
    }
  }

  // ── Verify Reset Token ────────────────────────────────
  static Future<Map<String, dynamic>> verifyResetToken(String token) async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/verify-reset-token?token=$token"),
        headers: _headers,
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {"success": false, "valid": false, "message": "Network error"};
    }
  }
}
