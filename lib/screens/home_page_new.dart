import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../sections/app_bar_section.dart';
import '../sections/hero_section.dart';
import '../sections/services_section.dart';
import '../sections/how_it_works_section.dart';
import '../sections/features_section.dart';
import '../sections/user_types_section.dart';
import '../sections/cta_section.dart';
import '../sections/footer_section.dart';

/// HomePage - Main landing page with all sections
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _orbitController;
  late final AnimationController _entryController;
  late final List<Animation<double>> _fadeAnimations;
  late final List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  /// Initialize all animation controllers
  void _initializeAnimations() {
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )..repeat();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Create fade animations with staggered timing
    _fadeAnimations = List.generate(6, (i) {
      final start = (i * 0.13).clamp(0.0, 1.0);
      final end = (start + 0.38).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _entryController,
        curve: Interval(start, end, curve: Curves.easeOut),
      );
    });

    // Create slide animations based on fade
    _slideAnimations = _fadeAnimations
        .map(
          (fade) => Tween<Offset>(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(fade),
        )
        .toList();

    _entryController.forward();
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          AppBarSection(),
          SliverToBoxAdapter(
            child: HeroSection(
              fadeAnimations: _fadeAnimations,
              slideAnimations: _slideAnimations,
              orbitController: _orbitController,
            ),
          ),
          SliverToBoxAdapter(child: const ServicesSection()),
          SliverToBoxAdapter(child: const HowItWorksSection()),
          SliverToBoxAdapter(child: const FeaturesSection()),
          SliverToBoxAdapter(child: const UserTypesSection()),
          SliverToBoxAdapter(child: const CtaSection()),
          SliverToBoxAdapter(child: const FooterSection()),
        ],
      ),
    );
  }
}
