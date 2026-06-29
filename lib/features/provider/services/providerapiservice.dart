import 'package:frontfile_servease/core/services/app_config.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:frontfile_servease/models/providermodel/providermodelapi.dart';

class ProviderApiService {
  static String get baseUrl => "${AppConfig.baseUrl}/api/providerside";

  static Map<String, String> get _headers {
    final token = GetStorage().read('auth_token') ?? '';
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  // DASHBOARD STATS
  static Future<DashboardStats> fetchDashboardStats(int providerId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/dashboard/stats?provider_id=$providerId"),
        headers: _headers,
      );
      if (response.statusCode == 403) throw Exception("ACCOUNT_BLOCKED");
      if (response.statusCode == 200)
        return DashboardStats.fromJson(jsonDecode(response.body));
      throw Exception("Failed to load dashboard stats");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // NEW JOB REQUESTS
  static Future<List<JobRequest>> fetchNewJobRequests(int providerId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/jobs/new?provider_id=$providerId"),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => JobRequest.fromJson(e)).toList();
      }
      debugPrint('fetchNewJobRequests failed: ${response.statusCode}');
      return [];
    } catch (e) {
      debugPrint('fetchNewJobRequests error: $e');
      return [];
    }
  }

  // ALL JOBS (My Jobs page)
  static Future<List<JobRequest>> fetchAllJobs(int providerId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/jobs/all?provider_id=$providerId"),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => JobRequest.fromJson(e)).toList();
      }
      debugPrint('fetchAllJobs failed: ${response.statusCode}');
      return [];
    } catch (e) {
      debugPrint('fetchAllJobs error: $e');
      return [];
    }
  }

  // ACCEPT JOB
  static Future<Map<String, dynamic>> acceptJob(int jobId) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/jobs/$jobId/accept"),
        headers: _headers,
      );
      final body = jsonDecode(response.body);
      return {'success': response.statusCode == 200, ...body};
    } catch (e) {
      debugPrint('acceptJob error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // DECLINE JOB
  static Future<bool> declineJob(int jobId) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/jobs/$jobId/decline"),
        headers: _headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('declineJob error: $e');
      return false;
    }
  }

  // UPDATE JOB STATUS
  static Future<bool> updateJobStatus(int jobId, String status) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/jobs/$jobId/status"),
        headers: _headers,
        body: jsonEncode({"status": status}),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('updateJobStatus error: $e');
      return false;
    }
  }

  // SUBMIT COMMISSION
  static Future<bool> submitCommission({
    required int providerId,
    required double amount,
    required String paymentMethod,
    required File screenshotFile,
  }) async {
    try {
      final token = GetStorage().read('auth_token') ?? '';
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/commission/submit"),
      );
      if (token.isNotEmpty) request.headers['Authorization'] = 'Bearer $token';
      request.fields['provider_id'] = providerId.toString();
      request.fields['amount'] = amount.toString();
      request.fields['payment_method'] = paymentMethod;
      request.files.add(
        await http.MultipartFile.fromPath('screenshot', screenshotFile.path),
      );
      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('submitCommission error: $e');
      return false;
    }
  }

  // FETCH EARNINGS
  static Future<EarningsSummary?> fetchEarnings(int providerId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/earnings?provider_id=$providerId"),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        return EarningsSummary.fromJson(jsonDecode(response.body));
      }
      debugPrint('fetchEarnings failed: ${response.statusCode}');
      return null;
    } catch (e) {
      debugPrint('fetchEarnings error: $e');
      return null;
    }
  }

  // SUBMIT COMMISSION (Web compatible)
  static Future<bool> submitCommissionWeb({
    required int providerId,
    required double amount,
    required String paymentMethod,
    required Uint8List screenshotBytes,
    required String screenshotName,
  }) async {
    try {
      final token = GetStorage().read('auth_token') ?? '';
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/commission/submit"),
      );
      if (token.isNotEmpty) request.headers['Authorization'] = 'Bearer $token';
      request.fields['provider_id'] = providerId.toString();
      request.fields['amount'] = amount.toString();
      request.fields['payment_method'] = paymentMethod;
      request.files.add(
        http.MultipartFile.fromBytes(
          'screenshot',
          screenshotBytes,
          filename: screenshotName,
        ),
      );
      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('submitCommissionWeb error: $e');
      return false;
    }
  }

  // GET NOTIFICATIONS
  static Future<List<Map<String, dynamic>>> fetchNotifications(
    int providerId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/notifications?provider_id=$providerId"),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      }
      return [];
    } catch (e) {
      debugPrint('fetchNotifications error: $e');
      return [];
    }
  }

  // MARK NOTIFICATION AS READ
  static Future<bool> markNotificationRead(int notifId) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/notifications/$notifId/read"),
        headers: _headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('markNotificationRead error: $e');
      return false;
    }
  }

  // CLEAR ALL NOTIFICATIONS
  static Future<bool> clearNotifications(int providerId) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/notifications/clear?provider_id=$providerId"),
        headers: _headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('clearNotifications error: $e');
      return false;
    }
  }

  // SUBMIT COMPLAINT (against customer)
  static Future<bool> submitComplaint({
    required int providerId,
    required int bookingId,
    required String title,
    required String message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/complaints"),
        headers: _headers,
        body: jsonEncode({
          'provider_id': providerId,
          'booking_id': bookingId,
          'title': title,
          'message': message,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('submitComplaint error: $e');
      return false;
    }
  }

  // SECURITY DEPOSIT — SUBMIT
  static Future<bool> submitSecurityDeposit({
    required int providerId,
    required String paymentMethod,
    required Uint8List screenshotBytes,
    required String screenshotName,
  }) async {
    try {
      final token = GetStorage().read('auth_token') ?? '';
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/security-deposit/submit"),
      );
      if (token.isNotEmpty) request.headers['Authorization'] = 'Bearer $token';
      request.fields['provider_id'] = providerId.toString();
      request.fields['payment_method'] = paymentMethod;
      request.files.add(
        http.MultipartFile.fromBytes(
          'screenshot',
          screenshotBytes,
          filename: screenshotName,
        ),
      );
      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('submitSecurityDeposit error: $e');
      return false;
    }
  }

  // SECURITY DEPOSIT — STATUS
  static Future<String> getSecurityDepositStatus(int providerId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/security-deposit/status?provider_id=$providerId"),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] ?? 'pending';
      }
      return 'pending';
    } catch (e) {
      debugPrint('getSecurityDepositStatus error: $e');
      return 'pending';
    }
  }

  // CHANGE PASSWORD
  static Future<Map<String, dynamic>> changePassword({
    required int providerId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/profile/change-password"),
        headers: _headers,
        body: jsonEncode({
          'provider_id': providerId,
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );
      final data = jsonDecode(res.body);
      return {
        'success': res.statusCode == 200,
        'message': data['message'] ?? '',
      };
    } catch (e) {
      debugPrint('changePassword error: $e');
      return {'success': false, 'message': 'Server error'};
    }
  }

  // FORGOT PASSWORD
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final res = await http.post(
        Uri.parse("${AppConfig.baseUrl}/api/auth/forgot-password"),
        headers: _headers,
        body: jsonEncode({'email': email}),
      );
      final data = jsonDecode(res.body);
      return {
        'success': res.statusCode == 200,
        'message': data['message'] ?? '',
      };
    } catch (e) {
      debugPrint('forgotPassword error: $e');
      return {'success': false, 'message': 'Server error'};
    }
  }
}
