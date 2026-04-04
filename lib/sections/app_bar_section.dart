import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/common_widgets.dart';

/// AppBarSection - Custom app bar for the home page
class AppBarSection extends SliverAppBar {
  AppBarSection({Key? key})
      : super(
          key: key,
          pinned: true,
          elevation: 0,
          backgroundColor: AppColors.cream.withOpacity(0.96),
          surfaceTintColor: Colors.transparent,
          toolbarHeight: 68,
          title: _buildTitle(),
          actions: _buildActions(),
          bottom: _buildBottom(),
        );

  static Widget _buildTitle() {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.teal,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.home_repair_service,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Serv',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.teal,
                ),
              ),
              TextSpan(
                text: 'Ease',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.orange,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static List<Widget> _buildActions() {
    return [
      const NavBtn('Services'),
      const NavBtn('How It Works'),
      const NavBtn('Features'),
      const SizedBox(width: 8),
      OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.teal,
          side: const BorderSide(color: AppColors.teal),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: const Text(
          'Log In',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
      const SizedBox(width: 10),
      ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: const Text(
          'Get Started →',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
      const SizedBox(width: 20),
    ];
  }

  static PreferredSize? _buildBottom() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(
        height: 1,
        color: AppColors.teal.withOpacity(0.1),
      ),
    );
  }
}
