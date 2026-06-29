import 'package:flutter/material.dart';
import 'package:frontfile_servease/services/service_request_service.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';
import 'package:frontfile_servease/features/admin/screens/admin_navbar.dart';

class AdminServiceRequestsScreen extends StatefulWidget {
  const AdminServiceRequestsScreen({super.key});

  @override
  State<AdminServiceRequestsScreen> createState() =>
      _AdminServiceRequestsScreenState();
}

class _AdminServiceRequestsScreenState extends State<AdminServiceRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _pending = [];
  List<Map<String, dynamic>> _approved = [];
  List<Map<String, dynamic>> _rejected = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final all = await ServiceRequestService.getRequests();
    setState(() {
      _pending = all.where((r) => r['status'] == 'pending').toList();
      _approved = all.where((r) => r['status'] == 'approved').toList();
      _rejected = all.where((r) => r['status'] == 'rejected').toList();
      _isLoading = false;
    });
  }

  void _showApproveDialog(Map<String, dynamic> request) {
    final priceCtrl = TextEditingController();
    final iconCtrl = TextEditingController(text: '🔧');
    final noteCtrl = TextEditingController(text: 'Approved');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green),
            const SizedBox(width: 8),
            const Text('Approve Service', style: TextStyle(fontSize: 16)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Service: ${request['service_name']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'By: ${request['provider_name'] ?? 'Unknown'}',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 16),
              _dialogField(
                'Price (Rs.)',
                priceCtrl,
                keyboardType: TextInputType.number,
                hint: 'e.g. 500',
              ),
              const SizedBox(height: 10),
              _dialogField('Icon (Emoji)', iconCtrl, hint: '🔧'),
              const SizedBox(height: 10),
              _dialogField('Admin Note', noteCtrl, hint: 'Approved'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final result = await ServiceRequestService.approveRequest(
                requestId: request['id'],
                price: double.tryParse(priceCtrl.text) ?? 0,
                icon: iconCtrl.text.trim().isEmpty
                    ? '🔧'
                    : iconCtrl.text.trim(),
                adminNote: noteCtrl.text.trim(),
              );
              _showSnack(
                result['success'] == true
                    ? '✅ Service approved & added!'
                    : result['message'] ?? 'Failed',
                result['success'] == true ? Colors.green : Colors.red,
              );
              if (result['success'] == true) _loadData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(Map<String, dynamic> request) {
    final noteCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.cancel_outlined, color: Colors.red),
            const SizedBox(width: 8),
            const Text('Reject Service', style: TextStyle(fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Service: ${request['service_name']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _dialogField(
              'Reason for rejection',
              noteCtrl,
              hint: 'e.g. Service already exists...',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final result = await ServiceRequestService.rejectRequest(
                requestId: request['id'],
                adminNote: noteCtrl.text.trim().isEmpty
                    ? 'Rejected'
                    : noteCtrl.text.trim(),
              );
              _showSnack(
                result['success'] == true ? 'Request rejected' : 'Failed',
                result['success'] == true ? Colors.orange : Colors.red,
              );
              if (result['success'] == true) _loadData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _dialogField(
    String label,
    TextEditingController ctrl, {
    String? hint,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
            filled: true,
            fillColor: const Color(0xFFFFF8EF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Row(
          children: [
            const Text(
              'Service Requests',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_pending.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_pending.length}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadData,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: [
            Tab(text: 'Pending (${_pending.length})'),
            Tab(text: 'Approved (${_approved.length})'),
            Tab(text: 'Rejected (${_rejected.length})'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildList(_pending, showActions: true),
                _buildList(_approved),
                _buildList(_rejected),
              ],
            ),
      bottomNavigationBar: const AdminBottomNavBar(),
    );
  }

  Widget _buildList(
    List<Map<String, dynamic>> list, {
    bool showActions = false,
  }) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'No requests found',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (ctx, i) => _buildCard(list[i], showActions: showActions),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> request, {bool showActions = false}) {
    final status = request['status'] as String;
    final statusColor = status == 'approved'
        ? Colors.green
        : status == 'rejected'
        ? Colors.red
        : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text('🔧', style: TextStyle(fontSize: 22)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request['service_name'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        request['custom_category'] ?? request['category'] ?? '',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Provider Info
            _infoRow(
              Icons.person_outline,
              'Provider',
              request['provider_name'] ?? 'Unknown',
            ),
            const SizedBox(height: 6),
            _infoRow(
              Icons.email_outlined,
              'Email',
              request['provider_email'] ?? '-',
            ),
            const SizedBox(height: 6),
            _infoRow(
              Icons.access_time_outlined,
              'Experience',
              '${request['years_of_experience'] ?? 0} years',
            ),

            if (request['description'] != null &&
                request['description'].toString().isNotEmpty) ...[
              const SizedBox(height: 6),
              _infoRow(
                Icons.notes_outlined,
                'Description',
                request['description'],
              ),
            ],

            if (request['admin_note'] != null &&
                request['admin_note'].toString().isNotEmpty) ...[
              const SizedBox(height: 6),
              _infoRow(
                Icons.admin_panel_settings_outlined,
                'Admin Note',
                request['admin_note'],
                color: statusColor,
              ),
            ],

            // Action buttons
            if (showActions) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showRejectDialog(request),
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showApproveDialog(request),
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Approve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, {Color? color}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: color ?? Colors.grey.shade500),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: color ?? const Color(0xFF2D2A24),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
