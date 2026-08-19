import 'package:flutter/material.dart';
import 'package:frontfile_servease/models/providermodel/providermodelapi.dart';
import 'package:frontfile_servease/routes.dart';
import 'package:frontfile_servease/features/provider/screens/earningscreen.dart';
import 'package:frontfile_servease/features/provider/screens/pay_commission_screen.dart';
import 'package:frontfile_servease/features/provider/screens/provider_profile_screen.dart';
import 'package:frontfile_servease/features/provider/screens/provider_notifications_screen.dart';
import 'package:frontfile_servease/features/provider/screens/providernavbar.dart';
import 'package:frontfile_servease/features/provider/screens/my_jobs_screen.dart';
import 'package:frontfile_servease/features/provider/services/providerapiservice.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:async';
import 'package:frontfile_servease/features/provider/screens/security_deposit_screen.dart';
import 'package:frontfile_servease/core/services/notification_polling_service.dart';

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
  int _securityDepositAmount = 500;
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    _startSecurityDepositTimer();
  }

  void _startSecurityDepositTimer() {
    Timer(const Duration(seconds: 5), () async {
      if (!mounted) return;
      final data = await ProviderApiService.getSecurityDepositStatus(
        widget.providerId,
      );
      final status = data['status'] ?? 'pending';
      final amount = double.tryParse(data['amount']?.toString() ?? '500')?.toInt() ?? 500;
      final required = data['required'] ?? 1;

      setState(() {
        _securityDepositAmount = amount;
      });

      if (status == 'pending' && required != 0 && mounted) {
        _showSecurityDepositReminder(amount);
      }
    });
  }

  void _showSecurityDepositReminder(int amount) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        title: const Text('Security Deposit Required'),
        content: Text(
          'To start offering your services to customers, you need to send RS $amount as a security deposit to the admin. '
          'JazzCash: 0300-1009904 / EasyPaisa: 0314-7549904. Upload a screenshot after payment.',
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
                      SecurityDepositScreen(providerId: widget.providerId, amount: amount),
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
        ProviderApiService.fetchNotifications(widget.providerId),
      ]);
      
      final notifsList = results[2] as List<dynamic>;
      final unread = notifsList.where((n) => n['is_read'] == 0 || n['is_read'] == false || n['is_read'] == null).length;

      setState(() {
        _stats = results[0] as DashboardStats;
        _jobRequests = results[1] as List<JobRequest>;
        _unreadCount = unread;
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
          content: Text(
            'Please submit a RS $_securityDepositAmount security deposit before accepting jobs. Once the admin verifies your payment, you will be able to accept jobs.',
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
                        SecurityDepositScreen(providerId: widget.providerId, amount: _securityDepositAmount),
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
            'You have RS ${amount.toStringAsFixed(0)} in pending commission. Please pay your commission before accepting new jobs.',
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
      backgroundColor: const Color(0xFFF8F9FA),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProviderNotificationsScreen(providerId: widget.providerId),
                  ),
                ).then((_) => _loadDashboardData()), // Reload stats and count on return
              ),
              if (_unreadCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primaryGreen, width: 1.5),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '$_unreadCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
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
                        _buildGradientHeader(),
                        const SizedBox(height: 16),
                        _buildCommissionBanner(),
                        const SizedBox(height: 16),
                        _buildJobRequestsSection(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildGradientHeader() {
    final welcomeName = _stats?.providerName ?? 'Provider';
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF07462F), // Deep forest green
            Color(0xFF0F6846), // Premium emerald green
            Color(0xFF198F62), // Vibrant mint emerald
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 64, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.home_repair_service_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'ServEase Pro',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00E676),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF00E676),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Online',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome back,',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '$welcomeName 👋',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 20),
          _buildStatsGridInsideHeader(),
        ],
      ),
    );
  }

  Widget _buildStatsGridInsideHeader() {
    if (_stats == null) return const SizedBox();
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.3,
      children: [
        _statCard(
          label: 'New Requests',
          value: '${_stats!.newRequests}',
          icon: Icons.notifications_active_outlined,
          iconColor: const Color(0xFF1976D2),
          bgIconColor: const Color(0xFFE3F2FD),
        ),
        _statCard(
          label: 'This Month',
          value: 'RS ${_stats!.earningsThisMonth.toStringAsFixed(0)}',
          icon: Icons.monetization_on_outlined,
          iconColor: AppColors.primaryGreen,
          bgIconColor: const Color(0xFFE8F5E9),
        ),
        _statCard(
          label: 'Jobs Done',
          value: '${_stats!.jobsDone}',
          icon: Icons.done_all_outlined,
          iconColor: const Color(0xFFE64A19),
          bgIconColor: const Color(0xFFFBE9E7),
        ),
        _ratingCard(_stats!.rating),
      ],
    );
  }

  Widget _statCard({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color bgIconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: bgIconColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ratingCard(double rating) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFDE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star, color: Colors.amber, size: 16),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 1),
                  const Text(
                    'Rating',
                    style: TextStyle(fontSize: 9, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommissionBanner() {
    if (_stats == null) return const SizedBox();
    final pending = _stats!.pendingCommission;
    final hasPending = pending > 0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: hasPending ? const Color(0xFFFFE0B2) : Colors.grey.shade100),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: hasPending ? const Color(0xFFFFF3E0) : const Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    hasPending ? Icons.warning_amber_rounded : Icons.verified_user_outlined,
                    color: hasPending ? const Color(0xFFEF6C00) : AppColors.primaryGreen,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  hasPending ? 'Commission Payment Due' : 'Commission Status',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.textDark,
                  ),
                ),
                const Spacer(),
                if (hasPending)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PayCommissionScreen(
                            providerId: widget.providerId,
                            commissionAmount: pending,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF6C00),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Pay Now',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              hasPending
                  ? 'You have a pending commission of RS ${pending.toStringAsFixed(0)}. Please pay this to continue accepting new job requests.'
                  : 'Great job! You have completed ${_stats!.totalJobsCompleted} jobs. Your commission rate is ${_stats!.commissionRate.toStringAsFixed(0)}% (applies from the 3rd job onwards).',
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.4),
            ),
            if (!hasPending) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_stats!.totalJobsCompleted >= 2) ? 1.0 : (_stats!.totalJobsCompleted / 2.0),
                  backgroundColor: Colors.grey.shade100,
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00E676)),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_stats!.totalJobsCompleted}/2 Free Jobs Completed',
                    style: const TextStyle(fontSize: 9, color: AppColors.textMuted, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    _stats!.totalJobsCompleted >= 2 ? 'Commission Active' : 'Free Trial',
                    style: TextStyle(
                      fontSize: 9,
                      color: _stats!.totalJobsCompleted >= 2 ? const Color(0xFFEF6C00) : AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
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

  Widget _buildJobRequestsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.pending_actions_rounded, color: AppColors.primaryGreen, size: 18),
              SizedBox(width: 6),
              Text(
                'Active Job Requests',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (_jobRequests.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.work_outline_rounded,
                      size: 32,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No active requests',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'You are all caught up! New requests will appear here.',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade400,
                    ),
                    textAlign: TextAlign.center,
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
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
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
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          job.serviceType,
                          style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'RS ${job.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    if (job.isNew) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'NEW',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF1F3F5)),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 12,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 5),
                Text(
                  '${job.scheduledDate} at ${job.scheduledTime}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.location_on_outlined,
                  size: 13,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    job.location,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _handleAccept(job.id),
                    icon: const Icon(Icons.check_rounded, size: 14),
                    label: const Text('Accept', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _handleDecline(job.id),
                    icon: const Icon(Icons.close_rounded, size: 14),
                    label: const Text('Decline', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      foregroundColor: AppColors.declineRed,
                      elevation: 0,
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
        color: AppColors.primaryGreen.withValues(alpha: 0.15),
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
      providerId: widget.providerId,
    );
  }
}
