import 'package:flutter/material.dart';

/// Orange & Green — Soft Pastel Theme
class AppColors {
  AppColors._();

  static const Color background = Color(0xFFFFFBF5); // warm white
  static const Color foreground = Color(0xFF2D2A24); // soft dark brown-black

  static const Color card = Color(0xFFFFF8EF); // creamy white
  static const Color cardForeground = Color(0xFF2D2A24);

  static const Color popover = Color(0xFFFFF8EF);
  static const Color popoverForeground = Color(0xFF2D2A24);

  // Orange as primary
  static const Color primary = Color(0xFFE8845A); // soft pastel orange
  static const Color primaryForeground = Color(0xFFFFFFFF);

  // Green as secondary
  static const Color secondary = Color(0xFF7DBF8E); // soft pastel green
  static const Color secondaryForeground = Color(0xFFFFFFFF);

  static const Color muted = Color(0xFFF5EDE3); // light warm peach
  static const Color mutedForeground = Color(0xFF9A8878); // muted brown-grey

  static const Color accent = Color(0xFFD4EDD9); // light mint green
  static const Color accentForeground = Color(0xFF2D5C3A); // deep green

  static const Color destructive = Color(0xFFE05C5C); // soft red
  static const Color destructiveForeground = Color(0xFFFFFFFF);

  static const Color border = Color(0xFFEDD9C8); // warm peach border
  static const Color input = Colors.transparent;
  static const Color inputBackground = Color(0xFFFFF2E6); // light orange tint
  static const Color switchBackground = Color(0xFFC8DFC9); // muted green

  static const Color ring = Color(0xFFE8845A); // orange ring

  // Charts
  static const Color chart1 = Color(0xFFE8845A); // orange
  static const Color chart2 = Color(0xFF7DBF8E); // green
  static const Color chart3 = Color(0xFFF5B87A); // light orange
  static const Color chart4 = Color(0xFFA8D5B0); // light green
  static const Color chart5 = Color(0xFFD4956A); // deep peach

  // Sidebar
  static const Color sidebar = Color(0xFFFFF4EA); // warm cream
  static const Color sidebarForeground = Color(0xFF2D2A24);
  static const Color sidebarPrimary = Color(0xFFE8845A);
  static const Color sidebarPrimaryForeground = Color(0xFFFFFFFF);
  static const Color sidebarAccent = Color(0xFFD4EDD9); // mint
  static const Color sidebarAccentForeground = Color(0xFF2D5C3A);
  static const Color sidebarBorder = Color(0xFFEDD9C8);
  static const Color sidebarRing = Color(0xFFE8845A);

  static const Color cream = Color(0xFFFFF4EA); // soft cream background
  static const Color success = Color(
    0xFF4CAF50,
  ); // green used for success states

  static const Color primaryGreen = Color(0xFF1B8B4B); // provider primary green
  static const Color declineRed = Color(0xFFEF5350); // decline action red
  static const Color bgGrey = Color(0xFFF7F8FA); // light grey background
  static const Color textMuted = Color(0xFF757575); // muted text color
  static const Color cardBg = Color(0xFFFFFFFF); // card background
  static const Color accentYellow = Color(
    0xFFFFB300,
  ); // accent yellow for highlights
  static const Color lightYellow = Color(0xFFFFF8E1); // pale yellow background
  static const Color yellowBorder = Color(
    0xFFFFE082,
  ); // yellow border for banners
  static const Color newBadge = Color(
    0xFF4CAF50,
  ); // green badge color for new requests

  static const Color softPink = Color(0xFFFFC1D1); // gentle pink accent
  static const Color warningBg = Color(0xFFFFF3E0); // warm warning background
  static const Color errorBg = Color(0xFFFFCDD2); // light error background
  static const Color mediumRed = Color(0xFFE57373); // medium red accent
  static const Color successBg = Color(
    0xFFE8F5E9,
  ); // light green success background
  static const Color darkMaroon = Color(0xFF4E342E); // deep maroon tone
  static const Color surface = Color(0xFFF8F9FA); // surface background
  static const Color textDark = Color(0xFF1C1B1F); // dark text color
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

/// Light Theme — Soft Pastel Orange & Green
ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: const ColorScheme.light(
    background: AppColors.background,
    onBackground: AppColors.foreground,
    surface: AppColors.card,
    onSurface: AppColors.cardForeground,
    primary: AppColors.primary,
    onPrimary: AppColors.primaryForeground,
    secondary: AppColors.secondary,
    onSecondary: AppColors.secondaryForeground,
    tertiary: AppColors.accent,
    onTertiary: AppColors.accentForeground,
    error: AppColors.destructive,
    onError: AppColors.destructiveForeground,
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
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: AppColors.foreground,
      fontWeight: AppFontWeights.normal,
      fontSize: 16,
    ),
  ),
);

ThemeData buildAppTheme() => lightTheme;
