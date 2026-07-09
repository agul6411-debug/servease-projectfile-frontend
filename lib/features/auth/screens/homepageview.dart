import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontfile_servease/routes.dart';
import 'package:get/get.dart';
import 'package:frontfile_servease/features/customer/screens/provider_detail_screen.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';
import 'package:frontfile_servease/core/services/app_config.dart';
import 'package:http/http.dart' as http;

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

  List<dynamic> _realProviders = [];
  bool _loadingProviders = true;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() => setState(() => _elevated = _scroll.offset > 10));
    _fetchPublicProviders();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _fetchPublicProviders() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/auth/public-providers'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            _realProviders = data['providers'] ?? [];
            _loadingProviders = false;
          });
        } else {
          setState(() => _loadingProviders = false);
        }
      } else {
        setState(() => _loadingProviders = false);
      }
    } catch (e) {
      debugPrint("Error fetching public providers: $e");
      setState(() => _loadingProviders = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF8),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scroll,
            child: Column(
              children: [
                const SizedBox(height: 70),
                _Hero(
                  onHow: () {
                    final ctx = _howKey.currentContext;
                    if (ctx != null) {
                      Scrollable.ensureVisible(
                        ctx,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
                const _ServicesGrid(),
                _FeaturedProviders(
                  providers: _realProviders,
                  isLoading: _loadingProviders,
                ),
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

// ── NAV BAR ──────────────────────────────────────────────────────
class _Nav extends StatelessWidget {
  final bool elevated;
  const _Nav({required this.elevated});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
        border: Border(
          bottom: BorderSide(
            color: elevated ? Colors.transparent : const Color(0xFFEBF2EC),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Serv',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.foreground,
                      ),
                    ),
                    TextSpan(
                      text: 'Ease',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.loginScreen),
            child: const Text(
              'Login',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.mutedForeground,
              ),
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.registerScreen),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
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
    );
  }
}

// ── HERO SECTION ─────────────────────────────────────────────────
class _Hero extends StatelessWidget {
  final VoidCallback onHow;
  const _Hero({required this.onHow});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0F5A34), // Rich emerald dark green
            Color(0xFF1B8B4B), // ServEase brand green
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🇵🇰 ', style: TextStyle(fontSize: 12)),
                Text(
                  'Pakistan\'s Home Services for Women',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Your Home.\nOur Experts.',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.1,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Book verified female professionals for tailoring, beauty, mehndi, cleaning & tutoring services — right to your doorstep.',
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 24),

          // SEARCH BAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    onTap: () {
                      Get.toNamed(AppRoutes.loginScreen);
                      Get.snackbar(
                        'Authentication Required',
                        'Please login or register to search and book services.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.foreground.withOpacity(0.9),
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                      );
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search tailoring, cleaning, mehndi...',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                      filled: false,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: AppColors.accent,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onHow,
                child: const Row(
                  children: [
                    Text(
                      'See how it works',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_downward_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ],
                ),
              ),
              const Row(
                children: [
                  Icon(
                    Icons.verified_user_rounded,
                    color: AppColors.accent,
                    size: 14,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '100% CNIC Verified',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
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

// ── SERVICES GRID ────────────────────────────────────────────────
class _ServicesGrid extends StatelessWidget {
  const _ServicesGrid();

  static const services = [
    {'e': '🧵', 'n': 'Tailoring', 'c': 0xFFFFF2F4, 'b': 0xFFFFCCD5},
    {'e': '🧹', 'n': 'Cleaning', 'c': 0xFFEBF6EE, 'b': 0xFFC6EAD0},
    {'e': '💄', 'n': 'Beauty & Parlor', 'c': 0xFFFFF1FD, 'b': 0xFFFCD3FA},
    {'e': '🌿', 'n': 'Mehndi Artist', 'c': 0xFFF3F9EA, 'b': 0xFFDCEDB9},
    {'e': '📚', 'n': 'Home Tutor', 'c': 0xFFEDF4FE, 'b': 0xFFC7DEFC},
    {'e': '👶', 'n': 'Babysitting', 'c': 0xFFFFF9E6, 'b': 0xFFFEE8A2},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our Core Services',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.foreground,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Select a category to find specialized partners',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.loginScreen),
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (_, i) {
              final s = services[i];
              return GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.loginScreen);
                  Get.snackbar(
                    'Authentication Required',
                    'Please login or register to book ${s['n']}.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.foreground.withOpacity(0.9),
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(s['c'] as int),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(s['b'] as int), width: 1.2),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          s['e'] as String,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        s['n'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.foreground,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── FEATURED PROVIDERS (DYNAMIC OR BEAUTIFUL FALLBACK) ──────────
class _FeaturedProviders extends StatelessWidget {
  final List<dynamic> providers;
  final bool isLoading;

  const _FeaturedProviders({required this.providers, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    // If loading, show circular progress
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    // If no real providers found in DB, show empty state message (no mock data)
    if (providers.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.people_outline_rounded, size: 40, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                'No active providers available yet',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Meet Our Top-Rated Providers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.foreground,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Directly active and verified professionals ready to serve you',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: providers.length,
            itemBuilder: (_, i) {
              final p = providers[i];
              final name = p['name'] ?? 'Provider';
              final service = p['service'] ?? 'Home Specialist';
              final rating = double.tryParse(p['rating'].toString()) ?? 4.8;
              final jobs = p['jobs_done'] ?? 10;

              // Visual styling fallback
              final char = name.isNotEmpty ? name[0].toUpperCase() : 'P';
              final bg = i == 0
                  ? 0xFFFFF2F4
                  : (i == 1 ? 0xFFEBF6EE : 0xFFFFF9E6);
              final color = i == 0
                  ? 0xFFE91E63
                  : (i == 1 ? 0xFF2E7D32 : 0xFFF59E0B);

              return GestureDetector(
                onTap: () {
                  final int providerId = p['id'] ?? 1;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProviderDetailScreen(providerId: providerId),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFEBF2EC),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Profile Circle
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(bg),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          char,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(color),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.foreground,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.verified_rounded,
                                  color: AppColors.primary,
                                  size: 15,
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              service,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.mutedForeground,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber[700],
                                  size: 14,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '$rating Rating',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.foreground,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '•   $jobs Jobs Done',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Action Button
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
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
      'desc': 'Sign up as a customer or partner in under 2 minutes.',
      'icon': Icons.person_add_rounded,
    },
    {
      'n': '2',
      'title': 'Choose a Service',
      'desc': 'Browse verified providers filtered by ratings and rates.',
      'icon': Icons.search_rounded,
    },
    {
      'n': '3',
      'title': 'Book Instantly',
      'desc': 'Pick a date and confirm your booking securely.',
      'icon': Icons.calendar_today_rounded,
    },
    {
      'n': '4',
      'title': 'Job Done & Pay',
      'desc': 'Get service, pay cash/transfer, and leave reviews.',
      'icon': Icons.task_alt_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'How It Works',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.foreground,
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
                Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: i == 0
                            ? AppColors.primary
                            : const Color(0xFFF3F5F3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        s['icon'] as IconData,
                        size: 18,
                        color: i == 0
                            ? Colors.white
                            : AppColors.mutedForeground,
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 48,
                        color: const Color(0xFFEBF2EC),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8, bottom: isLast ? 0 : 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s['title'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.foreground,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          s['desc'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.mutedForeground,
                            height: 1.5,
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

// ── STATS STRIP ──────────────────────────────────────────────────
class _StatsStrip extends StatelessWidget {
  const _StatsStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _StatItem(value: '50+', label: 'Verified Partners'),
          _StatItem(value: '6', label: 'Core Categories'),
          _StatItem(value: '100%', label: 'CNIC Checked'),
          _StatItem(value: '24/7', label: 'Safety Support'),
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
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: Colors.white.withOpacity(0.75),
            letterSpacing: 0.2,
            fontWeight: FontWeight.w500,
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
      color: AppColors.foreground,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
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
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: 'Ease',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Connecting homes with skilled, verified female service partners.',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: Colors.white.withOpacity(0.08)),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© 2026 ServEase Pakistan',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.4),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Made with ❤️ by ServEase Team',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.4),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'powered by sandboxed.pk',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
