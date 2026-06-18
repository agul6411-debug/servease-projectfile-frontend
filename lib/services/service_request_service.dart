import 'dart:convert';
import 'package:frontfile_servease/services/app_config.dart';
import 'package:http/http.dart' as http;

class ServiceRequestService {
  static String get baseUrl => "${AppConfig.baseUrl}/api";

  static Map<String, String> get _headers => {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  // Provider — Submit Custom Service Request
  static Future<Map<String, dynamic>> submitRequest({
    required String serviceName,
    required String category,
    String? customCategory,
    String? description,
    int yearsOfExperience = 0,
    int providerId = 0,
    String providerName = "",
    String providerEmail = "",
  }) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/service-requests"),
        headers: _headers,
        body: jsonEncode({
          'provider_id': providerId,
          'provider_name': providerName,
          'provider_email': providerEmail,
          'service_name': serviceName,
          'category': category,
          'custom_category': customCategory,
          'description': description ?? '',
          'years_of_experience': yearsOfExperience,
        }),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error'};
    }
  }

  // Admin — Get All Requests
  static Future<List<Map<String, dynamic>>> getRequests({String? status}) async {
    try {
      final url = status != null
          ? "$baseUrl/admin/service-requests?status=$status"
          : "$baseUrl/admin/service-requests";
      final res = await http.get(Uri.parse(url), headers: _headers);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Admin — Pending Count
  static Future<int> getPendingCount() async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/admin/service-requests/pending-count"),
        headers: _headers,
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['count'] ?? 0;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  // Admin — Approve Request
  static Future<Map<String, dynamic>> approveRequest({
    required int requestId,
    double price = 0,
    String icon = "🔧",
    String adminNote = "Approved",
  }) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/admin/service-requests/$requestId/approve"),
        headers: _headers,
        body: jsonEncode({
          'price': price,
          'icon': icon,
          'admin_note': adminNote,
        }),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error'};
    }
  }

  // Admin — Reject Request
  static Future<Map<String, dynamic>> rejectRequest({
    required int requestId,
    String adminNote = "Rejected",
  }) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/admin/service-requests/$requestId/reject"),
        headers: _headers,
        body: jsonEncode({'admin_note': adminNote}),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error'};
    }
  }
}
