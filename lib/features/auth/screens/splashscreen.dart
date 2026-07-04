import 'package:flutter/material.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainCtrl;
  late AnimationController _pulseCtrl;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleFade;
  late Animation<double> _taglineFade;
  late Animation<double> _featuresFade;
  late Animation<double> _buttonsFade;
  late Animation<Offset> _buttonsSlide;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _mainCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainCtrl,
        curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainCtrl,
        curve: const Interval(0.0, 0.25, curve: Curves.easeIn),
      ),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _mainCtrl,
            curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
          ),
        );
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainCtrl,
        curve: const Interval(0.3, 0.6, curve: Curves.easeIn),
      ),
    );
    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainCtrl,
        curve: const Interval(0.45, 0.7, curve: Curves.easeIn),
      ),
    );
    _featuresFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainCtrl,
        curve: const Interval(0.55, 0.8, curve: Curves.easeIn),
      ),
    );
    _buttonsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainCtrl,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );
    _buttonsSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _mainCtrl,
            curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
          ),
        );
    _pulse = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _mainCtrl.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      
      final token = GetStorage().read('auth_token') ?? '';
      final role = GetStorage().read('user_role') ?? '';
      
      if (token.isNotEmpty && role.isNotEmpty) {
        if (role == 'admin') {
          Get.offAllNamed('/admin_dashboard');
        } else if (role == 'provider') {
          Get.offAllNamed('/provider_home_screen');
        } else if (role == 'customer') {
          Get.offAllNamed('/customer_home_screen');
        } else {
          Get.offAllNamed('/homepageview');
        }
      } else {
        Get.offAllNamed('/homepageview');
      }
    });
  }

  @override
  void dispose() {
    _mainCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEBF6EE), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
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
                    // ── Top decorative circles ──
                    _buildDecorativeTop(),

                    const SizedBox(height: 12),

                    // ── Logo ──
                    AnimatedBuilder(
                      animation: _mainCtrl,
                      builder: (_, child) => FadeTransition(
                        opacity: _logoFade,
                        child: ScaleTransition(scale: _logoScale, child: child),
                      ),
                      child: ScaleTransition(
                        scale: _pulse,
                        child: _buildLogo(isMobile),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Title ──
                    SlideTransition(
                      position: _titleSlide,
                      child: FadeTransition(
                        opacity: _titleFade,
                        child: _buildTitle(isMobile),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ── Tagline ──
                    FadeTransition(
                      opacity: _taglineFade,
                      child: _buildTagline(isMobile),
                    ),

                    const SizedBox(height: 28),

                    // ── Feature Chips ──
                    FadeTransition(
                      opacity: _featuresFade,
                      child: _buildFeatureChips(isMobile),
                    ),

                    const Spacer(),

                    // ── Buttons ──
                    SlideTransition(
                      position: _buttonsSlide,
                      child: FadeTransition(
                        opacity: _buttonsFade,
                        child: _buildButtons(isMobile),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDecorativeTop() {
    return SizedBox(
      height: 80,
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1B8B4B).withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            top: -10,
            left: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFB300).withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 60,
            child: Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF1B8B4B),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 80,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFB300).withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(bool isMobile) {
    final size = isMobile ? 100.0 : 120.0;
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow ring
        Container(
          width: size + 24,
          height: size + 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF1B8B4B).withOpacity(0.08),
          ),
        ),
        // Middle ring
        Container(
          width: size + 12,
          height: size + 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF1B8B4B).withOpacity(0.12),
          ),
        ),
        // Logo
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1B8B4B).withOpacity(0.2),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Image.asset('assets/logo.png', fit: BoxFit.contain),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(bool isMobile) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Serv',
                style: TextStyle(
                  color: const Color(0xFF1B8B4B),
                  fontSize: isMobile ? 42 : 54,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.5,
                ),
              ),
              TextSpan(
                text: 'Ease',
                style: TextStyle(
                  color: const Color(0xFFFFB300),
                  fontSize: isMobile ? 42 : 54,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTagline(bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 32.0 : 64.0),
      child: Column(
        children: [
          Text(
            'Empowering Women Through',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF1B8B4B),
              fontSize: isMobile ? 15 : 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          Text(
            'Home Services',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF1B8B4B).withOpacity(0.7),
              fontSize: isMobile ? 13 : 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChips(bool isMobile) {
    final features = [
      {
        'icon': Icons.verified_rounded,
        'label': 'CNIC Verified',
        'color': const Color(0xFF1B8B4B),
        'bg': const Color(0xFFE8F5E9),
      },
      {
        'icon': Icons.security_rounded,
        'label': 'Safe & Secure',
        'color': const Color(0xFF1565C0),
        'bg': const Color(0xFFE3F2FD),
      },
      {
        'icon': Icons.star_rounded,
        'label': 'Top Rated',
        'color': const Color(0xFFE65100),
        'bg': const Color(0xFFFFF3E0),
      },
      {
        'icon': Icons.favorite_rounded,
        'label': 'Women First',
        'color': const Color(0xFFC2185B),
        'bg': const Color(0xFFFCE4EC),
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.0 : 32.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: features.map((f) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: f['bg'] as Color,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: (f['color'] as Color).withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  f['icon'] as IconData,
                  color: f['color'] as Color,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  f['label'] as String,
                  style: TextStyle(
                    color: f['color'] as Color,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildButtons(bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24.0 : 48.0),
      child: Column(
        children: [
          // Get Started
          GestureDetector(
            onTap: () => Get.offNamed('/homepageview'),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: isMobile ? 16 : 18),
              decoration: BoxDecoration(
                color: const Color(0xFF1B8B4B),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1B8B4B).withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 16 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Empowerment badge
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: isMobile ? 14 : 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE4EC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFC2185B).withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.favorite_rounded,
                  color: Color(0xFFC2185B),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Aimed to Empower Women',
                  style: TextStyle(
                    color: const Color(0xFFC2185B),
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Terms
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
    );
  }
}
