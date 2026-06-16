import 'package:flutter/material.dart';
import 'package:frontfile_servease/models/admin_dashboard_model.dart';
import 'package:frontfile_servease/screens/admin/admin_navbar.dart';
import 'package:frontfile_servease/screens/admin/admindrawer.dart';
import 'package:frontfile_servease/services/adminservice.dart';
import 'package:frontfile_servease/theme/app_theme.dart';
import 'package:frontfile_servease/routes.dart';
import 'package:get/get.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AdminService _adminService = AdminService();
  AdminDashboardModel? dashboardData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    final result = await _adminService.getDashboardStats();
    setState(() {
      dashboardData = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminDrawer(),
      backgroundColor: const Color(0xFFF5F0E8),
      bottomNavigationBar: const AdminBottomNavBar(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.success),
            )
          : RefreshIndicator(
              color: AppColors.success,
              onRefresh: fetchDashboard,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildStatsGrid(),
                    _buildQuickActions(),
                    _buildHealthSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  // ── Header ───────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
      child: Column(
        children: [
          // Top row: menu | ServEase | logout
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(
                builder: (ctx) => GestureDetector(
                  onTap: () => Scaffold.of(ctx).openDrawer(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  const Text(
                    'ServEase',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Admin Panel',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Get.offAllNamed(AppRoutes.homepageview),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Stats row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                _headerStat('${dashboardData?.totalUsers ?? 0}', 'Users'),
                _headerDivider(),
                _headerStat(
                  '${dashboardData?.totalProviders ?? 0}',
                  'Providers',
                ),
                _headerDivider(),
                _headerStat('${dashboardData?.totalBookings ?? 0}', 'Bookings'),
                _headerDivider(),
                _headerStat(
                  'RS ${dashboardData?.commissionEarned ?? 0}',
                  'Earned',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerStat(String value, String label) => Expanded(
    child: Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 11),
        ),
      ],
    ),
  );

  Widget _headerDivider() =>
      Container(width: 1, height: 32, color: Colors.white24);

  // ── Stats Grid ───────────────────────────────────────────────────
  Widget _buildStatsGrid() {
    final stats = [
      {
        'icon': Icons.group_outlined,
        'color': const Color(0xFF1565C0),
        'bg': const Color(0xFFE3F2FD),
        'title': 'Total Users',
        'value': '${dashboardData?.totalUsers ?? 0}',
        'sub': 'All registered',
      },
      {
        'icon': Icons.person_outline,
        'color': AppColors.success,
        'bg': const Color(0xFFE8F5E9),
        'title': 'Customers',
        'value': '${dashboardData?.totalCustomers ?? 0}',
        'sub': 'Active customers',
      },
      {
        'icon': Icons.verified_user_outlined,
        'color': const Color(0xFF6A1B9A),
        'bg': const Color(0xFFF3E5F5),
        'title': 'Providers',
        'value': '${dashboardData?.totalProviders ?? 0}',
        'sub': 'Service providers',
      },
      {
        'icon': Icons.book_online_outlined,
        'color': const Color(0xFFE65100),
        'bg': const Color(0xFFFFF3E0),
        'title': 'Bookings',
        'value': '${dashboardData?.totalBookings ?? 0}',
        'sub': 'Total bookings',
      },
      {
        'icon': Icons.pending_outlined,
        'color': const Color(0xFFC62828),
        'bg': const Color(0xFFFFEBEE),
        'title': 'Pending Review',
        'value': '${dashboardData?.pendingProviders ?? 0}',
        'sub': 'Need verification',
      },
      {
        'icon': Icons.payments_outlined,
        'color': const Color(0xFF00695C),
        'bg': const Color(0xFFE0F2F1),
        'title': 'Commission Earned',
        'value': 'RS ${dashboardData?.commissionEarned ?? 0}',
        'sub': 'Verified payments',
      },
      {
        'icon': Icons.payments_outlined,
        'color': const Color(0xFF00695C),
        'bg': const Color(0xFFE0F2F1),
        'title': 'Commission (10%)',
        'value':
            'RS ${dashboardData?.commissionEarned.toStringAsFixed(0) ?? 0}',
        'sub': 'Verified commissions',
      },
      {
        'icon': Icons.security_outlined,
        'color': const Color(0xFF1565C0),
        'bg': const Color(0xFFE3F2FD),
        'title': 'Security Deposits',
        'value': 'RS ${dashboardData?.securityAmount.toStringAsFixed(0) ?? 0}',
        'sub': '${dashboardData?.securityDeposits ?? 0} verified',
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Platform Overview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.6,
            ),
            itemCount: stats.length,
            itemBuilder: (_, i) {
              final s = stats[i];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: s['bg'] as Color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        s['icon'] as IconData,
                        color: s['color'] as Color,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            s['value'] as String,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: s['color'] as Color,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            s['title'] as String,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            s['sub'] as String,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Quick Actions ────────────────────────────────────────────────
  Widget _buildQuickActions() {
    final actions = [
      {
        'title': 'Provider Verification',
        'sub': '${dashboardData?.pendingProviders ?? 0} pending',
        'icon': Icons.verified_user_outlined,
        'color': const Color(0xFF1565C0),
        'route': AppRoutes.providerverficationpage,
      },
      {
        'title': 'Complaint Handling',
        'sub': '${dashboardData?.openComplaints ?? 0} open',
        'icon': Icons.report_problem_outlined,
        'color': const Color(0xFFC62828),
        'route': AppRoutes.complainhandling,
      },
      {
        'title': 'Service Management',
        'sub': '${dashboardData?.totalServices ?? 0} services',
        'icon': Icons.design_services_outlined,
        'color': const Color(0xFF00695C),
        'route': AppRoutes.servicemanagement,
      },
      {
        'title': 'All Users',
        'sub': '${dashboardData?.totalUsers ?? 0} registered',
        'icon': Icons.people_outline,
        'color': AppColors.success,
        'route': AppRoutes.allusers,
      },
      {
        'title': 'Commission Payments',
        'sub': 'RS ${dashboardData?.commissionEarned ?? 0} earned',
        'icon': Icons.payments_outlined,
        'color': const Color(0xFFE65100),
        'route': AppRoutes.adminCommissions,
      },
      {
        'title': 'Booking Management',
        'sub': '${dashboardData?.totalBookings ?? 0} total',
        'icon': Icons.book_online_outlined,
        'color': const Color(0xFF6A1B9A),
        'route': AppRoutes.adminBookings,
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          ...actions
              .map(
                (a) => _actionTile(
                  title: a['title'] as String,
                  sub: a['sub'] as String,
                  icon: a['icon'] as IconData,
                  color: a['color'] as Color,
                  route: a['route'] as String,
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _actionTile({
    required String title,
    required String sub,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => Get.toNamed(route),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    sub,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.arrow_forward_ios, color: color, size: 13),
            ),
          ],
        ),
      ),
    );
  }

  // ── Health Section ───────────────────────────────────────────────
  Widget _buildHealthSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Platform Health',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Live',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _healthRow('User Growth', 0.75, AppColors.success),
                const SizedBox(height: 14),
                _healthRow('Provider Activity', 0.60, const Color(0xFF1565C0)),
                const SizedBox(height: 14),
                _healthRow('Booking Rate', 0.85, const Color(0xFFE65100)),
                const SizedBox(height: 14),
                _healthRow('Resolution Rate', 0.90, const Color(0xFF6A1B9A)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _healthRow(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
