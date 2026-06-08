import 'package:flutter/material.dart';
import 'package:frontfile_servease/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:frontfile_servease/routes.dart';
import 'package:frontfile_servease/models/admin_drawer_model.dart';
import 'package:frontfile_servease/services/admin_drawer_service.dart';

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
      backgroundColor: AppColors.cream,
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
                colors: [AppColors.success, AppColors.softPink],
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
                      onTap: () {
                        Get.toNamed(AppRoutes.adminDashboard);
                      },
                      selected: true,
                    ),

                    _menuTile(
                      icon: Icons.analytics_outlined,
                      title: "Analytics",
                      badge: "Live",
                      onTap: () {},
                    ),

                    const SizedBox(height: 12),

                    _sectionTitle("PROVIDER MANAGEMENT"),

                    _menuTile(
                      icon: Icons.verified_user_outlined,
                      title: "Provider Verification",
                      badge: '${drawerData?.pendingProviders ?? 0}',
                      onTap: () {
                        Get.offAllNamed(AppRoutes.providerverficationpage);
                      },
                    ),

                    _menuTile(
                      icon: Icons.badge_outlined,
                      title: "CNIC View",
                      onTap: () {
                        Get.offAllNamed(AppRoutes.cnicview);
                      },
                    ),

                    _menuTile(
                      icon: Icons.approval_outlined,
                      title: "Approve / Reject",
                      onTap: () {
                        Get.offAllNamed(AppRoutes.acceptance);
                      },
                    ),

                    const SizedBox(height: 12),

                    _sectionTitle("USER MANAGEMENT"),

                    _menuTile(
                      icon: Icons.people_outline,
                      title: "All Users",
                      onTap: () {
                        Get.offAllNamed(AppRoutes.allusers);
                      },
                    ),

                    _menuTile(
                      icon: Icons.person_outline,
                      title: "User Details",
                      onTap: () {
                        Get.offAllNamed(AppRoutes.userdetail);
                      },
                    ),

                    _menuTile(
                      icon: Icons.block_outlined,
                      title: "Block / Unblock",
                      onTap: () {
                        Get.offAndToNamed(AppRoutes.blockorunblock);
                      },
                    ),

                    const SizedBox(height: 12),

                    _sectionTitle("COMPLAINTS"),

                    _menuTile(
                      icon: Icons.report_problem_outlined,
                      title: "Complaint Handling",
                      badge: '${drawerData?.pendingComplaints ?? 0}',
                      onTap: () {
                        Get.offAllNamed(AppRoutes.complainhandling);
                      },
                    ),

                    _menuTile(
                      icon: Icons.chat_outlined,
                      title: "Complaint Details",
                      onTap: () {
                        Get.offAllNamed(AppRoutes.complaindetail);
                      },
                    ),

                    _menuTile(
                      icon: Icons.task_alt_outlined,
                      title: "Resolution",
                      onTap: () {
                        Get.offAllNamed(AppRoutes.complainresolution);
                      },
                    ),

                    const SizedBox(height: 12),

                    _sectionTitle("PLATFORM"),

                    _menuTile(
                      icon: Icons.miscellaneous_services_outlined,
                      title: "Service Management",
                      onTap: () {
                        Get.toNamed(AppRoutes.servicemanagement);
                      },
                    ),
                    _menuTile(
                      icon: Icons.payments_outlined,
                      title: "Commission Payments",
                      badge: '${drawerData?.pendingCommissions ?? 0}',
                      onTap: () => Get.toNamed(AppRoutes.adminCommissions),
                    ),
                    _menuTile(
                      icon: Icons.book_online_outlined,
                      title: "Booking Management",
                      onTap: () => Get.toNamed(AppRoutes.adminBookings),
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
                        onTap: () {},
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
    bool selected = false,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.softPink.withValues(alpha: 0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: selected
              ? AppColors.mediumRed
              : Colors.grey.shade200,
          child: Icon(
            icon,
            color: selected ? Colors.white : Colors.grey,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badge != null)
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

            const Icon(Icons.arrow_forward_ios, size: 15, color: Colors.grey),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
