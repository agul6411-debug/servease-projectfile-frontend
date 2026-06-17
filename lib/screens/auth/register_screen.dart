import 'package:flutter/material.dart';
import 'package:frontfile_servease/theme/app_theme.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3EF),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            _HeroSection(),
            _FeaturesGrid(),
            _CTASection(),
            _Footer(),
          ],
        ),
      ),
    );
  }
}

// ── HERO ─────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          color: const Color(0xFF1A5E33),
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 80),
          child: Column(
            children: [
              // Back button row
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.location_on_rounded,
                      size: 13,
                      color: Color(0xFFF59E0B),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Pakistan's Home Services",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Your Trusted Home\nService Platform',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Connect with verified professionals\nfor all your home service needs.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.7),
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),

        // Curved bottom overlap
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F3EF),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
          ),
        ),
      ],
    );
  }
}

// ── FEATURES GRID ────────────────────────────────────────────────
class _FeaturesGrid extends StatelessWidget {
  const _FeaturesGrid();

  static const _features = [
    {
      'icon': Icons.bolt_rounded,
      'label': 'Fast Booking',
      'sub': 'One tap confirm',
      'bg': Color(0xFFFEF3E2),
      'ic': Color(0xFFF59E0B),
    },
    {
      'icon': Icons.shield_rounded,
      'label': 'Verified Pros',
      'sub': 'CNIC checked',
      'bg': Color(0xFFE8F5E9),
      'ic': Color(0xFF2E7D32),
    },
    {
      'icon': Icons.star_rounded,
      'label': 'Top Rated',
      'sub': 'Community reviews',
      'bg': Color(0xFFFEF3E2),
      'ic': Color(0xFFF59E0B),
    },
    {
      'icon': Icons.lock_rounded,
      'label': 'Secure & Safe',
      'sub': 'Private & trusted',
      'bg': Color(0xFFE8F5E9),
      'ic': Color(0xFF2E7D32),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _features.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.85,
        ),
        itemBuilder: (_, i) {
          final f = _features[i];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E0D8)),
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: f['bg'] as Color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    f['icon'] as IconData,
                    color: f['ic'] as Color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        f['label'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1C1B1F),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        f['sub'] as String,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF9A8878),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── CTA SECTION ──────────────────────────────────────────────────
class _CTASection extends StatelessWidget {
  const _CTASection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E0D8)),
      ),
      child: Column(
        children: [
          const Text(
            "Let's get you started!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1C1B1F),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Join thousands of customers and providers',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xFF9A8878)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(color: Color(0xFFF0ECE6), height: 1),
          ),

          // Customer Button
          GestureDetector(
            onTap: () => Get.toNamed('/customer_page'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A5E33),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Signup as Customer',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Book home services',
                          style: TextStyle(fontSize: 11, color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white38,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Provider Button
          GestureDetector(
            onTap: () => Get.toNamed('/providerPagereg'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3E2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFF59E0B).withOpacity(0.35),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withOpacity(0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.work_rounded,
                      color: Color(0xFFB45309),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Signup as Provider',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF633806),
                          ),
                        ),
                        Text(
                          'Offer skills, earn income',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFFA16207),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Color(0xFFB45309),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Login link
          GestureDetector(
            onTap: () => Get.toNamed('/login_screen'),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(fontSize: 13, color: Color(0xFF9A8878)),
                children: [
                  TextSpan(text: 'Already have an account? '),
                  TextSpan(
                    text: 'Log in',
                    style: TextStyle(
                      color: Color(0xFFF59E0B),
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFFF59E0B),
                    ),
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
      color: const Color(0xFF1A5E33),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.home_rounded,
              color: Color(0xFFF59E0B),
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'ServEase',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            '© 2026 ServEase',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
