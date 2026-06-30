import 'package:flutter/material.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:frontfile_servease/routes.dart';
import 'package:frontfile_servease/features/admin/models/admin_drawer_model.dart';
import 'package:frontfile_servease/features/admin/services/admin_drawer_service.dart';

class AdminDrawer extends StatefulWidget {
  const AdminDrawer({super.key});

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  final AdminDrawerService drawerService = AdminDrawerService();

  AdminDrawerModel? drawerData;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    fetchDrawerData();
  }

  Future<void> fetchDrawerData() async {
    final result = await drawerService.getDrawerData();

    if (result != null) {
      setState(() {
        drawerData = result;

        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 55,
              left: 20,
              right: 20,
              bottom: 25,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              "S",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ServEase",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            Text(
                              "Admin Panel",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    GestureDetector(
                      onTap: () {
                        Get.offAllNamed(AppRoutes.adminDashboard);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.15),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drawerData?.adminName ?? "Admin",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        drawerData?.adminEmail ?? "",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 18),

                    _sectionTitle("OVERVIEW"),

                    _menuTile(
                      icon: Icons.dashboard_outlined,
                      title: "Dashboard",
                      route: AppRoutes.adminDashboard,
                      onTap: () => Get.offAllNamed(AppRoutes.adminDashboard),
                    ),

                    const SizedBox(height: 12),

                    _sectionTitle("PROVIDER MANAGEMENT"),

                    _menuTile(
                      icon: Icons.verified_user_outlined,
                      title: "Provider Verification",
                      badge: '${drawerData?.pendingProviders ?? 0}',
                      route: AppRoutes.providerverficationpage,
                      onTap: () => Get.offAllNamed(AppRoutes.providerverficationpage),
                    ),

                    _menuTile(
                      icon: Icons.approval_outlined,
                      title: "Approve / Reject",
                      route: AppRoutes.acceptance,
                      onTap: () => Get.offAllNamed(AppRoutes.acceptance),
                    ),

                    const SizedBox(height: 12),

                    _sectionTitle("USER MANAGEMENT"),

                    _menuTile(
                      icon: Icons.people_outline,
                      title: "All Users",
                      route: AppRoutes.allusers,
                      onTap: () => Get.offAllNamed(AppRoutes.allusers),
                    ),

                    _menuTile(
                      icon: Icons.block_outlined,
                      title: "Block / Unblock",
                      route: AppRoutes.blockorunblock,
                      onTap: () => Get.offAllNamed(AppRoutes.blockorunblock),
                    ),

                    const SizedBox(height: 12),

                    _sectionTitle("COMPLAINTS"),

                    _menuTile(
                      icon: Icons.report_problem_outlined,
                      title: "Complaint Handling",
                      badge: '${drawerData?.pendingComplaints ?? 0}',
                      route: AppRoutes.complainhandling,
                      onTap: () => Get.offAllNamed(AppRoutes.complainhandling),
                    ),

                    const SizedBox(height: 12),

                    _sectionTitle("PLATFORM"),

                    _menuTile(
                      icon: Icons.miscellaneous_services_outlined,
                      title: "Service Management",
                      route: AppRoutes.servicemanagement,
                      onTap: () => Get.offAllNamed(AppRoutes.servicemanagement),
                    ),
                    _menuTile(
                      icon: Icons.payments_outlined,
                      title: "Commission Payments",
                      badge: '${drawerData?.pendingCommissions ?? 0}',
                      route: AppRoutes.adminCommissions,
                      onTap: () => Get.offAllNamed(AppRoutes.adminCommissions),
                    ),
                    _menuTile(
                      icon: Icons.payments_outlined,
                      title: "Security Deposits",
                      badge: '${drawerData?.pendingSecurityDeposits ?? 0}',
                      route: AppRoutes.adminSecurityDeposits,
                      onTap: () => Get.offAllNamed(AppRoutes.adminSecurityDeposits),
                    ),

                    _menuTile(
                      icon: Icons.book_online_outlined,
                      title: "Booking Management",
                      route: AppRoutes.adminBookings,
                      onTap: () => Get.offAllNamed(AppRoutes.adminBookings),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.errorBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Sign Out'),
                              content: const Text(
                                'Are you sure you want to sign out?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    GetStorage().erase();
                                    Get.offAllNamed(AppRoutes.loginScreen);
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: const Text('Sign Out'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 10, top: 5),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    String? badge,
    required String route,
    required VoidCallback onTap,
  }) {
    final bool selected = Get.currentRoute == route;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: selected
              ? AppColors.primary
              : Colors.grey.shade200,
          child: Icon(
            icon,
            color: selected ? Colors.white : Colors.grey,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            color: selected ? AppColors.primary : AppColors.textDark,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badge != null && badge != "0")
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badge == "Live"
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: badge == "Live" ? Colors.green : Colors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(width: 8),

            Icon(
              Icons.arrow_forward_ios,
              size: 13,
              color: selected ? AppColors.primary : Colors.grey,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
