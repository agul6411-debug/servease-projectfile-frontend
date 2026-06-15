import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:frontfile_servease/models/providermodel/providermodelapi.dart';

class ProviderApiService {
  static const String baseUrl = "http://localhost:3000/api/providerside";

  static Map<String, String> get _headers => {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  // DASHBOARD STATS
  static Future<DashboardStats> fetchDashboardStats(int providerId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/dashboard/stats?provider_id=$providerId"),
        headers: _headers,
      );
      if (response.statusCode == 403) {
        throw Exception("ACCOUNT_BLOCKED");
      }
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
      return [];
    } catch (e) {
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
      return [];
    } catch (e) {
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
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/commission/submit"),
      );
      request.fields['provider_id'] = providerId.toString();
      request.fields['amount'] = amount.toString();
      request.fields['payment_method'] = paymentMethod;
      request.files.add(
        await http.MultipartFile.fromPath('screenshot', screenshotFile.path),
      );
      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  // ════════════════════════════════════════════════════════════════════════════

  // FETCH EARNINGS
  // EARNINGS
  static Future<EarningsSummary?> fetchEarnings(int providerId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/earnings?provider_id=$providerId"),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        return EarningsSummary.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
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
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/commission/submit"),
      );
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
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/security-deposit/submit"),
      );
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
      return 'pending';
    }
  }
}
