import 'package:flutter/material.dart';
import 'package:frontfile_servease/theme/app_theme.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _contentController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleFade;
  late Animation<double> _featuresFade;
  late Animation<double> _buttonsFade;
  late Animation<Offset> _buttonsSlide;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _contentController,
            curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
          ),
        );

    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _featuresFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
      ),
    );

    _buttonsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    _buttonsSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _contentController,
            curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
          ),
        );

    // Start animations sequentially
    _logoController.forward().then((_) {
      _contentController.forward();
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Get.offNamed('/homepageview');
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // ── Top gradient background area ──
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFEAF2E8), Color(0xFFF5F8F0)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    padding: EdgeInsets.only(
                      top: isMobile ? 48 : 64,
                      bottom: isMobile ? 32 : 48,
                    ),
                    child: Column(
                      children: [
                        // ── Animated App Logo ──
                        AnimatedBuilder(
                          animation: _logoController,
                          builder: (_, child) {
                            return FadeTransition(
                              opacity: _logoFade,
                              child: ScaleTransition(
                                scale: _logoScale,
                                child: child,
                              ),
                            );
                          },
                          child: _AppLogo(size: isMobile ? 100 : 120),
                        ),

                        SizedBox(height: isMobile ? 24 : 32),

                        // ── Animated Title ──
                        SlideTransition(
                          position: _titleSlide,
                          child: FadeTransition(
                            opacity: _titleFade,
                            child: _AppTitle(isMobile: isMobile),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Features Section ──
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 24 : 48,
                        vertical: isMobile ? 24 : 32,
                      ),
                      child: FadeTransition(
                        opacity: _featuresFade,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _FeatureCard(
                              icon: Icons.verified_user_rounded,
                              label: 'Verified Professionals',
                              iconColor: const Color(0xFF2ECC71),
                              delay: 0,
                              controller: _contentController,
                            ),
                            SizedBox(height: isMobile ? 12 : 16),
                            _FeatureCard(
                              icon: Icons.lock_rounded,
                              label: 'Secure Payments',
                              iconColor: const Color(0xFFE55A2B),
                              delay: 100,
                              controller: _contentController,
                            ),
                            SizedBox(height: isMobile ? 12 : 16),
                            _FeatureCard(
                              icon: Icons.location_on_rounded,
                              label: 'Real-time Tracking',
                              iconColor: const Color(0xFF2ECC71),
                              delay: 200,
                              controller: _contentController,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── Buttons Section ──
                  SlideTransition(
                    position: _buttonsSlide,
                    child: FadeTransition(
                      opacity: _buttonsFade,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          isMobile ? 24 : 48,
                          0,
                          isMobile ? 24 : 48,
                          isMobile ? 24 : 36,
                        ),
                        child: Column(
                          children: [
                            // Get Started Button
                            GestureDetector(
                              onTap: () => Get.offNamed('/homepageview'),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  vertical: isMobile ? 16 : 18,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF1A7A3C),
                                      Color(0xFF2EAA55),
                                      Color(0xFFF5A623),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(32),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF2ECC71,
                                      ).withValues(alpha: 0.3),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'Get Started',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isMobile ? 16 : 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: isMobile ? 12 : 16),

                            // Woman empower button
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  vertical: isMobile ? 16 : 18,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(32),
                                  border: Border.all(
                                    color: Colors.grey.withValues(alpha: 0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  'Aim To EmPoWer WoMan',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF333333),
                                    fontSize: isMobile ? 15 : 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: isMobile ? 16 : 20),

                            // Terms text
                            Text(
                              'By continuing, you agree to our Terms & Privacy Policy',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: isMobile ? 11 : 12,
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
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// App Logo Widget
// ─────────────────────────────────────────────
class _AppLogo extends StatelessWidget {
  final double size;
  const _AppLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2ECC71).withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset('assets/logo.png', fit: BoxFit.cover),
    );
  }
}

// ─────────────────────────────────────────────
// App Title Widget
// ─────────────────────────────────────────────
class _AppTitle extends StatelessWidget {
  final bool isMobile;
  const _AppTitle({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Serv',
                style: TextStyle(
                  color: const Color(0xFF2ECC71),
                  fontSize: isMobile ? 40 : 52,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),
              TextSpan(
                text: 'Ease',
                style: TextStyle(
                  color: const Color(0xFFF5A623),
                  fontSize: isMobile ? 40 : 52,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 8 : 12),
        Text(
          'Your trusted platform for home services\n& professional experts',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: isMobile ? 14 : 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Feature Card Widget
// ─────────────────────────────────────────────
class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final int delay;
  final AnimationController controller;

  const _FeatureCard({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.delay,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF222222),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
