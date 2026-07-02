import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Brown & Beige — Primary Theme
/// Accent palette: A5C89E (sage), FFFBB1 (pale yellow), D8E983 (lime), AEB877 (olive)
class AppColors {
  AppColors._();

  // ---- Core brown & beige base ----
  static const Color background = Color(0xFFF5EFE6); // warm beige
  static const Color foreground = Color(0xFF3B2F2A); // deep brown text

  static const Color card = Color(0xFFFFFBF5); // soft cream card
  static const Color cardForeground = Color(0xFF3B2F2A);

  static const Color popover = Color(0xFFFFFBF5);
  static const Color popoverForeground = Color(0xFF3B2F2A);

  // Primary — brown
  static const Color primary = Color(0xFF6F4E37); // coffee brown
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Secondary — beige/olive accent
  static const Color secondary = Color(0xFFAEB877); // olive
  static const Color secondaryBackground = Color(0xFFF1EFD8); // pale olive bg
  static const Color onSecondary = Color(0xFF3B2F2A);

  static const Color muted = Color(0xFFE9DFCF); // muted beige
  static const Color mutedForeground = Color(0xFF8A7B6C); // muted brown-grey

  // Accent — sage / lime from palette
  static const Color accent = Color(0xFFA5C89E); // sage green
  static const Color onAccent = Color(0xFF234B2E);

  static const Color accentSecondary = Color(0xFFD8E983); // lime
  static const Color onAccentSecondary = Color(0xFF3B3F1A);

  static const Color highlight = Color(0xFFFFFBB1); // pale yellow
  static const Color onHighlight = Color(0xFF5C5320);

  // ---- States ----
  static const Color active = Color(0xFF6F4E37); // brown for active state
  static const Color onActive = Color(0xFFFFFFFF);

  static const Color surface = Color(0xFFFFFBF5);
  static const Color onSurface = Color(0xFF3B2F2A);

  static const Color success = Color(0xFF7DA86B);
  static const Color onSuccess = Color(0xFFFFFFFF);

  static const Color warning = Color(0xFFD8B96A);
  static const Color onWarning = Color(0xFF3B2F2A);

  static const Color error = Color(0xFFC0564B);
  static const Color onError = Color(0xFFFFFFFF);

  static const Color destructive = error;
  static const Color destructiveForeground = onError;

  static const Color border = Color(0xFFE3D5C0); // beige border
  static const Color input = Colors.transparent;
  static const Color inputBackground = Color(0xFFF1E9DA); // light beige tint
  static const Color switchBackground = Color(0xFFD7CDB8);

  static const Color ring = Color(0xFF6F4E37);

  // ---- Charts ----
  static const Color chart1 = Color(0xFF6F4E37); // brown
  static const Color chart2 = Color(0xFFA5C89E); // sage
  static const Color chart3 = Color(0xFFD8E983); // lime
  static const Color chart4 = Color(0xFFAEB877); // olive
  static const Color chart5 = Color(0xFFFFFBB1); // pale yellow

  // ---- Legacy aliases (screen compatibility) ----
  static const Color cream = Color(0xFFF1E9DA);
  static const Color softPink = Color(0xFFF2C4C4);
  static const Color primaryGreen = Color(0xFF4A7C59);
  static const Color declineRed = error;
  static const Color bgGrey = Color(0xFFF5EFE6);
  static const Color textMuted = mutedForeground;
  static const Color cardBg = card;
  static const Color accentYellow = Color(0xFFD8B96A);
  static const Color lightYellow = highlight;
  static const Color yellowBorder = Color(0xFFE8D5A0);
  static const Color newBadge = success;
  static const Color warningBg = Color(0xFFF5EDD0);
  static const Color errorBg = Color(0xFFF8D7D4);
  static const Color mediumRed = Color(0xFFD07070);
  static const Color successBg = Color(0xFFE4F0DE);
  static const Color darkMaroon = Color(0xFF4E342E);
  static const Color textDark = foreground;

  // ---- Sidebar ----
  static const Color sidebar = Color(0xFFF1E9DA);
  static const Color sidebarForeground = Color(0xFF3B2F2A);
  static const Color sidebarPrimary = Color(0xFF6F4E37);
  static const Color sidebarPrimaryForeground = Color(0xFFFFFFFF);
  static const Color sidebarAccent = Color(0xFFA5C89E);
  static const Color sidebarAccentForeground = Color(0xFF234B2E);
  static const Color sidebarBorder = Color(0xFFE3D5C0);
  static const Color sidebarRing = Color(0xFF6F4E37);
}

/// Border radius tokens
class AppRadius {
  AppRadius._();

  static const double base = 10.0;
  static const double sm = 6.0;
  static const double md = 8.0;
  static const double lg = 10.0;
  static const double xl = 14.0;
}

/// Font weight tokens
class AppFontWeights {
  AppFontWeights._();

  static const FontWeight normal = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
}

/// Light Theme — Brown & Beige with sage/lime/olive/yellow accents
ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: const ColorScheme.light(
    background: AppColors.background,
    onBackground: AppColors.foreground,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    tertiary: AppColors.accent,
    onTertiary: AppColors.onAccent,
    error: AppColors.error,
    onError: AppColors.onError,
    outline: AppColors.border,
  ),
  dividerColor: AppColors.border,
  cardTheme: CardThemeData(
    color: AppColors.card,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      side: const BorderSide(color: AppColors.border),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputBackground,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide.none,
    ),
  ),
  textTheme: GoogleFonts.poppinsTextTheme().copyWith(
    bodyMedium: const TextStyle(
      color: AppColors.foreground,
      fontWeight: AppFontWeights.normal,
      fontSize: 16,
    ),
  ),
);

ThemeData buildAppTheme() => lightTheme;
