import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─────────────────────────────────────────────
// Full Page
// ─────────────────────────────────────────────
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Hero Section ──
            const _HeroSection(),

            // ── Features Strip ──
            const _FeaturesStrip(),

            // ── CTA Banner ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              child: const _CTABanner(),
            ),

            // ── Footer ──
            const _Footer(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Hero Section
// ─────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 56),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A5C35), Color(0xFF2D8A50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Your Trusted Home\nService Platform',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Connect with verified professionals for all your home service needs.\nFast, reliable, and transparent.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.6),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Features Strip
// ─────────────────────────────────────────────
class _FeaturesStrip extends StatelessWidget {
  const _FeaturesStrip();

  static const _features = [
    {'icon': Icons.bolt_rounded, 'label': 'Fast Booking'},
    {'icon': Icons.verified_rounded, 'label': 'Verified Pros'},
    {'icon': Icons.star_rounded, 'label': 'Top Rated'},
    {'icon': Icons.shield_rounded, 'label': 'Secure & Safe'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _features.map((f) {
          return Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5A623).withAlpha(31),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(f['icon'] as IconData,
                    color: const Color(0xFFF5A623), size: 22),
              ),
              const SizedBox(width: 10),
              Text(
                f['label'] as String,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CTA Banner (main focus - exact match)
// ─────────────────────────────────────────────
class _CTABanner extends StatefulWidget {
  const _CTABanner();

  @override
  State<_CTABanner> createState() => _CTABannerState();
}

class _CTABannerState extends State<_CTABanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigate(String type) {
    if (type == 'customer') {
      Get.toNamed('/customer-signup');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Navigating to Service Provider Signup...'),
          backgroundColor: Color(0xFF1A5C35),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _signIn() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigating to Sign In...'),
        backgroundColor: Color(0xFF1A5C35),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          // ── Gradient background ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1A5C35), // deep green
                  Color(0xFF2DAA55), // mid green
                  Color(0xFFF5A623), // orange
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),

          ),

          // ── Animated + pattern overlay ──
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, _) {
                return CustomPaint(
                  painter: _CrossPatternPainter(
                      offset: _controller.value * 60),
                );
              },
            ),
          ),

          // ── Content ──
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 52, horizontal: 40),
            child: Column(
              children: [
                const Text(
                  "Let's Get You Started!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Join thousands of satisfied customers and service providers on our platform',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 36),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Signup as Customer — white outlined
                    _CTAButton(
                      label: 'Signup as Customer',
                      filled: false,
                      onTap: () => _navigate('customer'),
                    ),
                    const SizedBox(width: 20),
                    // Signup as Service Provider — orange filled
                    _CTAButton(
                      label: 'Signup as Service Provider',
                      filled: true,
                      onTap: () => _navigate('provider'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Sign In link
                GestureDetector(
                  onTap: _signIn,
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          color: Colors.white70, fontSize: 13),
                      children: [
                        TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CTA Button
// ─────────────────────────────────────────────
class _CTAButton extends StatefulWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _CTAButton(
      {required this.label, required this.filled, required this.onTap});

  @override
  State<_CTAButton> createState() => _CTAButtonState();
}

class _CTAButtonState extends State<_CTAButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: Matrix4.diagonal3Values(
            _hovered ? 1.04 : 1.0,
            _hovered ? 1.04 : 1.0,
            1.0,
          ),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
          decoration: BoxDecoration(
            color: widget.filled
                ? (_hovered
                    ? const Color(0xFFE09010)
                    : const Color(0xFFF5A623))
                : (_hovered
                    ? Colors.white.withAlpha(38)
                    : Colors.white),
            borderRadius: BorderRadius.circular(30),
            border: widget.filled
                ? null
                : Border.all(color: Colors.white, width: 1.5),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: Colors.black.withAlpha(46),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.filled ? Colors.white : const Color(0xFF1A5C35),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Cross Pattern Painter (animated + dots)
// ─────────────────────────────────────────────
class _CrossPatternPainter extends CustomPainter {
  final double offset;
  _CrossPatternPainter({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(18)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    const spacing = 36.0;
    const armLen = 8.0;

    final cols = (size.width / spacing).ceil() + 2;
    final rows = (size.height / spacing).ceil() + 2;
    final dx = offset % spacing;

    for (int r = -1; r < rows; r++) {
      for (int c = -1; c < cols; c++) {
        final cx = c * spacing + dx;
        final cy = r * spacing;
        canvas.drawLine(
            Offset(cx - armLen, cy), Offset(cx + armLen, cy), paint);
        canvas.drawLine(
            Offset(cx, cy - armLen), Offset(cx, cy + armLen), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_CrossPatternPainter old) => old.offset != offset;
}

// ─────────────────────────────────────────────
// Footer
// ─────────────────────────────────────────────
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A1A),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 28),
      child: Row(
        children: [
          const Icon(Icons.home_rounded, color: Color(0xFFF5A623), size: 20),
          const SizedBox(width: 8),
          const Text(
            'ServEase',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const Text(
            '© 2026 ServEase. All rights reserved.',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }
}