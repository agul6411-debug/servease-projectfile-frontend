import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ServEase — Green & Orange Theme
/// Primary: Green (#1B8B4B) — brand identity
/// Accent:  Orange (#E8845A) — highlights, CTAs
class AppColors {
  AppColors._();

  // ── Backgrounds ─────────────────────────────────────────────────────
  static const Color background = Color(0xFFF5F8F0); // warm light green-white
  static const Color surface = Color(0xFFF8F9FA); // neutral surface
  static const Color card = Color(0xFFFFFFFF); // pure white card
  static const Color cardAlt = Color(0xFFF0F7F2); // light green tint card

  // ── Text ─────────────────────────────────────────────────────────────
  static const Color foreground = Color(0xFF1C1B1F); // near-black
  static const Color cardForeground = Color(0xFF1C1B1F);
  static const Color mutedForeground = Color(0xFF757575);
  static const Color textDark = Color(0xFF1C1B1F);
  static const Color textMuted = Color(0xFF757575);

  // ── Primary — GREEN (ServEase brand) ─────────────────────────────────
  static const Color primary = Color(0xFF1B8B4B); // ServEase green
  static const Color primaryLight = Color(0xFF4CAF50); // lighter green
  static const Color primaryForeground = Color(0xFFFFFFFF);
  static const Color primaryGreen = Color(0xFF1B8B4B); // alias kept for compat

  // ── Secondary — ORANGE (accent / CTA) ────────────────────────────────
  static const Color secondary = Color(0xFFE8845A); // warm orange
  static const Color secondaryForeground = Color(0xFFFFFFFF);
  // alias: keeps old screens that referenced 'orange as primary' working
  static const Color accent = Color(0xFFE8845A);
  static const Color accentForeground = Color(0xFFFFFFFF);

  // ── Semantic status colors ────────────────────────────────────────────
  static const Color success = Color(0xFF1B8B4B); // green
  static const Color successBg = Color(0xFFE8F5E9); // pale green bg
  static const Color warning = Color(0xFFFFB300); // amber
  static const Color warningBg = Color(0xFFFFF3E0); // pale orange bg
  static const Color destructive = Color(0xFFE05C5C); // soft red
  static const Color destructiveForeground = Color(0xFFFFFFFF);
  static const Color declineRed = Color(0xFFEF5350); // bright decline red
  static const Color errorBg = Color(0xFFFFCDD2); // pale red bg
  static const Color mediumRed = Color(0xFFE57373); // medium red

  // ── Borders & Dividers ───────────────────────────────────────────────
  static const Color border = Color(0xFFE0EFE5); // light green border
  static const Color borderLight = Color(0xFFEEEEEE); // neutral border
  static const Color input = Colors.transparent;
  static const Color inputBackground = Color(0xFFF0F7F2); // light green fill
  static const Color switchBackground = Color(0xFFC8DFC9); // muted green

  // ── Misc ────────────────────────────────────────────────────────────
  static const Color muted = Color(0xFFECF3EE); // muted green-white
  static const Color ring = Color(0xFF1B8B4B);
  static const Color bgGrey = Color(0xFFF7F8FA);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color cream = Color(0xFFFFF4EA);
  static const Color accentYellow = Color(0xFFFFB300);
  static const Color lightYellow = Color(0xFFFFF8E1);
  static const Color yellowBorder = Color(0xFFFFE082);
  static const Color newBadge = Color(0xFF1B8B4B);
  static const Color softPink = Color(0xFFFFC1D1);
  static const Color darkMaroon = Color(0xFF4E342E);
  static const Color popover = Color(0xFFFFFFFF);
  static const Color popoverForeground = Color(0xFF1C1B1F);

  // ── Charts ──────────────────────────────────────────────────────────
  static const Color chart1 = Color(0xFF1B8B4B); // primary green
  static const Color chart2 = Color(0xFFE8845A); // orange
  static const Color chart3 = Color(0xFF4CAF50); // lighter green
  static const Color chart4 = Color(0xFFF5B87A); // light orange
  static const Color chart5 = Color(0xFF2E7D32); // dark green

  // ── Sidebar ──────────────────────────────────────────────────────────
  static const Color sidebar = Color(0xFF145C32); // dark green sidebar
  static const Color sidebarForeground = Color(0xFFFFFFFF);
  static const Color sidebarPrimary = Color(
    0xFFE8845A,
  ); // orange accent on sidebar
  static const Color sidebarPrimaryForeground = Color(0xFFFFFFFF);
  static const Color sidebarAccent = Color(0xFF1F6B3E); // medium green
  static const Color sidebarAccentForeground = Color(0xFFFFFFFF);
  static const Color sidebarBorder = Color(0xFF1F6B3E);
  static const Color sidebarRing = Color(0xFFE8845A);
}

/// Border radius tokens
class AppRadius {
  AppRadius._();
  static const double base = 10.0;
  static const double sm = 6.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double xxl = 24.0;
}

/// Font weight tokens
class AppFontWeights {
  AppFontWeights._();
  static const FontWeight light = FontWeight.w300;
  static const FontWeight normal = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

/// ServEase Light Theme — Green Primary, Orange Accent
ThemeData get lightTheme {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      surface: AppColors.card,
      onSurface: AppColors.cardForeground,
      primary: AppColors.primary,
      onPrimary: AppColors.primaryForeground,
      secondary: AppColors.secondary,
      onSecondary: AppColors.secondaryForeground,
      tertiary: AppColors.accentYellow,
      error: AppColors.destructive,
      onError: AppColors.destructiveForeground,
      outline: AppColors.border,
    ),
    dividerColor: AppColors.border,
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.destructive, width: 1),
      ),
      labelStyle: const TextStyle(color: AppColors.mutedForeground),
      hintStyle: const TextStyle(color: AppColors.mutedForeground),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.primaryForeground,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        textStyle: const TextStyle(
          fontWeight: AppFontWeights.semiBold,
          fontSize: 15,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(fontWeight: AppFontWeights.medium),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.primaryForeground,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        color: AppColors.primaryForeground,
        fontSize: 18,
        fontWeight: AppFontWeights.semiBold,
      ),
      iconTheme: const IconThemeData(color: AppColors.primaryForeground),
    ),
    textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
      bodyMedium: GoogleFonts.inter(
        color: AppColors.foreground,
        fontWeight: AppFontWeights.normal,
        fontSize: 15,
      ),
      bodyLarge: GoogleFonts.inter(
        color: AppColors.foreground,
        fontWeight: AppFontWeights.normal,
        fontSize: 16,
      ),
      titleMedium: GoogleFonts.inter(
        color: AppColors.foreground,
        fontWeight: AppFontWeights.semiBold,
        fontSize: 16,
      ),
      titleLarge: GoogleFonts.inter(
        color: AppColors.foreground,
        fontWeight: AppFontWeights.bold,
        fontSize: 20,
      ),
      headlineSmall: GoogleFonts.inter(
        color: AppColors.foreground,
        fontWeight: AppFontWeights.bold,
        fontSize: 24,
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.foreground,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.muted,
      labelStyle: const TextStyle(color: AppColors.foreground, fontSize: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.primary
            : Colors.grey,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.primaryLight
            : Colors.grey.shade300,
      ),
    ),
  );
}

ThemeData buildAppTheme() => lightTheme;
