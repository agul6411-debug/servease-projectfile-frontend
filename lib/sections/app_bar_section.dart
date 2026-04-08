import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// AppBarSection - Custom app bar for the home page
class AppBarSection extends SliverAppBar {
  AppBarSection({super.key, VoidCallback? onLoginPressed})
    : super(
        pinned: true,
        elevation: 0,
        backgroundColor: AppColors.cream.withAlpha(245),
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 68,
        title: _buildTitle(),
        actions: _buildActions(onLoginPressed),
        bottom: _buildBottom(),
      );

  static Widget _buildTitle() {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withAlpha(38),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset('assets/home_logo.jpeg', fit: BoxFit.contain),
          ),
        ),
        const SizedBox(width: 12),
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

  static List<Widget> _buildActions(VoidCallback? onLoginPressed) {
    return [
      OutlinedButton(
        onPressed: onLoginPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.teal,
          side: const BorderSide(color: AppColors.teal),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: const Text(
          'Log In',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
      const SizedBox(width: 20),
    ];
  }

  static PreferredSize? _buildBottom() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(height: 1, color: AppColors.teal.withAlpha(26)),
    );
  }
}
