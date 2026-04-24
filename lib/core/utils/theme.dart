import 'package:flutter/material.dart';

class AppTheme {
  // ─────────────────────────────────────────────
  // Colors
  // ─────────────────────────────────────────────
  static const Color primaryGreen = Color(0xFF1A5C35);
  static const Color primaryGreenLight = Color(0xFF2D8A50);
  static const Color primaryGreenDark = Color(0xFF0D3F1F);
  static const Color accentOrange = Color(0xFFF5A623);
  static const Color accentOrangeDark = Color(0xFFE09010);
  static const Color backgroundColor = Color(0xFFF2F2F0);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textGray = Color(0xFF666666);
  static const Color textLight = Color(0xFFB3B3B3);
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFFA726);

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

  static const LinearGradient ctaGradient = LinearGradient(
    colors: [primaryGreen, accentOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─────────────────────────────────────────────
  // Text Styles
  // ─────────────────────────────────────────────
  static const TextStyle headingLarge = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.bold,
    color: textDark,
    height: 1.2,
    letterSpacing: 0.5,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textDark,
    height: 1.3,
    letterSpacing: 0.3,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textDark,
    height: 1.4,
    letterSpacing: 0.2,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textDark,
    height: 1.6,
    letterSpacing: 0.15,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textDark,
    height: 1.5,
    letterSpacing: 0.1,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textGray,
    height: 1.4,
    letterSpacing: 0.05,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: textDark,
    letterSpacing: 0.2,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: textDark,
    letterSpacing: 0.15,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: textGray,
    letterSpacing: 0.1,
  );

  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.3,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  // ─────────────────────────────────────────────
  // Input Decorations
  // ─────────────────────────────────────────────
  static InputDecoration getInputDecoration({
    required String labelText,
    required String hintText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixIconTap,
    bool isError = false,
    String? errorText,
    bool isDark = false,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      filled: true,
      fillColor: isDark ? Colors.transparent : surfaceWhite,
      labelStyle: TextStyle(
        color: isDark ? Colors.white.withAlpha(179) : textGray,
        fontSize: 14,
      ),
      hintStyle: TextStyle(
        color: isDark ? Colors.white.withAlpha(102) : textLight,
        fontSize: 14,
      ),
      errorStyle: const TextStyle(
        color: errorRed,
        fontSize: 12,
      ),
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              color: isDark ? Colors.white70 : primaryGreen,
              size: 20,
            )
          : null,
      suffixIcon: suffixIcon != null
          ? GestureDetector(
              onTap: onSuffixIconTap,
              child: Icon(
                suffixIcon,
                color: isDark ? Colors.white70 : primaryGreen,
                size: 20,
              ),
            )
          : null,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.white.withAlpha(77) : borderLight,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.white : primaryGreen,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: errorRed,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: errorRed,
          width: 2,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.white.withAlpha(51) : borderLight,
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Button Styles
  // ─────────────────────────────────────────────
  static ButtonStyle primaryButtonStyle({double? width, double? height}) {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 0,
      textStyle: buttonMedium,
    );
  }

  static ButtonStyle secondaryButtonStyle({double? width, double? height}) {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: primaryGreen,
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(
          color: primaryGreen,
          width: 1.5,
        ),
      ),
      elevation: 0,
      textStyle: buttonMedium,
    );
  }

  static ButtonStyle accentButtonStyle({double? width, double? height}) {
    return ElevatedButton.styleFrom(
      backgroundColor: accentOrange,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 0,
      textStyle: buttonMedium,
    );
  }

  // ─────────────────────────────────────────────
  // Box Shadows
  // ─────────────────────────────────────────────
  static const List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static final List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Colors.black.withAlpha(38),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Colors.black.withAlpha(51),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> shadowCustom(Color color) => [
        BoxShadow(
          color: color.withAlpha(46),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  // ─────────────────────────────────────────────
  // Border Radius
  // ─────────────────────────────────────────────
  static const BorderRadius radiusSmall = BorderRadius.all(Radius.circular(8));
  static const BorderRadius radiusMedium = BorderRadius.all(Radius.circular(12));
  static const BorderRadius radiusLarge = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radiusXLarge = BorderRadius.all(Radius.circular(24));
  static const BorderRadius radiusRound = BorderRadius.all(Radius.circular(30));

  // ─────────────────────────────────────────────
  // Spacing
  // ─────────────────────────────────────────────
  static const double spacingXSmall = 4;
  static const double spacingSmall = 8;
  static const double spacingMedium = 12;
  static const double spacingLarge = 16;
  static const double spacingXLarge = 20;
  static const double spacing2XL = 24;
  static const double spacing3XL = 32;
  static const double spacing4XL = 48;
  static const double spacing5XL = 56;
  static const double spacing6XL = 64;

  // ─────────────────────────────────────────────
  // Responsive Breakpoints
  // ─────────────────────────────────────────────
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopBreakpoint;

  // ─────────────────────────────────────────────
  // Responsive Padding
  // ─────────────────────────────────────────────
  static EdgeInsets getHorizontalPadding(BuildContext context, {bool isMobileOnly = false}) {
    final width = MediaQuery.of(context).size.width;
    final isMobileDevice = width < mobileBreakpoint;

    double padding;
    if (isMobileDevice) {
      padding = spacing3XL; // 32
    } else if (width < tabletBreakpoint) {
      padding = spacing5XL; // 56
    } else {
      padding = spacing5XL; // 56
    }

    return EdgeInsets.symmetric(horizontal: padding);
  }

  static EdgeInsets getVerticalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobileDevice = width < mobileBreakpoint;

    double padding;
    if (isMobileDevice) {
      padding = spacing2XL; // 24
    } else if (width < tabletBreakpoint) {
      padding = spacing5XL; // 56
    } else {
      padding = spacing5XL; // 56
    }

    return EdgeInsets.symmetric(vertical: padding);
  }

  static EdgeInsets getAllPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobileDevice = width < mobileBreakpoint;

    double padding;
    if (isMobileDevice) {
      padding = spacingLarge; // 16
    } else if (width < tabletBreakpoint) {
      padding = spacing3XL; // 32
    } else {
      padding = spacing5XL; // 56
    }

    return EdgeInsets.all(padding);
  }

  // ─────────────────────────────────────────────
  // Responsive Font Sizes
  // ─────────────────────────────────────────────
  static double getHeadingFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) return 28;
    if (width < tabletBreakpoint) return 36;
    return 42;
  }

  static double getBodyFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) return 13;
    return 16;
  }

  static double getSmallFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) return 11;
    return 12;
  }

  // ─────────────────────────────────────────────
  // ThemeData
  // ─────────────────────────────────────────────
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceWhite,
        border: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: const BorderSide(color: borderLight, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: const BorderSide(color: errorRed),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: primaryButtonStyle(),
      ),
      textTheme: const TextTheme(
        displayLarge: headingLarge,
        displayMedium: headingMedium,
        displaySmall: headingSmall,
        headlineSmall: labelLarge,
        titleLarge: bodyLarge,
        titleMedium: bodyMedium,
        titleSmall: bodySmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryGreen,
        secondary: accentOrange,
        surface: surfaceWhite,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textDark,
        onError: Colors.white,
      ),
    );
  }
}
