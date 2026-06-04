import 'package:flutter/material.dart';
import 'package:projectfile/models/admin_dashboard_model.dart';
import 'package:projectfile/screens/admin/admindrawer.dart';
import 'package:projectfile/services/adminservice.dart';
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

    if (result != null) {
      setState(() {
        dashboardData = result;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminDrawer(),
      backgroundColor: const Color(0xffF6F7F9),
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // HOME
            GestureDetector(
              onTap: () {
                Get.offAllNamed('/admindashboard');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.home, color: Color(0xff14C15D)),
                  SizedBox(height: 4),
                  Text(
                    'Home',
                    style: TextStyle(
                      color: Color(0xff14C15D),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // PROFILE
            GestureDetector(
              onTap: () {
                Get.offAllNamed('/adminprofile');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.person, color: Colors.grey),
                  SizedBox(height: 4),
                  Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // NOTIFICATIONS
            GestureDetector(
              onTap: () {
                Get.offAllNamed('/adminnotifications');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.notifications, color: Colors.grey),
                  SizedBox(height: 4),
                  Text(
                    'Notifications',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // SETTINGS
            GestureDetector(
              onTap: () {
                Get.offAllNamed('/adminsettings');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.settings, color: Colors.grey),
                  SizedBox(height: 4),
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildStatsSection(),
                    const SizedBox(height: 25),
                    _buildQuickActions(),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff00D26A), Color(0xffFF8A00)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.25),
                  shape: BoxShape.circle,
                ),
                child: Builder(
                  builder: (context) {
                    return GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: const Icon(Icons.menu, color: Colors.white),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.25),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Admin Panel',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Manage your platform',
            style: TextStyle(color: Colors.white.withOpacity(.9), fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 1.1,
        children: [
          _buildStatCard(
            icon: Icons.group_outlined,
            iconBg: const Color(0xff00B74A),
            title: 'Total Users',
            value: dashboardData?.totalUsers.toString() ?? '0',
            percent: '+12%',
          ),
          _buildStatCard(
            icon: Icons.person_outline,
            iconBg: const Color(0xffFF6A00),
            title: 'Active Providers',
            value: dashboardData?.totalProviders.toString() ?? '0',
            percent: '+8%',
          ),
          _buildStatCard(
            icon: Icons.attach_money,
            iconBg: const Color(0xff00B74A),
            title: 'Monthly Revenue',
            value: '₨0',
            percent: '+23%',
          ),
          _buildStatCard(
            icon: Icons.calendar_today_outlined,
            iconBg: const Color(0xffFF6A00),
            title: 'Total Bookings',
            value: dashboardData?.totalBookings.toString() ?? '0',
            percent: '+15%',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String value,
    required String percent,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white),
          ),
          const Spacer(),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                percent,
                style: const TextStyle(
                  color: Color(0xff00B74A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
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
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 18),
          _actionTile(
            title: 'Pending Verifications',
            subtitle: '${dashboardData?.pendingProviders ?? 0} pending',
            icon: Icons.shield_outlined,
            iconColor: const Color(0xffFF6A00),
          ),
          const SizedBox(height: 14),
          _actionTile(
            title: 'Open Complaints',
            subtitle: '${dashboardData?.openComplaints ?? 0} pending',
            icon: Icons.error_outline,
            iconColor: const Color(0xffFF6A00),
          ),
          const SizedBox(height: 14),
          _actionTile(
            title: 'Manage Services',
            subtitle: '${dashboardData?.totalServices ?? 0} pending',
            icon: Icons.inventory_2_outlined,
            iconColor: const Color(0xffFF6A00),
          ),
          const SizedBox(height: 14),
          _actionTile(
            title: 'Active Users',
            subtitle: '${dashboardData?.totalUsers ?? 0} pending',
            icon: Icons.people_outline,
            iconColor: const Color(0xffFF6A00),
          ),
        ],
      ),
    );
  }

  Widget _actionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xffFFF4EC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
        ],
      ),
    );
  }
}

