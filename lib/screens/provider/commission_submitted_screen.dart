import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:frontfile_servease/routes.dart';
import 'package:frontfile_servease/screens/provider/providernavbar.dart';
import 'package:frontfile_servease/screens/provider/my_jobs_screen.dart';
import 'package:frontfile_servease/screens/provider/provider_profile_screen.dart';
import 'package:frontfile_servease/screens/provider/earningscreen.dart';
import 'package:frontfile_servease/theme/app_theme.dart';

class CommissionSubmittedScreen extends StatelessWidget {
  final double amount;
  const CommissionSubmittedScreen({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Check Icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.primaryGreen,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Commission Submitted!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Admin will verify your payment within 24 hours. You will be unlocked to connect with your next customer.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Summary Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _summaryRow(
                      'Amount paid',
                      'RS ${amount.toStringAsFixed(0)}',
                    ),
                    const SizedBox(height: 8),
                    _summaryRow(
                      'Status',
                      'Pending verification',
                      valueColor: AppColors.accentYellow,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Back Button
              ElevatedButton(
                onPressed: () => Get.offAllNamed(AppRoutes.providerHomeScreen),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Back to Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ProviderBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          final box = GetStorage();
          final userId = box.read('user_id') ?? 0;
          if (index == 0) {
            Get.offAllNamed(AppRoutes.providerHomeScreen);
            return;
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MyJobsScreen(providerId: userId),
              ),
            );
            return;
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EarningsScreen(providerId: userId),
              ),
            );
            return;
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProviderProfileScreen(providerId: userId),
              ),
            );
            return;
          }
        },
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textDark,
          ),
        ),
      ],
    );
  }
}
