import 'package:flutter/material.dart';
import 'package:frontfile_servease/theme/app_theme.dart';
import 'package:frontfile_servease/routes.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF8),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            _HeroSection(),
            _ChoiceSection(),
            _Footer(),
          ],
        ),
      ),
    );
  }
}

// ── HERO SECTION ─────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0F5A34),
                Color(0xFF1B8B4B),
              ],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 68),
          child: Column(
            children: [
              // Back Button Row
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              const Text(
                'Join ServEase',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose your role to get started with Pakistan\'s leading home service network.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.85),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        // Curve bottom overlap
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFFF9FBF8),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
          ),
        ),
      ],
    );
  }
}

// ── CHOICE SECTION (WOW Cards) ──────────────────────────────────
class _ChoiceSection extends StatelessWidget {
  const _ChoiceSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // 1. CUSTOMER CARD
          _ChoiceCard(
            title: 'Book a Service',
            subtitle: 'I want to hire verified partners',
            desc: 'Find and book skilled female professionals for tailoring, beauty, mehndi, cleaning & tutoring.',
            bullets: const [
              '100% CNIC-verified local partners',
              'Fair upfront pricing & ratings check',
              'Doorstep services with safety first',
            ],
            icon: Icons.person_rounded,
            iconBg: const Color(0xFFEBF6EE),
            iconColor: AppColors.primary,
            borderColor: AppColors.primary.withOpacity(0.2),
            btnText: 'Register as Customer',
            btnColor: AppColors.primary,
            onTap: () => Get.toNamed('/customer_page'),
          ),
          
          const SizedBox(height: 20),

          // 2. PROVIDER CARD
          _ChoiceCard(
            title: 'Become a Partner',
            subtitle: 'I want to offer my services & earn',
            desc: 'Earn income by offering your skills. Work on your own terms and manage bookings easily.',
            bullets: const [
              'Zero hidden fees — keep what you earn',
              'Set your own prices and hours',
              'Easy digital commission system',
            ],
            icon: Icons.work_rounded,
            iconBg: const Color.fromARGB(255, 155, 123, 55),
            iconColor: AppColors.accent,
            borderColor: AppColors.accent.withOpacity(0.2),
            btnText: 'Register as provider',
            btnColor: AppColors.accent,
            onTap: () => Get.toNamed('/providerPagereg'),
          ),

          const SizedBox(height: 28),

          // Login Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account? ',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.mutedForeground,
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.loginScreen),
                child: const Text(
                  'Login here',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ── CUSTOM CHOICE CARD COMPONENT ─────────────────────────────────
class _ChoiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String desc;
  final List<String> bullets;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color borderColor;
  final String btnText;
  final Color btnColor;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.title,
    required this.subtitle,
    required this.desc,
    required this.bullets,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.borderColor,
    required this.btnText,
    required this.btnColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.foreground,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: iconColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          
          // Description
          Text(
            desc,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.mutedForeground,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          
          // Bullet points
          ...bullets.map((b) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: iconColor,
                  size: 15,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    b,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.foreground,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
          
          const SizedBox(height: 18),
          
          // CTA button
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: btnColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: btnColor.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    btnText,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── FOOTER ───────────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: Column(
        children: [
          const Divider(color: Color(0xFFEBF2EC), height: 1),
          const SizedBox(height: 16),
          Text(
            'Secure & CNIC-Verified Home Service Portal',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
