import 'package:flutter/material.dart';

class AppTheme {
  // ─────────────────────────────────────────────
  // Colors
  // ─────────────────────────────────────────────
  static const Color primaryGreen      = Color(0xFF1A5C35);
  static const Color primaryGreenLight = Color(0xFF2DAA55);
  static const Color primaryGreenDark  = Color(0xFF0D3F1F);

  static const Color accentOrange      = Color(0xFFF5A623);
  static const Color accentOrangeDark  = Color(0xFFE09010);

  static const Color surfaceWhite      = Color(0xFFFFFFFF);

  // Soft background color (light, easy on the eyes)
  static const Color backgroundColor   = Color(0xFFF2F2F0);

  static const Color textDark   = Color(0xFF1A1A1A);
  static const Color textGray   = Color(0xFF666666);
  static const Color textLight  = Color(0xFFB3B3B3);
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color errorRed    = Color(0xFFD32F2F);

  // ─────────────────────────────────────────────
  // Gradients
  // ─────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGreen, primaryGreenLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [primaryGreen, primaryGreenLight, accentOrange],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ─────────────────────────────────────────────
  // Shadows
  // ─────────────────────────────────────────────
  static final List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Colors.black.withAlpha(51),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
}