import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontfile_servease/theme/app_theme.dart';
import 'package:frontfile_servease/services/service_request_service.dart';

class AdminNavBarPage extends StatelessWidget {
  const AdminNavBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Navigation'),
        backgroundColor: AppColors.success,
      ),
      body: const Center(
        child: Text(
          'Admin navigation is available via the bottom bar.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
      bottomNavigationBar: const AdminBottomNavBar(),
    );
  }
}

class AdminBottomNavBar extends StatefulWidget {
  const AdminBottomNavBar({super.key});

  @override
  State<AdminBottomNavBar> createState() => _AdminBottomNavBarState();
}

class _AdminBottomNavBarState extends State<AdminBottomNavBar> {
  int _pendingCount = 0;

  @override
  void initState() {
    super.initState();
    _loadPendingCount();
  }

  Future<void> _loadPendingCount() async {
    final count = await ServiceRequestService.getPendingCount();
    if (mounted) setState(() => _pendingCount = count);
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;

    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavItem(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            title: 'Home',
            selected: currentRoute == '/admin_dashboard',
            onTap: () => Get.offAllNamed('/admin_dashboard'),
          ),
          _NavItem(
            icon: Icons.person_outline,
            selectedIcon: Icons.person,
            title: 'Profile',
            selected: currentRoute == '/adminprofile',
            onTap: () => Get.offAllNamed('/adminprofile'),
          ),
          // Service Requests with badge
          _NavItemBadge(
            icon: Icons.miscellaneous_services_outlined,
            selectedIcon: Icons.miscellaneous_services,
            title: 'Requests',
            selected: currentRoute == '/admin_service_requests',
            badgeCount: _pendingCount,
            onTap: () => Get.offAllNamed('/admin_service_requests'),
          ),
          _NavItem(
            icon: Icons.notifications_outlined,
            selectedIcon: Icons.notifications,
            title: 'Alerts',
            selected: currentRoute == '/adminnotification',
            onTap: () => Get.offAllNamed('/adminnotification'),
          ),
          _NavItem(
            icon: Icons.settings_outlined,
            selectedIcon: Icons.settings,
            title: 'Settings',
            selected: currentRoute == '/adminsettings',
            onTap: () => Get.offAllNamed('/adminsettings'),
          ),
        ],
      ),
    );
  }
}

// Regular Nav Item
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.title,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String title;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            selected ? selectedIcon : icon,
            color: selected ? AppColors.primary : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: selected ? AppColors.primary : Colors.grey,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// Nav Item with Badge (for pending count)
class _NavItemBadge extends StatelessWidget {
  const _NavItemBadge({
    required this.icon,
    required this.selectedIcon,
    required this.title,
    required this.onTap,
    required this.badgeCount,
    this.selected = false,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String title;
  final VoidCallback onTap;
  final bool selected;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                selected ? selectedIcon : icon,
                color: selected ? AppColors.primary : Colors.grey,
                size: 24,
              ),
              if (badgeCount > 0)
                Positioned(
                  top: -4,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      badgeCount > 99 ? '99+' : '$badgeCount',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: selected ? AppColors.primary : Colors.grey,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
