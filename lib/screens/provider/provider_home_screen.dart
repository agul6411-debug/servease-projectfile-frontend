import 'package:flutter/material.dart';
import 'package:frontfile_servease/models/providermodel/providermodelapi.dart';
import 'package:frontfile_servease/routes.dart';
import 'package:frontfile_servease/screens/provider/earningscreen.dart';
import 'package:frontfile_servease/screens/provider/pay_commission_screen.dart';
import 'package:frontfile_servease/screens/provider/provider_profile_screen.dart';
import 'package:frontfile_servease/screens/provider/provider_notifications_screen.dart';
import 'package:frontfile_servease/screens/provider/providernavbar.dart';
import 'package:frontfile_servease/screens/provider/my_jobs_screen.dart';
import 'package:frontfile_servease/services/providerapiservices/providerapiservice.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:async';
import 'package:frontfile_servease/screens/provider/security_deposit_screen.dart';

class ProviderHomeScreen extends StatefulWidget {
  final int providerId;

  const ProviderHomeScreen({super.key, required this.providerId});

  @override
  State<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  final box = GetStorage();
  DashboardStats? _stats;
  List<JobRequest> _jobRequests = [];
  bool _isLoading = true;
  String? _error;
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    _startSecurityDepositTimer();
  }

  void _startSecurityDepositTimer() {
    Timer(const Duration(seconds: 5), () async {
      if (!mounted) return;
      final status = await ProviderApiService.getSecurityDepositStatus(
        widget.providerId,
      );
      if (status == 'pending' && mounted) {
        _showSecurityDepositReminder();
      }
    });
  }

  void _showSecurityDepositReminder() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        title: const Text('Security Deposit Required'),
        content: const Text(
          'Agar aap apni services customers ko provide karna chahte hain, to admin ko as a security RS 500 send karein. '
          'JazzCash/EasyPaisa number: 0314-7549904. Payment ke baad screenshot upload karein.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Later'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      SecurityDepositScreen(providerId: widget.providerId),
                ),
              );
            },
            child: const Text('Pay Now', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        ProviderApiService.fetchDashboardStats(widget.providerId),
        ProviderApiService.fetchNewJobRequests(widget.providerId),
      ]);
      setState(() {
        _stats = results[0] as DashboardStats;
        _jobRequests = results[1] as List<JobRequest>;
        _isLoading = false;
      });
    } catch (e) {
      if (e.toString().contains('ACCOUNT_BLOCKED')) {
        _showBlockedDialog();
        return;
      }
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showBlockedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Account Blocked'),
        content: const Text(
          'Your account has been blocked by admin. Please contact support for more information.',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.declineRed,
            ),
            onPressed: () {
              box.erase(); // saved token/user_id sab clear
              Navigator.pop(ctx);
              Get.offAllNamed(AppRoutes.loginScreen);
            },
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAccept(int jobId) async {
    final result = await ProviderApiService.acceptJob(jobId);

    if (result['success'] == true) {
      setState(() {
        _jobRequests.removeWhere((j) => j.id == jobId);
        if (_stats != null) {
          _stats = DashboardStats(
            newRequests: _stats!.newRequests - 1,
            earningsThisMonth: _stats!.earningsThisMonth,
            jobsDone: _stats!.jobsDone,
            rating: _stats!.rating,
            totalJobsCompleted: _stats!.totalJobsCompleted,
            commissionRate: _stats!.commissionRate,
            pendingCommission: _stats!.pendingCommission,
            providerName: _stats!.providerName,
          );
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Job accepted successfully!'),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
      }
      return;
    }

    // Security deposit required
    if (result['code'] == 'SECURITY_DEPOSIT_REQUIRED') {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Security Deposit Required'),
          content: const Text(
            'Aap jobs accept karne se pehle RS 500 security deposit submit karein. Admin verify karne ke baad aap jobs accept kar sakenge.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
              ),
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        SecurityDepositScreen(providerId: widget.providerId),
                  ),
                );
              },
              child: const Text(
                'Pay Now',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
      return;
    }

    // Commission due
    if (result['code'] == 'COMMISSION_DUE') {
      final amount = (result['commission_due'] as num?)?.toDouble() ?? 0.0;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Commission Due'),
          content: Text(
            'Aapka RS ${amount.toStringAsFixed(0)} commission pending hai. Naye job accept karne se pehle commission pay karein.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentYellow,
              ),
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PayCommissionScreen(
                      providerId: widget.providerId,
                      commissionAmount: amount,
                    ),
                  ),
                );
              },
              child: const Text(
                'Pay Commission',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
      return;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Failed to accept job'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleDecline(int jobId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Decline Job'),
        content: const Text('Are you sure you want to decline this job?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.declineRed),
            child: const Text('Decline'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ProviderApiService.declineJob(jobId);
      if (success && mounted) {
        setState(() => _jobRequests.removeWhere((j) => j.id == jobId));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Job declined.'),
              backgroundColor: Colors.grey,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            )
          : _error != null
          ? _buildError()
          : RefreshIndicator(
              color: AppColors.primaryGreen,
              onRefresh: _loadDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsGrid(),
                    _buildCommissionBanner(),
                    _buildJobRequestsSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Text(
                'S',
                style: TextStyle(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ServEase Provider',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_stats != null)
                Text(
                  'Welcome, ${_stats!.providerName} 👋',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ProviderNotificationsScreen(providerId: widget.providerId),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'Online',
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    if (_stats == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.2,
        children: [
          _statCard(
            label: 'New Requests',
            value: '${_stats!.newRequests}',
            isHighlight: false,
          ),
          _statCard(
            label: 'This Month',
            value: 'RS ${_stats!.earningsThisMonth.toStringAsFixed(0)}',
            isHighlight: true,
          ),
          _statCard(
            label: 'Jobs Done',
            value: '${_stats!.jobsDone}',
            isHighlight: false,
          ),
          _ratingCard(_stats!.rating),
        ],
      ),
    );
  }

  Widget _statCard({
    required String label,
    required String value,
    required bool isHighlight,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isHighlight
                    ? AppColors.accentYellow
                    : AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ratingCard(double rating) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentYellow,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.star, color: AppColors.accentYellow, size: 20),
              ],
            ),
            const SizedBox(height: 2),
            const Text(
              'Rating',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommissionBanner() {
    if (_stats == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightYellow,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.yellowBorder),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.accentYellow,
                  size: 16,
                ),
                const SizedBox(width: 6),
                const Text(
                  'Commission Status',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${_stats!.totalJobsCompleted} jobs completed · '
              '${_stats!.commissionRate.toStringAsFixed(0)}% commission applies from job 3 onwards. '
              'Next commission due after next job.',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, color: AppColors.yellowBorder),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pending commission',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                Text(
                  'RS ${_stats!.pendingCommission.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobRequestsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'New Job Requests',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),
          if (_jobRequests.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.work_outline,
                    size: 40,
                    color: AppColors.textMuted,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'No new job requests',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ],
              ),
            )
          else
            ...(_jobRequests.map((job) => _buildJobCard(job)).toList()),
        ],
      ),
    );
  }

  Widget _buildJobCard(JobRequest job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildInitialsAvatar(job.initials),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.customerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        job.serviceType,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (job.isNew)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.newBadge.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'New',
                      style: TextStyle(
                        color: AppColors.newBadge,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 12,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  '${job.scheduledDate}, ${job.scheduledTime}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.location_on_outlined,
                  size: 12,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    job.location,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'RS ${job.price.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _handleAccept(job.id),
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Accept'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.primaryGreen,
                      side: const BorderSide(color: AppColors.primaryGreen),
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
                    onPressed: () => _handleDecline(job.id),
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('Decline'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.declineRed,
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
        ),
      ),
    );
  }

  Widget _buildInitialsAvatar(String initials) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 12),
            const Text(
              'Could not connect to server',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              _error ?? '',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadDashboardData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return ProviderBottomNavBar(
      currentIndex: _currentNavIndex,
      onTap: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MyJobsScreen(providerId: widget.providerId),
            ),
          );
          return;
        }
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EarningsScreen(providerId: widget.providerId),
            ),
          );
          return;
        }
        if (index == 3) {
          // Profile
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ProviderProfileScreen(providerId: widget.providerId),
            ),
          );
          return;
        }
        setState(() => _currentNavIndex = index);
      },
    );
  }
}
