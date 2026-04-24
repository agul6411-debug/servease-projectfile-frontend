import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectfile/core/utils/theme.dart';

// ─────────────────────────────────────────────
// Full Page
// ─────────────────────────────────────────────
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final horizontalPadding = isMobile ? 16.0 : 32.0;
    final verticalPadding = isMobile ? 20.0 : 32.0;

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
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: verticalPadding),
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
    final isMobile = MediaQuery.of(context).size.width < 600;
    final horizontalPadding = isMobile ? 24.0 : 40.0;
    final verticalPadding = isMobile ? 40.0 : 56.0;
    final fontSize = isMobile ? 28.0 : 42.0;
    final descFontSize = isMobile ? 14.0 : 16.0;

    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      decoration: const BoxDecoration(
        gradient: AppTheme.primaryGradient,
      ),
      child: Column(
        children: [
          Text(
            'Your Trusted Home\nService Platform',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color.fromARGB(255, 14, 12, 12),
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            'Connect with verified professionals for all your home service needs.\nFast, reliable, and transparent.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: const Color.fromARGB(179, 14, 13, 13), fontSize: descFontSize, height: 1.6),
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
    final isMobile = MediaQuery.of(context).size.width < 600;
    final horizontalPadding = isMobile ? 16.0 : 40.0;
    final verticalPadding = isMobile ? 16.0 : 24.0;
    final itemSpacing = isMobile ? 8.0 : 10.0;
    final fontSize = isMobile ? 12.0 : 14.0;
    final iconSize = isMobile ? 18.0 : 22.0;
    final containerSize = isMobile ? 32.0 : 40.0;

    return Container(
      color: const Color.fromARGB(255, 5, 5, 5),
      padding:
          EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
      child: isMobile
          ? Column(
              children: _features.map((f) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: containerSize,
                        height: containerSize,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5A623).withAlpha(31),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(f['icon'] as IconData,
                            color: const Color(0xFFF5A623), size: iconSize),
                      ),
                      SizedBox(width: itemSpacing),
                      Text(
                        f['label'] as String,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _features.map((f) {
                return Row(
                  children: [
                    Container(
                      width: containerSize,
                      height: containerSize,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5A623).withAlpha(31),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(f['icon'] as IconData,
                          color: const Color(0xFFF5A623), size: iconSize),
                    ),
                    SizedBox(width: itemSpacing),
                    Text(
                      f['label'] as String,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A),
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
    } else if (type == 'provider') {
      Get.toNamed('/provider-signup');
    }
  }

  void _signIn() {
    Get.toNamed('/sign-in');
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final verticalPadding = isMobile ? 40.0 : 56.0;
    final horizontalPadding = isMobile ? 24.0 : 40.0;
    final titleFontSize = isMobile ? 24.0 : 32.0;
    final descFontSize = isMobile ? 13.0 : 15.0;
    final buttonGap = isMobile ? 12.0 : 20.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          // ── Gradient background ──
          Container(
            width: double.infinity,
            padding:
                EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
            decoration: const BoxDecoration(
              gradient: AppTheme.accentGradient,
            ),
          ),

          // ── Animated + pattern overlay ──
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, _) {
                return CustomPaint(
                  painter: _CrossPatternPainter(offset: _controller.value * 60),
                );
              },
            ),
          ),

          // ── Content ──
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: verticalPadding - 4, horizontal: horizontalPadding),
            child: Column(
              children: [
                Text(
                  "Let's Get You Started!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 12, 11, 11),
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: isMobile ? 8 : 10),
                Text(
                  'Join thousands of satisfied customers and service providers on our platform',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromARGB(179, 14, 13, 13),
                    fontSize: descFontSize,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: isMobile ? 24 : 36),
                isMobile
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _CTAButton(
                            label: 'Signup as Customer',
                            filled: false,
                            onTap: () => _navigate('customer'),
                            isMobile: true,
                          ),
                          SizedBox(height: buttonGap),
                          _CTAButton(
                            label: 'Signup as Service Provider',
                            filled: true,
                            onTap: () => _navigate('provider'),
                            isMobile: true,
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _CTAButton(
                            label: 'Signup as Customer',
                            filled: false,
                            onTap: () => _navigate('customer'),
                          ),
                          SizedBox(width: buttonGap),
                          _CTAButton(
                            label: 'Signup as Service Provider',
                            filled: true,
                            onTap: () => _navigate('provider'),
                          ),
                        ],
                      ),
                SizedBox(height: isMobile ? 20 : 28),
                // Sign In button option
                GestureDetector(
                  onTap: _signIn,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 16 : 24,
                        vertical: isMobile ? 10 : 12),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        top: BorderSide(
                            color: const Color.fromARGB(255, 8, 8, 8).withAlpha(77), width: 1),
                      ),
                    ),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                            color: const Color.fromARGB(179, 14, 13, 13),
                            fontSize: isMobile ? 12 : 14),
                        children: [
                          const TextSpan(text: 'Already have an account? '),
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 17, 16, 16),
                              fontWeight: FontWeight.bold,
                              fontSize: isMobile ? 13 : 15,
                              decoration: TextDecoration.underline,
                              decorationColor: const Color.fromARGB(255, 10, 10, 10),
                              decorationThickness: 1.5,
                            ),
                          ),
                        ],
                      ),
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
  final bool isMobile;

  const _CTAButton(
      {required this.label,
      required this.filled,
      required this.onTap,
      this.isMobile = false});

  @override
  State<_CTAButton> createState() => _CTAButtonState();
}

class _CTAButtonState extends State<_CTAButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = widget.isMobile ? 20.0 : 28.0;
    final verticalPadding = widget.isMobile ? 12.0 : 15.0;
    final fontSize = widget.isMobile ? 12.0 : 14.0;

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
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
          decoration: BoxDecoration(
            color: widget.filled
                ? (_hovered
                    ? AppTheme.accentOrangeDark
                    : AppTheme.accentOrange)
                : (_hovered
                    ? Colors.white.withAlpha(38)
                    : Colors.white),
            borderRadius: BorderRadius.circular(30),
            border: widget.filled
                ? null
                : Border.all(color: Colors.white, width: 1.5),
            boxShadow: _hovered
                ? AppTheme.shadowLarge
                : [],
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.filled ? Colors.white : AppTheme.primaryGreen,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
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