import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Core Palette ─────────────────────────────────────────
  static const Color white      = Color(0xFFFFFFFF);
  static const Color offWhite   = Color(0xFFF9F9F9);
  static const Color bg         = Color(0xFFF2F2F7); // iOS system background
  static const Color cardBg     = Color(0xFFFFFFFF);
  static const Color black      = Color(0xFF0A0A0A);
  static const Color ink        = Color(0xFF1C1C1E); // iOS label
  static const Color ink2       = Color(0xFF3C3C43); // iOS secondary label
  static const Color ink3       = Color(0xFF8E8E93); // iOS tertiary label
  static const Color separator  = Color(0xFFE5E5EA);
  static const Color gold       = Color(0xFFD4AF37);
  static const Color goldLight  = Color(0xFFF5E27A);
  static const Color goldDark   = Color(0xFFA87C1A);
  static const Color green      = Color(0xFF34C759); // iOS green
  static const Color blue       = Color(0xFF007AFF); // iOS blue
  static const Color red        = Color(0xFFFF3B30);  // iOS red

  // ── Shadows ───────────────────────────────────────────────
  static List<BoxShadow> get cardShadow => [
    BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 24, offset: const Offset(0, 8)),
    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6,  offset: const Offset(0, 2)),
  ];
  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 40, offset: const Offset(0, 14)),
    BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4)),
  ];
  static List<BoxShadow> get subtleShadow => [
    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4)),
  ];

  // ── Text Styles ───────────────────────────────────────────
  static TextStyle display({double size = 34, Color color = ink, FontWeight weight = FontWeight.bold}) =>
      GoogleFonts.playfairDisplay(fontSize: size, fontWeight: weight, color: color, height: 1.2);

  static TextStyle title({double size = 20, Color color = ink, FontWeight weight = FontWeight.w700}) =>
      GoogleFonts.plusJakartaSans(fontSize: size, fontWeight: weight, color: color, height: 1.3);

  static TextStyle body({double size = 15, Color color = ink, FontWeight weight = FontWeight.w400}) =>
      GoogleFonts.plusJakartaSans(fontSize: size, fontWeight: weight, color: color, height: 1.5);

  static TextStyle caption({double size = 12, Color color = ink3, FontWeight weight = FontWeight.w500}) =>
      GoogleFonts.plusJakartaSans(fontSize: size, fontWeight: weight, color: color, height: 1.4, letterSpacing: 0.1);

  static TextStyle arabic({double size = 28, Color color = ink}) =>
      TextStyle(fontFamily: 'Scheherazade New', fontSize: size, color: color, height: 2.0);

  static TextStyle label({double size = 11, Color color = ink3}) =>
      GoogleFonts.plusJakartaSans(fontSize: size, fontWeight: FontWeight.w600, color: color, letterSpacing: 0.5);

  // ── Theme ─────────────────────────────────────────────────
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: black, secondary: gold,
      surface: white, background: bg,
      onPrimary: white, onSecondary: black,
      onSurface: ink, onBackground: ink,
    ),
    scaffoldBackgroundColor: bg,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.plusJakartaSans(
        color: ink, fontSize: 17, fontWeight: FontWeight.w700,
      ),
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme().apply(bodyColor: ink, displayColor: ink),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: black, foregroundColor: white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      ),
    ),
    cardTheme: CardTheme(
      color: white, elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}

// ── Reusable Widget Helpers ────────────────────────────────
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double radius;
  final Color? color;
  final VoidCallback? onTap;
  final List<BoxShadow>? shadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.radius = 20,
    this.color,
    this.onTap,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? AppTheme.cardBg,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: shadow ?? AppTheme.cardShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius),
            splashColor: Colors.black.withOpacity(0.04),
            highlightColor: Colors.black.withOpacity(0.02),
            child: padding != null
                ? Padding(padding: padding!, child: child)
                : child,
          ),
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double radius;
  final Color? tint;

  const GlassCard({super.key, required this.child, this.padding, this.radius = 20, this.tint});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (tint ?? Colors.white).withOpacity(0.12),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
      ),
      child: padding != null ? Padding(padding: padding!, child: child) : child,
    );
  }
}

class DarkHero extends StatelessWidget {
  final Widget child;
  final double radius;

  const DarkHero({super.key, required this.child, this.radius = 24});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.ink,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: AppTheme.elevatedShadow,
      ),
      child: child,
    );
  }
}
