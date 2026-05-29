import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Mode Colors ("Royal White/Gold")
  static const Color lightBg = Color(0xFFFCF9F8);
  static const Color lightPrimary = Color(0xFF000000);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightSecondary = Color(0xFF735C00); // Champagne Gold
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightSecondaryContainer = Color(0xFFFED65B);
  static const Color lightOnSecondaryContainer = Color(0xFF745C00);
  static const Color lightSurface = Color(0xFFFCF9F8);
  static const Color lightOnSurface = Color(0xFF1C1B1B);
  static const Color lightOnSurfaceVariant = Color(0xFF44474D);
  static const Color lightOutline = Color(0xFF75777E);
  static const Color lightOutlineVariant = Color(0xFFC5C6CD);
  static const Color lightSurfaceContainer = Color(0xFFF0EDEC);
  static const Color lightSurfaceContainerLow = Color(0xFFF6F3F2);
  static const Color lightSurfaceContainerHigh = Color(0xFFEBE7E7);

  // Dark Mode Colors ("Midnight/Champagne")
  static const Color darkBg = Color(0xFF0D141D);
  static const Color darkPrimary = Color(0xFFF2CA50); // Champagne Gold Accent
  static const Color darkOnPrimary = Color(0xFF3C2F00);
  static const Color darkSecondary = Color(0xFFCAC7B7);
  static const Color darkOnSecondary = Color(0xFF323126);
  static const Color darkSecondaryContainer = Color(0xFF4B493D);
  static const Color darkOnSecondaryContainer = Color(0xFFBCB9A9);
  static const Color darkSurface = Color(0xFF0D141D);
  static const Color darkOnSurface = Color(0xFFDCE3F0);
  static const Color darkOnSurfaceVariant = Color(0xFFD0C5AF);
  static const Color darkOutline = Color(0xFF99907C);
  static const Color darkOutlineVariant = Color(0xFF4D4635);
  static const Color darkSurfaceContainer = Color(0xFF19202A);
  static const Color darkSurfaceContainerLow = Color(0xFF151C26);
  static const Color darkSurfaceContainerHigh = Color(0xFF242A34);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor: lightBg,
      colorScheme: const ColorScheme.light(
        background: lightBg,
        primary: lightPrimary,
        onPrimary: lightOnPrimary,
        secondary: lightSecondary,
        onSecondary: lightOnSecondary,
        secondaryContainer: lightSecondaryContainer,
        onSecondaryContainer: lightOnSecondaryContainer,
        surface: lightSurface,
        onSurface: lightOnSurface,
        onSurfaceVariant: lightOnSurfaceVariant,
        outline: lightOutline,
        outlineVariant: lightOutlineVariant,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.02,
          color: lightPrimary,
        ),
        headlineLarge: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: lightPrimary,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: lightPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: lightOnSurface,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: lightOnSurface,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.05,
          color: lightPrimary,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: lightOnSurfaceVariant,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: darkBg,
      colorScheme: const ColorScheme.dark(
        background: darkBg,
        primary: darkPrimary,
        onPrimary: darkOnPrimary,
        secondary: darkSecondary,
        onSecondary: darkOnSecondary,
        secondaryContainer: darkSecondaryContainer,
        onSecondaryContainer: darkOnSecondaryContainer,
        surface: darkSurface,
        onSurface: darkOnSurface,
        onSurfaceVariant: darkOnSurfaceVariant,
        outline: darkOutline,
        outlineVariant: darkOutlineVariant,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.02,
          color: darkPrimary,
        ),
        headlineLarge: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: darkPrimary,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: darkPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: darkOnSurface,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: darkOnSurface,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.05,
          color: darkPrimary,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: darkOnSurfaceVariant,
        ),
      ),
    );
  }
}
