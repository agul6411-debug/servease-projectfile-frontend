import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// DashedRing - Draws a dashed circular ring
class DashedRing extends StatelessWidget {
  final double size, opacity;
  const DashedRing({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(color: AppColors.teal.withOpacity(opacity)),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final Color color;
  _RingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const segmentCount = 44;
    const step = math.pi * 2 / segmentCount;
    
    for (int i = 0; i < segmentCount; i += 2) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * step,
        step * 0.55,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter o) => false;
}

/// OrbitEntry - Data class for orbit icons
class OrbitEntry {
  final String emoji, label;
  final double radius, startAngle, speed;
  final bool reverse;

  const OrbitEntry(
    this.emoji,
    this.label,
    this.radius,
    this.startAngle,
    this.reverse,
    this.speed,
  );
}

/// OrbitIcon - Icon that orbits around a center point
class OrbitIcon extends StatelessWidget {
  final AnimationController controller;
  final OrbitEntry entry;

  const OrbitIcon({
    required this.controller,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, child) {
        final angle = entry.startAngle +
            (entry.reverse ? -1 : 1) *
                controller.value *
                math.pi *
                2 *
                entry.speed;
        return Transform.translate(
          offset: Offset(
            entry.radius * math.cos(angle),
            entry.radius * math.sin(angle),
          ),
          child: child,
        );
      },
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AppColors.teal.withOpacity(0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(entry.emoji, style: const TextStyle(fontSize: 20)),
            Text(
              entry.label,
              style: const TextStyle(
                fontSize: 7,
                color: AppColors.muted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
