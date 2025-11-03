import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Saudi Vision Colors
  static const Color primaryGreen = Color(0xFF004428);
  static const Color secondaryGreen = Color(0xFF00341f);
  static const Color lightGreen = Color(0xFF006B3D);
  static const Color surfaceGreen = Color(0xFF0A5A3C);

  // Supporting Colors
  static const Color beigeAccent = Color(0xFFD4C5A9);
  static const Color whiteText = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color darkGray = Color(0xFF333333);

  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: secondaryGreen,
        surface: lightGray,
        tertiary: beigeAccent,
        brightness: Brightness.light,
      ),

      // Typography with IBM Plex Sans Arabic
      textTheme: GoogleFonts.ibmPlexSansArabicTextTheme(
        ThemeData.light().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.ibmPlexSansArabic(
          fontSize: 57,
          fontWeight: FontWeight.bold,
          color: whiteText,
        ),
        displayMedium: GoogleFonts.ibmPlexSansArabic(
          fontSize: 45,
          fontWeight: FontWeight.bold,
          color: whiteText,
        ),
        displaySmall: GoogleFonts.ibmPlexSansArabic(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          color: whiteText,
        ),
        headlineLarge: GoogleFonts.ibmPlexSansArabic(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: primaryGreen,
        ),
        headlineMedium: GoogleFonts.ibmPlexSansArabic(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: primaryGreen,
        ),
        headlineSmall: GoogleFonts.ibmPlexSansArabic(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: primaryGreen,
        ),
        titleLarge: GoogleFonts.ibmPlexSansArabic(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: darkGray,
        ),
        titleMedium: GoogleFonts.ibmPlexSansArabic(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: darkGray,
        ),
        titleSmall: GoogleFonts.ibmPlexSansArabic(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: darkGray,
        ),
        bodyLarge: GoogleFonts.ibmPlexSansArabic(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: darkGray,
        ),
        bodyMedium: GoogleFonts.ibmPlexSansArabic(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: darkGray,
        ),
        bodySmall: GoogleFonts.ibmPlexSansArabic(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: darkGray,
        ),
        labelLarge: GoogleFonts.ibmPlexSansArabic(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: whiteText,
        ),
      ),

      // Card Theme - Glassmorphic
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        color: Colors.white.withOpacity(0.2),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: whiteText,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          textStyle: GoogleFonts.ibmPlexSansArabic(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: const BorderSide(color: primaryGreen, width: 2),
          textStyle: GoogleFonts.ibmPlexSansArabic(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        size: 32,
        color: primaryGreen,
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: whiteText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.ibmPlexSansArabic(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: whiteText,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: beigeAccent,
        foregroundColor: primaryGreen,
        elevation: 4,
      ),
    );
  }

  // Gradient Backgrounds
  static LinearGradient get primaryGradient => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      primaryGreen,
      secondaryGreen,
    ],
  );

  static LinearGradient get subtleGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryGreen,
      surfaceGreen,
    ],
  );
}
