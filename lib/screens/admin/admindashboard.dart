import 'package:flutter/material.dart';
import 'package:frontfile_servease/routes.dart';
import 'package:frontfile_servease/services/dashboard_api.dart';
import 'package:get/get.dart';

class Admindashboard extends StatelessWidget {
  const Admindashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminPanelPage();
  }
}

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  int _selectedIndex = 0;

  bool isLoading = true;

  Map<String, dynamic> stats = {};

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    _NavItem(icon: Icons.verified_user_rounded, label: 'Verify'),
    _NavItem(icon: Icons.add, label: 'Add Service'),
    _NavItem(icon: Icons.people_rounded, label: 'providers'),
    _NavItem(icon: Icons.face, label: 'Profile'),
  ];

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      final data = await DashboardApi.getStats();

      setState(() {
        stats = data;
        isLoading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),

          SliverPadding(
            padding: const EdgeInsets.all(16),

            sliver: SliverToBoxAdapter(child: _buildStatsGrid()),
          ),

          SliverToBoxAdapter(child: _buildQuickActions()),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),

      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF43A047), Color(0xFFFF9800)],
        ),
      ),

      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        bottom: 30,
      ),

      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Admin Dashboard',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 6),

          Text('Manage your platform', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.people_rounded,

                iconBg: Colors.green,

                label: 'providers',

                value: '${stats['totalProviders'] ?? 0}',

                change: '+12%',
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _StatCard(
                icon: Icons.home_repair_service,

                iconBg: Colors.orange,

                label: 'Services',

                value: '${stats['totalServices'] ?? 0}',

                change: '+5%',
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.currency_rupee,

                iconBg: Colors.green,

                label: 'Revenue',

                value: 'PKR ${stats['revenue'] ?? 0}',

                change: '+18%',
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _StatCard(
                icon: Icons.calendar_today,

                iconBg: Colors.deepOrange,

                label: 'Bookings',

                value: '${stats['totalBookings'] ?? 0}',

                change: '+9%',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Quick Actions',

            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 14),

          _QuickActionTile(
            icon: Icons.verified_user,

            iconColor: Colors.orange,

            title: 'Pending Verification',

            subtitle: '${stats['pendingVerify'] ?? 0} pending',
          ),

          const SizedBox(height: 10),

          _QuickActionTile(
            icon: Icons.report,

            iconColor: Colors.red,

            title: 'Open Complaints',

            subtitle: '${stats['complaints'] ?? 0} complaints',
          ),

          const SizedBox(height: 10),

          _QuickActionTile(
            icon: Icons.people_alt,

            iconColor: Colors.blue,

            title: 'Active admin Users',

            subtitle: '${stats['totalAdmins'] ?? 0} active',
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,

      selectedItemColor: Colors.green,

      unselectedItemColor: Colors.grey,

      type: BottomNavigationBarType.fixed,

      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });

        final label = _navItems[index].label.toLowerCase();

        if (label == 'providers') {
          Get.toNamed(AppRoutes.providersScreen);
        }

        if (label == 'add service') {
          Get.toNamed(AppRoutes.addserviceScreen);
        }

        if (label == 'verify') {
          Get.toNamed(AppRoutes.verifyPage);
        }
      },

      items: _navItems.map((item) {
        return BottomNavigationBarItem(
          icon: Icon(item.icon),
          label: item.label,
        );
      }).toList(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String label;
  final String value;
  final String change;

  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.label,
    required this.value,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: iconBg,

              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(icon, color: Colors.white),
          ),

          const SizedBox(height: 14),

          Text(label, style: const TextStyle(color: Colors.grey)),

          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                value,

                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                change,

                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _QuickActionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),

              borderRadius: BorderRadius.circular(10),
            ),

            child: Icon(icon, color: iconColor),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,

                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}
