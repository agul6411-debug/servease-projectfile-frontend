import 'package:flutter/material.dart';
import 'package:projectfile/models/provider_model.dart';
import 'package:projectfile/services/provider_dashboard_service.dart';
import 'package:get/get.dart';
import 'jobs_screen.dart';
import 'earnings_screen.dart';
import 'profiles_screen.dart';

class ProviderHomeScreen extends StatefulWidget {
  const ProviderHomeScreen({super.key});

  @override
  State<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  // ── Colors (from screenshot) ──────────────────────────────────────────────
  static const Color _darkMaroon = Color(0xFF4A0E1A);
  static const Color _mediumMaroon = Color(0xFF6B1A28);
  static const Color _lightMaroon = Color(0xFFF9EEF0);
  static const Color _accentRed = Color(0xFFB5263A);
  static const Color _cardBg = Color(0xFFFFFFFF);
  static const Color _pendingYellow = Color(0xFFFFF3CD);
  static const Color _pendingYellowText = Color(0xFF856404);

  final ProviderDashboardService _service = ProviderDashboardService();
  ProviderDashboardModel? _dashboard;
  bool _isLoading = true;
  String? _errorMessage;

  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      final data = await _service.fetchDashboard();
      setState(() {
        _dashboard = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _handleAccept(String jobId) async {
    try {
      await _service.acceptJob(jobId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job accepted successfully!')),
      );
      _loadDashboard();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _handleReject(String jobId) async {
    try {
      await _service.rejectJob(jobId);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Job rejected.')));
      _loadDashboard();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightMaroon,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: _accentRed))
          : _errorMessage != null
          ? _buildErrorState()
          : _buildSelectedScreen(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSelectedScreen() {
    switch (_selectedNavIndex) {
      case 1:
        return const ProviderJobsScreen();
      case 2:
        return const ProviderEarningsScreen();
      case 3:
        return const ProviderProfileScreen();
      default:
        return _buildBody();
    }
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: _accentRed, size: 48),
          const SizedBox(height: 12),
          Text(
            _errorMessage ?? 'Something went wrong',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadDashboard,
            style: ElevatedButton.styleFrom(backgroundColor: _accentRed),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final d = _dashboard!;
    return RefreshIndicator(
      color: _accentRed,
      onRefresh: _loadDashboard,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(d),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsRow(d),
                  const SizedBox(height: 16),
                  _buildCommissionCard(d.commissionModel),
                  const SizedBox(height: 20),
                  _buildIncomingRequests(d.incomingRequests),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── HEADER ─────────────────────────────────────────────────────────────────
  Widget _buildHeader(ProviderDashboardModel d) {
    return Container(
      width: double.infinity,
      color: _darkMaroon,
      padding: const EdgeInsets.only(top: 52, left: 20, right: 20, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Provider Panel',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hello, ${d.providerName}!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _buildCnicBadge(d.isCnicVerified),
              ],
            ),
          ),
          // Avatar circle
          CircleAvatar(
            radius: 22,
            backgroundColor: _accentRed,
            child: Text(
              d.providerInitials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCnicBadge(bool isVerified) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isVerified ? const Color(0xFFD4EDDA) : const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(isVerified ? '✅' : '⏳', style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 6),
          Text(
            isVerified ? 'CNIC Verified' : 'Pending CNIC Verification',
            style: TextStyle(
              color: isVerified
                  ? const Color(0xFF155724)
                  : const Color(0xFF856404),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ── STATS ROW ──────────────────────────────────────────────────────────────
  Widget _buildStatsRow(ProviderDashboardModel d) {
    return Row(
      children: [
        _buildStatCard('📋', d.totalJobs.toString(), 'Total Jobs'),
        const SizedBox(width: 10),
        _buildStatCard('⏳', d.pendingJobs.toString(), 'Pending'),
        const SizedBox(width: 10),
        _buildStatCard('✅', d.doneJobs.toString(), 'Done'),
        const SizedBox(width: 10),
        _buildStatCard('💰', d.earned.toStringAsFixed(0), 'Earned'),
      ],
    );
  }

  Widget _buildStatCard(String emoji, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _darkMaroon,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ── COMMISSION CARD ────────────────────────────────────────────────────────
  Widget _buildCommissionCard(CommissionModel commission) {
    final freeJobs = commission.freeJobsCount;
    final rate = commission.commissionRate;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _mediumMaroon,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'COMMISSION MODEL',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Jobs 1–$freeJobs: Zero Commission',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Job ${freeJobs + 1}+: ${rate.toInt()}% Platform Fee',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              // Navigate to commission details page
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5B8C0),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text(
                'View Details',
                style: TextStyle(
                  color: _darkMaroon,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── INCOMING REQUESTS ──────────────────────────────────────────────────────
  Widget _buildIncomingRequests(List<IncomingRequest> requests) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'INCOMING REQUESTS',
          style: TextStyle(
            color: _darkMaroon,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 12),
        if (requests.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'No incoming requests at the moment.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          ...requests.map((req) => _buildRequestCard(req)),
      ],
    );
  }

  Widget _buildRequestCard(IncomingRequest req) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job ID + Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Job #${req.jobId}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: _darkMaroon,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _pendingYellow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  req.status,
                  style: const TextStyle(
                    color: _pendingYellowText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Customer name
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 13, color: Colors.black87),
              children: [
                const TextSpan(text: 'Customer: '),
                TextSpan(
                  text: req.customerName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _accentRed,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Date & Time
          Row(
            children: [
              const Text('📅', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 6),
              Text(
                '${req.scheduledDate} · ${req.scheduledTime}',
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Location
          Row(
            children: [
              const Text('📍', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 6),
              Text(
                req.location,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Amount + Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rs.${req.amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: _darkMaroon,
                ),
              ),
              Row(
                children: [
                  _buildActionButton(
                    label: 'Accept',
                    bg: const Color(0xFFF5B8C0),
                    textColor: _darkMaroon,
                    onTap: () => _handleAccept(req.jobId),
                  ),
                  const SizedBox(width: 10),
                  _buildActionButton(
                    label: 'Reject',
                    bg: Colors.white,
                    textColor: Colors.black87,
                    borderColor: Colors.grey.shade300,
                    onTap: () => _handleReject(req.jobId),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color bg,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24),
          border: borderColor != null ? Border.all(color: borderColor) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // ── BOTTOM NAV ─────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    const items = [
      {'icon': Icons.home, 'label': 'Home'},
      {'icon': Icons.list_alt, 'label': 'Jobs'},
      {'icon': Icons.account_balance_wallet, 'label': 'Earnings'},
      {'icon': Icons.person, 'label': 'Profile'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: _darkMaroon,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final isSelected = _selectedNavIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedNavIndex = i);

                switch (i) {
                  case 0:
                    break;

                  case 1:
                    Get.to(() => const ProviderJobsScreen());
                    break;

                  case 2:
                    Get.to(() => const ProviderEarningsScreen());
                    break;

                  case 3:
                    Get.to(() => const ProviderProfileScreen());
                    break;
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      items[i]['icon'] as IconData,
                      color: isSelected ? Colors.white : Colors.white54,
                      size: 22,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      items[i]['label'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white54,
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
