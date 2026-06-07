import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontfile_servease/theme/app_theme.dart';

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

class AdminBottomNavBar extends StatelessWidget {
  const AdminBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          _NavItem(
            icon: Icons.home,
            title: 'Home',
            selected: false,
            onTap: () {
              Get.offAllNamed('/admin_dashboard');
            },
          ),
          _NavItem(
            icon: Icons.person,
            title: 'Profile',
            onTap: () {
              Get.offAllNamed('/adminprofile');
            },
          ),
          _NavItem(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {
              Get.offAllNamed('/adminnotification');
            },
          ),
          _NavItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              Get.offAllNamed('/adminsettings');
            },
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
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
          Icon(icon, color: selected ? AppColors.success : Colors.grey),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: selected ? AppColors.success : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
