import 'package:flutter/material.dart';
import 'package:frontfile_servease/screens/admin/admindrawer.dart';
import 'package:frontfile_servease/screens/admin/admin_navbar.dart';
import 'package:frontfile_servease/services/admin_commission_service.dart';
import 'package:frontfile_servease/theme/app_theme.dart';

class AdminCommissionScreen extends StatefulWidget {
  const AdminCommissionScreen({super.key});

  @override
  State<AdminCommissionScreen> createState() => _AdminCommissionScreenState();
}

class _AdminCommissionScreenState extends State<AdminCommissionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  List<Map<String, dynamic>> _pending = [];
  List<Map<String, dynamic>> _verified = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final data = await AdminCommissionService.fetchAll();
    setState(() {
      _pending = data.where((d) => d['status'] == 'pending').toList();
      _verified = data.where((d) => d['status'] != 'pending').toList();
      _isLoading = false;
    });
  }

  Future<void> _verify(int id) async {
    await AdminCommissionService.verify(id);
    _load();
    _showSnack('Commission verified ✓', Colors.green);
  }

  Future<void> _reject(int id) async {
    await AdminCommissionService.reject(id);
    _load();
    _showSnack('Commission rejected', Colors.red);
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      drawer: const AdminDrawer(),
      bottomNavigationBar: const AdminBottomNavBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.success,
                      ),
                    )
                  : TabBarView(
                      controller: _tabCtrl,
                      children: [
                        _buildList(_pending, showActions: true),
                        _buildList(_verified, showActions: false),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B8B4B), Color(0xFF4CAF50)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      child: Row(
        children: [
          Builder(
            builder: (ctx) => GestureDetector(
              onTap: () => Scaffold.of(ctx).openDrawer(),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Icons.menu, color: Colors.white, size: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Commission Payments',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${_pending.length} pending verification',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${_pending.length} Pending',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TabBar(
        controller: _tabCtrl,
        labelColor: AppColors.success,
        unselectedLabelColor: AppColors.textMuted,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        indicator: BoxDecoration(
          color: AppColors.successBg,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.pending_outlined, size: 15),
                const SizedBox(width: 5),
                Text('Pending (${_pending.length})'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline, size: 15),
                const SizedBox(width: 5),
                Text('History (${_verified.length})'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
    List<Map<String, dynamic>> items, {
    required bool showActions,
  }) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 12),
            Text(
              showActions ? 'No pending payments' : 'No history yet',
              style: const TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      color: AppColors.success,
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 24),
        itemCount: items.length,
        itemBuilder: (_, i) => _CommissionCard(
          data: items[i],
          showActions: showActions,
          onVerify: () => _verify(items[i]['id']),
          onReject: () => _reject(items[i]['id']),
        ),
      ),
    );
  }
}

class _CommissionCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool showActions;
  final VoidCallback onVerify;
  final VoidCallback onReject;

  const _CommissionCard({
    required this.data,
    required this.showActions,
    required this.onVerify,
    required this.onReject,
  });

  Color get _statusColor {
    switch (data['status']) {
      case 'verified':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.successBg,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          (data['provider_name'] ?? '?')[0].toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['provider_name'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          data['payment_method'] ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    (data['status'] ?? 'pending').toString().toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 12),

            // Amount + Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Amount',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                    Text(
                      'RS ${data['amount']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Submitted',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                    Text(
                      data['created_at'] ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Screenshot
            if (data['screenshot'] != null) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _showScreenshot(context, data['screenshot']),
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.bgGrey,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      'http://localhost:3000/uploads/commission/${data['screenshot']}',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              color: AppColors.textMuted,
                              size: 32,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Tap to view screenshot',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],

            // Action buttons
            if (showActions) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onVerify,
                      icon: const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Verify',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onReject,
                      icon: const Icon(
                        Icons.close,
                        size: 16,
                        color: AppColors.declineRed,
                      ),
                      label: const Text(
                        'Reject',
                        style: TextStyle(color: AppColors.declineRed),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.declineRed),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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

  void _showScreenshot(BuildContext context, String filename) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            'http://localhost:3000/uploads/commission/$filename',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
