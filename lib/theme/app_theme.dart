import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF0A0A0A);
  static const Color darkGrey = Color(0xFF1A1A1A);
  static const Color mediumGrey = Color(0xFF3A3A3A);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color accentGoldLight = Color(0xFFE8D07A);
  static const Color softBlack = Color(0xFF212121);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: black,
        secondary: accentGold,
        surface: white,
        background: white,
        onPrimary: white,
        onSecondary: black,
        onSurface: black,
        onBackground: black,
      ),
      scaffoldBackgroundColor: white,
      appBarTheme: AppBarTheme(
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: GoogleFonts.latoTextTheme().apply(
        bodyColor: black,
        displayColor: black,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: black,
          foregroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      cardTheme: CardTheme(
        color: white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
      ),
    );
  }

  static TextStyle arabicText({double fontSize = 28, Color color = black}) {
    return TextStyle(
      fontFamily: 'Scheherazade New',
      fontSize: fontSize,
      color: color,
      height: 2.0,
    );
  }

  static TextStyle titleStyle({double fontSize = 24, Color color = black}) {
    return GoogleFonts.playfairDisplay(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  static TextStyle bodyStyle({double fontSize = 16, Color color = black}) {
    return GoogleFonts.lato(
      fontSize: fontSize,
      color: color,
    );
  }
}
