import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// ServiceData - Data class for a service item
class ServiceData {
  final String emoji, name, description;
  const ServiceData(this.emoji, this.name, this.description);
}

/// ServiceCard - Card displaying a single service
class ServiceCard extends StatefulWidget {
  final ServiceData service;
  const ServiceCard({required this.service});

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.cream : Colors.white,
          border: Border.all(color: AppColors.teal.withOpacity(0.1)),
        ),
        padding: const EdgeInsets.all(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: _isHovered
                    ? AppColors.teal
                    : AppColors.teal.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  widget.service.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.service.name,
              style: const TextStyle(
                fontFamily: 'Georgia',
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                widget.service.description,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.muted,
                  height: 1.6,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// StepData - Data class for step in "how it works"
class StepData {
  final String number, title, description;
  const StepData(this.number, this.title, this.description);
}

/// StepCard - Card showing a single process step
class StepCard extends StatefulWidget {
  final StepData step;
  const StepCard({required this.step});

  @override
  State<StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<StepCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: _isHovered ? AppColors.teal : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.teal.withOpacity(0.18),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.teal.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.step.number,
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _isHovered ? Colors.white : AppColors.teal,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              widget.step.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.step.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.muted,
                height: 1.65,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// FeatureData - Data class for a platform feature
class FeatureData {
  final String emoji, title, description;
  const FeatureData(this.emoji, this.title, this.description);
}

/// FeatureCard - Card displaying a platform feature
class FeatureCard extends StatefulWidget {
  final FeatureData feature;
  const FeatureCard({required this.feature});

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(_isHovered ? 0.07 : 0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? AppColors.teal.withOpacity(0.45)
                : Colors.white.withOpacity(0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.teal.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  widget.feature.emoji,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.feature.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.feature.description,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white38,
                height: 1.7,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
