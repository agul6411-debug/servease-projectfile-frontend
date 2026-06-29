import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:frontfile_servease/routes.dart';
import 'package:frontfile_servease/features/admin/screens/admindrawer.dart';
import 'package:frontfile_servease/features/admin/screens/admin_navbar.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';
import 'package:frontfile_servease/core/services/app_config.dart';

class AdminComplaintsScreen extends StatefulWidget {
  const AdminComplaintsScreen({super.key});

  @override
  State<AdminComplaintsScreen> createState() => _AdminComplaintsScreenState();
}

class _AdminComplaintsScreenState extends State<AdminComplaintsScreen>
    with SingleTickerProviderStateMixin {
  static String get _base => "${AppConfig.baseUrl}/api/admin";


  late TabController _tabController;
  List<Map<String, dynamic>> _complaints = [];
  List<Map<String, dynamic>> _ratings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);
    await Future.wait([_loadComplaints(), _loadRatings()]);
    setState(() => _isLoading = false);
  }

  Future<void> _loadComplaints() async {
    try {
      final res = await http.get(Uri.parse("$_base/complaints"));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(
          () =>
              _complaints = List<Map<String, dynamic>>.from(data['data'] ?? []),
        );
      }
    } catch (e) {
      debugPrint('Complaints load error: $e');
    }
  }

  Future<void> _loadRatings() async {
    try {
      final res = await http.get(Uri.parse("$_base/ratings"));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(
          () => _ratings = List<Map<String, dynamic>>.from(data['data'] ?? []),
        );
      }
    } catch (e) {
      debugPrint('Ratings load error: $e');
    }
  }

  Future<void> _takeAction(int complaintId, String action) async {
    final responseCtrl = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          action == 'warn'
              ? 'Send Warning'
              : action == 'block'
              ? 'Block User'
              : 'Dismiss Complaint',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              action == 'block'
                  ? 'This user will be blocked and will not be able to log in.'
                  : action == 'warn'
                  ? 'User ko warning notification milegi.'
                  : 'The complaint will be dismissed. No action will be taken.',
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: responseCtrl,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Admin note (optional)',
                filled: true,
                fillColor: const Color(0xFFFFF8EF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: action == 'block'
                  ? Colors.red
                  : action == 'warn'
                  ? Colors.orange
                  : AppColors.primaryGreen,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final res = await http.put(
        Uri.parse("$_base/complaints/$complaintId/action"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "action": action,
          "admin_response": responseCtrl.text.trim().isEmpty
              ? null
              : responseCtrl.text.trim(),
        }),
      );

      if (res.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Action taken'),
              backgroundColor: AppColors.primaryGreen,
            ),
          );
        }
        _loadComplaints();

        // After blocking, navigate to blocked users page
        if (action == 'block') {
          Get.toNamed(AppRoutes.blockorunblock);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Action failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Action error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return Colors.deepOrange;
      case 'resolved':
        return AppColors.primaryGreen;
      case 'warned':
        return Colors.deepOrange;
      case 'blocked':
        return Colors.red;
      case 'dismissed':
        return Colors.grey;
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      drawer: const AdminDrawer(),
      bottomNavigationBar: const AdminBottomNavBar(),
      appBar: AppBar(
        title: const Text(
          'Complaints & Ratings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'Complaints (${_complaints.length})'),
            Tab(text: 'Ratings (${_ratings.length})'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadAll,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            )
          : TabBarView(
              controller: _tabController,
              children: [_buildComplaintsTab(), _buildRatingsTab()],
            ),
    );
  }

  Widget _buildComplaintsTab() {
    if (_complaints.isEmpty) {
      return Center(
        child: Text(
          'No complaints yet',
          style: TextStyle(color: Colors.grey.shade500),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _complaints.length,
      itemBuilder: (_, i) {
        final c = _complaints[i];
        final isBlocked = c['is_blocked'] == 1;
        final totalAgainst = c['total_complaints_against'] ?? 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      c['title'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(c['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      (c['status'] ?? '').toString().toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _statusColor(c['status']),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                c['message'] ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Filed by: ${c['complainant_name']} (${c['complainant_role']}) — Booking #${c['booking_id']}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 6),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Against: ${c['against_name']} (${c['against_role']})  •  Total: $totalAgainst${isBlocked ? '  •  BLOCKED' : ''}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ),

              if (c['admin_response'] != null) ...[
                const SizedBox(height: 6),
                Text(
                  'Admin note: ${c['admin_response']}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],

              const SizedBox(height: 10),

              if (c['status'] == 'pending')
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _takeAction(c['id'], 'dismiss'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade400),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: const Text(
                          'Dismiss',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _takeAction(c['id'], 'warn'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: const Text(
                          'Warn',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _takeAction(c['id'], 'block'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: const Text(
                          'Block',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),

              if (isBlocked)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'User Blocked — manage in Blocked Users section',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRatingsTab() {
    if (_ratings.isEmpty) {
      return Center(
        child: Text(
          'No ratings yet',
          style: TextStyle(color: Colors.grey.shade500),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _ratings.length,
      itemBuilder: (_, i) {
        final r = _ratings[i];
        final rating = r['rating'] ?? 0;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    r['provider_name'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textDark,
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (s) => Icon(
                        s < rating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 16,
                        color: AppColors.accentYellow,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'By: ${r['customer_name']}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              if (r['note'] != null && r['note'].toString().isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  r['note'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textDark,
                    height: 1.4,
                  ),
                ),
              ],
              const SizedBox(height: 6),
              Text(
                r['created_at'] ?? '',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
              ),
            ],
          ),
        );
      },
    );
  }
}
