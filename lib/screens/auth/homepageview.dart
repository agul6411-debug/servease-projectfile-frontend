import 'package:flutter/material.dart';
import 'package:frontfile_servease/constants/apptheme.dart';
import 'package:frontfile_servease/routes.dart';
import 'package:get/get.dart';

class ServEaseApp extends StatefulWidget {
  const ServEaseApp({super.key});

  @override
  State<ServEaseApp> createState() => _ServEaseAppState();
}

class _ServEaseAppState extends State<ServEaseApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ServEase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'sans-serif',
        scaffoldBackgroundColor: kBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 17, 228, 42),
        ),
      ),
      home: const HomePage(),
    );
  }
}

// ── HOME PAGE ──
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _navElevated = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() => _navElevated = _scrollController.offset > 10);
    });
  }

  void _scrollToSection(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  final _servicesKey = GlobalKey();
  final _howKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── SCROLLABLE CONTENT ──
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Space for fixed nav
                const SizedBox(height: 68),

                // HERO
                _HeroSection(onHowItWorks: () => _scrollToSection(_howKey)),

                // SERVICES
                _ServicesSection(key: _servicesKey),

                // HOW IT WORKS
                _HowItWorksSection(key: _howKey),

                // WHY SERVEASE
                const _WhySection(),

                // FOOTER
                const _Footer(),
              ],
            ),
          ),

          // ── FIXED NAV ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _NavBar(
              elevated: _navElevated,
              onLogin: () {
                Get.toNamed(AppRoutes.loginScreen);
              },
              onRegister: () {
                Get.toNamed(AppRoutes.registerScreen);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── NAV BAR ──
class _NavBar extends StatelessWidget {
  final bool elevated;
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  const _NavBar({
    required this.elevated,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 68,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE2EDEA),
            width: elevated ? 1 : 0,
          ),
        ),
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // LOGO
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Serv',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: kTeal,
                      letterSpacing: -0.5,
                    ),
                  ),
                  TextSpan(
                    text: 'Ease',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: kGold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            // BUTTONS
            Row(
              children: [
                // Login
                OutlinedButton(
                  onPressed: onLogin,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kTeal,
                    side: const BorderSide(color: kTeal, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(width: 8),
                // Register
                ElevatedButton(
                  onPressed: onRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kTeal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── HERO SECTION ──
class _HeroSection extends StatelessWidget {
  final VoidCallback onHowItWorks;

  const _HeroSection({required this.onHowItWorks});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 640;

    return Container(
      constraints: const BoxConstraints(minHeight: 520),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D1F1C), Color(0xFF12201E), Color(0xFF1A3530)],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Glow
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF1D9E8A).withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(20, 40, 20, isMobile ? 40 : 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: const Color(0xFF1D9E8A).withOpacity(0.4),
                    ),
                    color: const Color(0xFF1D9E8A).withOpacity(0.1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: kTealAccent,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "PAKISTAN'S HOME SERVICES PLATFORM",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: kTealAccent,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Headline
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Skilled Help,\nRight at Your ',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.15,
                          letterSpacing: -1,
                        ),
                      ),
                      TextSpan(
                        text: 'Doorstep',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: kTealAccent,
                          height: 1.15,
                          letterSpacing: -1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Subtitle
                Text(
                  'ServEase connects you with verified, professional service providers for all your home needs — from tailoring to tutoring, cleaning to beauty services, and so much more.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.75,
                    color: Colors.white.withOpacity(0.65),
                  ),
                ),
                const SizedBox(height: 32),

                // CTA — only "How it works" button (Explore Services removed)
                ElevatedButton(
                  onPressed: onHowItWorks,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    foregroundColor: Colors.white.withOpacity(0.85),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    elevation: 0,
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: const Text('How it works'),
                ),
                const SizedBox(height: 40),

                // Stats row
                if (!isMobile)
                  Row(
                    children: const [
                      _StatItem(num: '10+', label: 'SERVICE CATEGORIES'),
                      SizedBox(width: 40),
                      _StatItem(num: '100%', label: 'VERIFIED PROVIDERS'),
                      SizedBox(width: 40),
                      _StatItem(num: '24/7', label: 'SUPPORT'),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String num;
  final String label;

  const _StatItem({required this.num, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          num,
          style: const TextStyle(
            fontFamily: 'serif',
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withOpacity(0.45),
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

// ── SERVICES SECTION ──
class _ServicesSection extends StatelessWidget {
  const _ServicesSection({super.key});

  static const List<Map<String, String>> services = [
    {
      'icon': '🧵',
      'title': 'Tailoring',
      'desc':
          'Custom stitching, alterations, and garment repairs by skilled tailors.',
    },
    {
      'icon': '🪡',
      'title': 'Embroidery Design',
      'desc':
          'Intricate hand and machine embroidery for clothes, fabric, and decor.',
    },
    {
      'icon': '🧹',
      'title': 'Cleaning',
      'desc':
          'Professional home and office cleaning services tailored to your schedule.',
    },
    {
      'icon': '📚',
      'title': 'Tutoring',
      'desc':
          'Qualified tutors for school and college subjects, available at home.',
    },
    {
      'icon': '💄',
      'title': 'Beauty Services',
      'desc':
          'Salon-quality makeup, skincare, and grooming at your convenience.',
    },
    {
      'icon': '🌿',
      'title': 'Mehndi & Henna',
      'desc':
          'Traditional and contemporary mehndi art for weddings and occasions.',
    },
    {
      'icon': '🎨',
      'title': 'Handmade Products',
      'desc':
          'Unique handcrafted items — customized gifts, décor, and art pieces.',
    },
    {
      'icon': '👶',
      'title': 'Babysitting',
      'desc':
          'Trustworthy childcare professionals available whenever you need them.',
    },
    {
      'icon': '🏠',
      'title': 'Home Maids',
      'desc':
          'Experienced domestic helpers for daily household chores and errands.',
    },
    {
      'icon': '📸',
      'title': 'Photography',
      'desc':
          'Professional photographers for events, portraits, and special moments.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBg,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WHAT WE OFFER',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
              color: kTeal,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Services for Every\nHome Need',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: kDark,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Browse from a wide range of skilled professionals, all verified and ready to help.',
            style: TextStyle(fontSize: 14, color: kMuted, height: 1.7),
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: services.length,
            itemBuilder: (ctx, i) => _ServiceCard(
              icon: services[i]['icon']!,
              title: services[i]['title']!,
              desc: services[i]['desc']!,
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final String icon;
  final String title;
  final String desc;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _hovered = true),
      onTapUp: (_) => setState(() => _hovered = false),
      onTapCancel: () => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? kTeal.withOpacity(0.3) : const Color(0xFFE2EDEA),
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: kTeal.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: kTealLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(widget.icon, style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: kDark,
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                widget.desc,
                style: TextStyle(fontSize: 11, color: kMuted, height: 1.6),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AnimatedOpacity(
              opacity: _hovered ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: const Text(
                'Book now →',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: kTeal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── HOW IT WORKS SECTION ──
class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection({super.key});

  static const List<Map<String, String>> steps = [
    {
      'num': '01',
      'title': 'Register & Browse',
      'desc':
          'Create your account and explore services by category or search for exactly what you need.',
    },
    {
      'num': '02',
      'title': 'Pick a Provider',
      'desc':
          'View profiles, ratings, and reviews to choose a verified professional you can trust.',
    },
    {
      'num': '03',
      'title': 'Book & Chat',
      'desc':
          'Send a booking request and chat directly with your provider to discuss details.',
    },
    {
      'num': '04',
      'title': 'Rate & Review',
      'desc':
          'After the service, share your feedback to help the community grow stronger.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kDark,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SIMPLE STEPS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
              color: kTealAccent,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'How ServEase Works',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Get the help you need in just a few taps — quick, safe, and reliable.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.55),
              height: 1.7,
            ),
          ),
          const SizedBox(height: 32),
          ...steps.map(
            (s) =>
                _StepCard(num: s['num']!, title: s['title']!, desc: s['desc']!),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String num;
  final String title;
  final String desc;

  const _StepCard({required this.num, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            num,
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: kTealMid.withOpacity(0.35),
              height: 1,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.5),
                    height: 1.65,
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

// ── WHY SERVEASE SECTION ──
class _WhySection extends StatelessWidget {
  const _WhySection();

  static const List<Map<String, String>> features = [
    {
      'icon': '✅',
      'title': 'Verified Providers',
      'desc':
          'All service providers are reviewed and approved by our admin team before going live.',
    },
    {
      'icon': '💬',
      'title': 'Built-in Chat',
      'desc':
          'Communicate directly with providers through our secure in-app messaging system.',
    },
    {
      'icon': '⭐',
      'title': 'Ratings & Reviews',
      'desc':
          'Transparent feedback helps you choose the best and holds providers accountable.',
    },
    {
      'icon': '🔒',
      'title': 'Secure & Reliable',
      'desc':
          'JWT-based authentication and SSL encryption keep your data and bookings safe.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kTealLight,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WHY CHOOSE US',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
              color: kTeal,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Built Around\nYour Trust',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: kDark,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Every feature of ServEase is designed to make home services safe, transparent, and stress-free.',
            style: TextStyle(fontSize: 14, color: kMuted, height: 1.7),
          ),
          const SizedBox(height: 32),
          ...features.map(
            (f) => _WhyCard(
              icon: f['icon']!,
              title: f['title']!,
              desc: f['desc']!,
            ),
          ),
        ],
      ),
    );
  }
}

class _WhyCard extends StatelessWidget {
  final String icon;
  final String title;
  final String desc;

  const _WhyCard({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kTeal.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kDark,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: kMuted,
                    height: 1.6,
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

// ── FOOTER ──
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kDark,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Serv',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFCCCCCC),
                  ),
                ),
                TextSpan(
                  text: 'Ease',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: kGold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '© 2026 ServEase. Final Year Project – BSIT, Kamoke.',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.35),
            ),
          ),
        ],
      ),
    );
  }
}

// ── AUTH DIALOG ──
// ignore: unused_element
class _AuthDialog extends StatelessWidget {
  final bool isLogin;

  const _AuthDialog({required this.isLogin});

  @override
  Widget build(BuildContext context) {
    final ctrl1 = TextEditingController();
    final ctrl2 = TextEditingController();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        isLogin ? 'Welcome Back' : 'Create Account',
        style: const TextStyle(
          fontFamily: 'serif',
          fontWeight: FontWeight.w700,
          color: kDark,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: ctrl1,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: kTeal),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: ctrl2,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: kTeal),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: kMuted)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: kTeal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            isLogin ? 'Login' : 'Register',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
