import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';
import '../widgets/animation_widgets.dart';
import '../widgets/common_widgets.dart';

/// HeroSection - Main hero section with animated text and orbit
class HeroSection extends StatelessWidget {
  final List<Animation<double>> fadeAnimations;
  final List<Animation<Offset>> slideAnimations;
  final AnimationController orbitController;

  const HeroSection({
    super.key,
    required this.fadeAnimations,
    required this.slideAnimations,
    required this.orbitController,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 860;

    return Container(
      color: AppColors.cream,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 56 : 24,
        vertical: isWide ? 80 : 56,
      ),
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 55, child: _buildHeroText(context)),
                const SizedBox(width: 56),
                Expanded(flex: 45, child: _buildOrbit(context)),
              ],
            )
          : Column(
              children: [
                _buildHeroText(context),
                const SizedBox(height: 56),
                _buildOrbit(context),
              ],
            ),
    );
  }

  /// Build hero text section with animations
  Widget _buildHeroText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pill Tag
        FadeTransition(
          opacity: fadeAnimations[0],
          child: SlideTransition(
            position: slideAnimations[0],
            child: _buildPillTag(),
          ),
        ),
        const SizedBox(height: 28),

        // Title
        FadeTransition(
          opacity: fadeAnimations[1],
          child: SlideTransition(
            position: slideAnimations[1],
            child: _buildTitle(),
          ),
        ),
        const SizedBox(height: 24),

        // Subtitle
        FadeTransition(
          opacity: fadeAnimations[2],
          child: SlideTransition(
            position: slideAnimations[2],
            child: _buildSubtitle(),
          ),
        ),
        const SizedBox(height: 36),

        // Buttons
        FadeTransition(
          opacity: fadeAnimations[3],
          child: SlideTransition(
            position: slideAnimations[3],
            child: _buildActionButtons(),
          ),
        ),
        const SizedBox(height: 56),

        // Stats
        FadeTransition(
          opacity: fadeAnimations[4],
          child: SlideTransition(
            position: slideAnimations[4],
            child: _buildStats(),
          ),
        ),
      ],
    );
  }

  /// Build pill tag at the top
  Widget _buildPillTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.teal.withOpacity(0.08),
        border: Border.all(color: AppColors.teal.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.orange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'SMART HOME SERVICES PLATFORM',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.teal,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  /// Build main title
  Widget _buildTitle() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 60,
          height: 1.05,
          color: AppColors.dark,
        ),
        children: [
          TextSpan(text: 'Your Home,\n'),
          TextSpan(
            text: 'Perfectly\n',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: AppColors.teal,
            ),
          ),
          TextSpan(
            text: 'Serviced.',
            style: TextStyle(color: AppColors.orange),
          ),
        ],
      ),
    );
  }

  /// Build subtitle text
  Widget _buildSubtitle() {
    return const Text(
      'One platform. Verified professionals. Every home service '
      'at your fingertips — booked in minutes, delivered with confidence.',
      style: TextStyle(
        fontSize: 16,
        height: 1.75,
        color: AppColors.muted,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  /// Build CTA buttons
  Widget _buildActionButtons() {
    return Wrap(
      spacing: 14,
      runSpacing: 12,
      children: [
        ElevatedButton(
          onPressed: () {
            Get.toNamed('/login');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.teal,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Get Started Free →',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        OutlinedButton(
          onPressed: () {
            Get.toNamed('/register');
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.teal,
            side: const BorderSide(color: AppColors.teal),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Explore Services', style: TextStyle(fontSize: 15)),
        ),
      ],
    );
  }

  /// Build statistics row
  Widget _buildStats() {
    return Row(
      children: const [
        StatCard(number: '8+', label: 'Service Categories'),
        StatCard(number: '3', label: 'User Portals'),
        StatCard(number: '100%', label: 'Verified Providers'),
      ],
    );
  }

  /// Build orbit animation
  Widget _buildOrbit(BuildContext context) {
    const orbitEntries = [
      OrbitEntry('🔧', 'Plumbing', 120, 0.00, false, 1.00),
      OrbitEntry('⚡', 'Electric', 120, 2.09, true, 1.00),
      OrbitEntry('🧹', 'Cleaning', 120, 4.19, false, 1.00),
      OrbitEntry('📚', 'Tutoring', 172, 0.78, true, 0.65),
      OrbitEntry('💅', 'Beauty', 172, 2.36, false, 0.65),
      OrbitEntry('🪵', 'Carpentry', 172, 3.93, true, 0.65),
      OrbitEntry('🎨', 'Painting', 172, 5.50, false, 0.65),
    ];

    return SizedBox(
      width: 380,
      height: 380,
      child: Stack(
        alignment: Alignment.center,
        children: [
          DashedRing(size: 240, opacity: 0.18),
          DashedRing(size: 344, opacity: 0.12),
          DashedRing(size: 380, opacity: 0.07),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.teal,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.teal.withOpacity(0.4),
                  blurRadius: 40,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: const Icon(
              Icons.home_repair_service,
              color: Colors.white,
              size: 40,
            ),
          ),
          ...orbitEntries.map(
            (entry) => OrbitIcon(controller: orbitController, entry: entry),
          ),
        ],
      ),
    );
  }
}
