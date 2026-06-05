import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projectfile/models/provider_model.dart';

class ProviderDashboardService {
  static const String _baseUrl = 'http://localhost:3000/api/provider';

  Future<ProviderDashboardModel> fetchDashboard() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/dashboard'));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return ProviderDashboardModel.fromJson(body);
      }
    } catch (_) {}

    return ProviderDashboardModel(
      providerName: 'Provider',
      providerInitials: 'PR',
      isCnicVerified: false,
      totalJobs: 0,
      pendingJobs: 0,
      doneJobs: 0,
      earned: 0.0,
      commissionModel: CommissionModel(
        description: 'No data',
        commissionRate: 0,
        freeJobsCount: 0,
      ),
      incomingRequests: [],
    );
  }

  Future<void> acceptJob(String jobId) async {
    try {
      await http.put(Uri.parse('$_baseUrl/jobs/$jobId/accept'));
    } catch (_) {
      rethrow;
    }
  }

  Future<void> rejectJob(String jobId) async {
    try {
      await http.put(Uri.parse('$_baseUrl/jobs/$jobId/reject'));
    } catch (_) {
      rethrow;
    }
  }
}
