import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextTheme get textTheme {
    return TextTheme(
      // Display styles - for the largest text elements
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
        textBaseline: TextBaseline.alphabetic,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.16,
        textBaseline: TextBaseline.alphabetic,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.22,
        textBaseline: TextBaseline.alphabetic,
      ),

      // Headline styles - for section headers
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        height: 1.25,
        textBaseline: TextBaseline.alphabetic,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        height: 1.29,
        textBaseline: TextBaseline.alphabetic,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        height: 1.33,
        textBaseline: TextBaseline.alphabetic,
      ),

      // Title styles - for content headers
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.27,
        textBaseline: TextBaseline.alphabetic,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.5,
        textBaseline: TextBaseline.alphabetic,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
        textBaseline: TextBaseline.alphabetic,
      ),

      // Body styles - for main content
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
        textBaseline: TextBaseline.alphabetic,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
        textBaseline: TextBaseline.alphabetic,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
        textBaseline: TextBaseline.alphabetic,
      ),

      // Label styles - for buttons and form fields
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
        textBaseline: TextBaseline.alphabetic,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
        textBaseline: TextBaseline.alphabetic,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
        textBaseline: TextBaseline.alphabetic,
      ),
    );
  }

  /// Helper methods for commonly used text styles
  static TextStyle get caption => textTheme.bodySmall!;
  static TextStyle get button => textTheme.labelLarge!;
  static TextStyle get subtitle => textTheme.bodyMedium!;

  /// Method to get a custom text style with specific properties
  static TextStyle getCustomStyle({
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    double? letterSpacing,
    double? height,
    Color? color,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
      textBaseline: TextBaseline.alphabetic,
    );
  }
}