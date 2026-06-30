import 'package:flutter/material.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';
import 'package:frontfile_servease/features/provider/screens/provider_home_screen.dart';
import 'package:frontfile_servease/features/provider/screens/my_jobs_screen.dart';
import 'package:frontfile_servease/features/provider/screens/earningscreen.dart';
import 'package:frontfile_servease/features/provider/screens/provider_profile_screen.dart';

class ProviderBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final int providerId;
  final ValueChanged<int>? onTap;

  const ProviderBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.providerId,
    this.onTap,
  });

  static const List<Map<String, dynamic>> _items = [
    {'icon': Icons.home_outlined, 'label': 'Dashboard'},
    {'icon': Icons.work_outline, 'label': 'My Jobs'},
    {'icon': Icons.account_balance_wallet_outlined, 'label': 'Earnings'},
    {'icon': Icons.person_outline, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final isSelected = currentIndex == i;
              return GestureDetector(
                onTap: () {
                  if (onTap != null) {
                    onTap!(i);
                  } else {
                    if (i == currentIndex) return;
                    Widget screen;
                    switch (i) {
                      case 0:
                        screen = ProviderHomeScreen(providerId: providerId);
                        break;
                      case 1:
                        screen = MyJobsScreen(providerId: providerId);
                        break;
                      case 2:
                        screen = EarningsScreen(providerId: providerId);
                        break;
                      case 3:
                        screen = ProviderProfileScreen(providerId: providerId);
                        break;
                      default:
                        return;
                    }
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => screen),
                      (route) => false,
                    );
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _items[i]['icon'] as IconData,
                        color: isSelected
                            ? AppColors.primaryGreen
                            : AppColors.textMuted,
                        size: 22,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _items[i]['label'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected
                              ? AppColors.primaryGreen
                              : AppColors.textMuted,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 3),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isSelected ? 4 : 0,
                        height: isSelected ? 4 : 0,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
