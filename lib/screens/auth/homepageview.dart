import 'package:flutter/material.dart';
import 'package:frontfile_servease/routes.dart';
import 'package:get/get.dart';
import 'package:frontfile_servease/theme/app_theme.dart';

class ServEaseApp extends StatefulWidget {
  const ServEaseApp({super.key});

  @override
  State<ServEaseApp> createState() => _ServEaseAppState();
}

class _ServEaseAppState extends State<ServEaseApp> {
  @override
  Widget build(BuildContext context) => const HomePage();
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scroll = ScrollController();
  final _howKey = GlobalKey();
  bool _elevated = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() => setState(() => _elevated = _scroll.offset > 10));
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F4),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scroll,
            child: Column(
              children: [
                const SizedBox(height: 68),
                _Hero(
                  onHow: () {
                    final ctx = _howKey.currentContext;
                    if (ctx != null)
                      Scrollable.ensureVisible(
                        ctx,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut,
                      );
                  },
                ),
                const _ServicesRow(),
                _HowSection(key: _howKey),
                const _StatsStrip(),
                const _Footer(),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _Nav(elevated: _elevated),
          ),
        ],
      ),
    );
  }
}

// ── NAV ──────────────────────────────────────────────────────────
class _Nav extends StatelessWidget {
  final bool elevated;
  const _Nav({required this.elevated});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 68,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 16,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            // Logo with dot
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(width: 6),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Serv',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                      TextSpan(
                        text: 'Ease',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Login — text only
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.loginScreen),
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Register — pill button
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.registerScreen),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  'Join Free',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── HERO ─────────────────────────────────────────────────────────
class _Hero extends StatelessWidget {
  final VoidCallback onHow;
  const _Hero({required this.onHow});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top green block
        Container(
          height: 340,
          decoration: const BoxDecoration(color: AppColors.primaryGreen),
        ),
        // Diagonal clip bottom
        ClipPath(
          clipper: _DiagonalClipper(),
          child: Container(height: 380, color: AppColors.primaryGreen),
        ),

        // Content
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 36, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pill badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  '🇵🇰  Pakistan\'s Home Services',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Big headline
              const Text(
                'Your Home.\nOur Experts.',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.1,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Book verified, trusted professionals for cleaning, tailoring, beauty, tutoring & more — right from your phone.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.7,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 28),

              // Two action buttons — different styles
              GestureDetector(
                onTap: onHow,
                child: const Text(
                  'See how it works',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Floating card — pulls over diagonal
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _MiniStat(value: '50+', label: 'Providers'),
                    _Divider(),
                    _MiniStat(value: '10+', label: 'Services'),
                    _Divider(),
                    _MiniStat(value: '100%', label: 'Verified'),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }
}

class _DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_) => false;
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  const _MiniStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: AppColors.border);
  }
}

// ── SERVICES HORIZONTAL SCROLL ───────────────────────────────────
class _ServicesRow extends StatelessWidget {
  const _ServicesRow();

  static const services = [
    {'e': '🧵', 'n': 'Tailoring', 'c': 0xFFFCE4EC},
    {'e': '🪡', 'n': 'Embroidery', 'c': 0xFFE8EAF6},
    {'e': '🧹', 'n': 'Cleaning', 'c': 0xFFE8F5E9},
    {'e': '📚', 'n': 'Tutoring', 'c': 0xFFE3F2FD},
    {'e': '💄', 'n': 'Beauty', 'c': 0xFFFCE4EC},
    {'e': '🌿', 'n': 'Mehndi', 'c': 0xFFF1F8E9},
    {'e': '👶', 'n': 'Babysitting', 'c': 0xFFFFF8E1},
    {'e': '📸', 'n': 'Photography', 'c': 0xFFE0F7FA},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 32, 0, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Browse Services',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: services.length,
              itemBuilder: (_, i) {
                final s = services[i];
                return Container(
                  width: 82,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(s['c'] as int),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        s['e'] as String,
                        style: const TextStyle(fontSize: 26),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        s['n'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── HOW IT WORKS ─────────────────────────────────────────────────
class _HowSection extends StatelessWidget {
  const _HowSection({super.key});

  static const steps = [
    {
      'n': '1',
      'title': 'Create Account',
      'desc': 'Sign up as a customer or provider in under 2 minutes.',
      'icon': Icons.person_add_rounded,
    },
    {
      'n': '2',
      'title': 'Find a Pro',
      'desc': 'Browse verified providers filtered by service and location.',
      'icon': Icons.search_rounded,
    },
    {
      'n': '3',
      'title': 'Book Instantly',
      'desc': 'Pick a time slot and confirm your booking with one tap.',
      'icon': Icons.calendar_today_rounded,
    },
    {
      'n': '4',
      'title': 'Done & Review',
      'desc': 'Service delivered. Rate your experience and help others.',
      'icon': Icons.star_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.accentYellow,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'How It Works',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...List.generate(steps.length, (i) {
            final s = steps[i];
            final isLast = i == steps.length - 1;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: number + line
                Column(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: i == 0
                            ? AppColors.primaryGreen
                            : const Color(0xFFF0F0F0),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        s['icon'] as IconData,
                        size: 20,
                        color: i == 0 ? Colors.white : AppColors.textMuted,
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 52,
                        color: const Color(0xFFEEEEEE),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: isLast ? 0 : 36),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '0${s['n']}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textMuted,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: const Color(0xFFF0F0F0),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s['title'] as String,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s['desc'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textMuted,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

// ── STATS STRIP ───────────────────────────────────────────────────
class _StatsStrip extends StatelessWidget {
  const _StatsStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryGreen,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _StatItem(value: '50+', label: 'Providers'),
          _StatItem(value: '8', label: 'Categories'),
          _StatItem(value: '100%', label: 'CNIC Verified'),
          _StatItem(value: '24/7', label: 'Support'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withOpacity(0.7),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

// ── FOOTER ───────────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.textDark,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Serv',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: 'Ease',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accentYellow,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Pakistan\'s trusted home services platform',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 20),
          Container(height: 1, color: Colors.white.withOpacity(0.06)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© 2026 ServEase',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              Row(
                children: [
                  Text(
                    'Team & Careers',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Ayesha Liaquat, Ayesha Farooq, Sahrish Saleem',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
