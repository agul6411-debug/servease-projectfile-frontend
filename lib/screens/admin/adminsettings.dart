import 'package:flutter/material.dart';
import 'package:frontfile_servease/theme/app_theme.dart';
import 'package:frontfile_servease/screens/admin/admin_navbar.dart';

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.success,
      ),
      body: const Center(
        child: Text(
          'Admin settings page placeholder.',
          style: TextStyle(fontSize: 16),
        ),
      ),
      bottomNavigationBar: const AdminBottomNavBar(),
    );
  }
}
