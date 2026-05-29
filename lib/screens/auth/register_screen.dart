import 'package:flutter/material.dart';
import 'package:frontfile_servease/screens/auth/login_screen.dart';
import 'package:get/get.dart';

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
      backgroundColor: const Color(0xFFF4FFF4),
      appBar: AppBar(
        title: const Text('Register'),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _HeroSection(),
            const _FeaturesStrip(),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: const _CTABanner(),
            ),

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
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFE0B2), Color(0xFFE8F5E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Your Trusted Home\nService Platform',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF1B1B1B),
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
              color: Color(0xFF424242),
              fontSize: descFontSize,
              height: 1.6,
            ),
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
      color: const Color(0xFF1B5E20),
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
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
                          color: const Color(0xFFFF9800).withAlpha(35),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          f['icon'] as IconData,
                          color: const Color(0xFFFF9800),
                          size: iconSize,
                        ),
                      ),
                      SizedBox(width: itemSpacing),
                      Text(
                        f['label'] as String,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
                        color: const Color(0xFFFF9800).withAlpha(35),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        f['icon'] as IconData,
                        color: const Color(0xFFFF9800),
                        size: iconSize,
                      ),
                    ),
                    SizedBox(width: itemSpacing),
                    Text(
                      f['label'] as String,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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
// CTA Banner
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
      Get.toNamed('/customer_page');
    } else if (type == 'provider') {
      Get.toNamed('/providerPagereg');
    } else if (type == 'login') {
      Get.toNamed('/login_screen');
    }
  }

  void LoginScreen() {
    Get.toNamed('/login_screen');
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 40 : 56,
              horizontal: isMobile ? 24 : 40,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFE0B2), Color(0xFFE8F5E9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

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

          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 36 : 52,
              horizontal: isMobile ? 24 : 40,
            ),
            child: Column(
              children: [
                Text(
                  "Let's Get You Started!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1B1B1B),
                    fontSize: isMobile ? 24 : 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: isMobile ? 10 : 14),

                Text(
                  'Join thousands of satisfied customers and service providers on our platform',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF424242),
                    fontSize: isMobile ? 13 : 15,
                  ),
                ),

                SizedBox(height: isMobile ? 24 : 36),

                isMobile
                    ? Column(
                        children: [
                          _CTAButton(
                            label: 'Signup as Customer',
                            filled: false,
                            onTap: () => _navigate('customer'),
                            isMobile: true,
                          ),

                          const SizedBox(height: 12),

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
                            isMobile: true,
                          ),

                          const SizedBox(width: 20),

                          _CTAButton(
                            label: 'Signup as Service Provider',
                            filled: true,
                            onTap: () => _navigate('provider'),
                            isMobile: true,
                          ),
                        ],
                      ),

                SizedBox(height: isMobile ? 20 : 28),

                GestureDetector(
                  onTap: () => _navigate('login'),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 24,
                      vertical: isMobile ? 10 : 12,
                    ),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: Color(0xFF424242),
                          fontSize: isMobile ? 12 : 14,
                        ),
                        children: [
                          const TextSpan(text: 'Already have an account? '),
                          TextSpan(
                            text: 'log in',
                            style: TextStyle(
                              color: Color(0xFFFF9800),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFFFF9800),
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
// CTA BUTTON
// ─────────────────────────────────────────────
class _CTAButton extends StatefulWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;
  final bool isMobile;

  const _CTAButton({
    required this.label,
    required this.filled,
    required this.onTap,
    this.isMobile = false,
  });

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
          padding: EdgeInsets.symmetric(
            horizontal: widget.isMobile ? 20 : 28,
            vertical: widget.isMobile ? 12 : 15,
          ),
          decoration: BoxDecoration(
            color: widget.filled
                ? (_hovered ? const Color(0xFF388E3C) : const Color(0xFF2E7D32))
                : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: widget.filled
                ? null
                : Border.all(color: const Color(0xFF2E7D32), width: 1.5),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.filled ? Colors.white : const Color(0xFF2E7D32),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PATTERN PAINTER
// ─────────────────────────────────────────────
class _CrossPatternPainter extends CustomPainter {
  final double offset;

  _CrossPatternPainter({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(18)
      ..strokeWidth = 1.2;

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
          Offset(cx - armLen, cy),
          Offset(cx + armLen, cy),
          paint,
        );

        canvas.drawLine(
          Offset(cx, cy - armLen),
          Offset(cx, cy + armLen),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_CrossPatternPainter old) {
    return old.offset != offset;
  }
}

// ─────────────────────────────────────────────
// FOOTER
// ─────────────────────────────────────────────
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1B5E20),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 28),
      child: Row(
        children: [
          const Icon(Icons.home_rounded, color: Color(0xFFFF9800), size: 20),

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
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
