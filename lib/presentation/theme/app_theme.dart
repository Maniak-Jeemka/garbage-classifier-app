import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Bin-category colour tokens available via
/// `Theme.of(context).extension<BinColors>()`.
@immutable
class BinColors extends ThemeExtension<BinColors> {
  final Color organik;
  final Color nonOrganik;
  final Color residu;

  const BinColors({
    required this.organik,
    required this.nonOrganik,
    required this.residu,
  });

  @override
  ThemeExtension<BinColors> copyWith({
    Color? organik,
    Color? nonOrganik,
    Color? residu,
  }) {
    return BinColors(
      organik: organik ?? this.organik,
      nonOrganik: nonOrganik ?? this.nonOrganik,
      residu: residu ?? this.residu,
    );
  }

  @override
  ThemeExtension<BinColors> lerp(
    ThemeExtension<BinColors>? other,
    double t,
  ) {
    if (other is! BinColors) return this;
    return BinColors(
      organik: Color.lerp(organik, other.organik, t)!,
      nonOrganik:
          Color.lerp(nonOrganik, other.nonOrganik, t)!,
      residu: Color.lerp(residu, other.residu, t)!,
    );
  }
}

/// Claymorphism‑themed app styling with a neon green
/// primary color palette (#C1FE08) and light theme only.
@immutable
class AppTheme {
  // ── Core palette ──────────────────────────────────────
  static const neonGreen = Color(0xFFC1FE08); // Lime Green

  // Light surfaces
  static const _background = Color(0xFFF2F4F8); // Soft cool off-white matching reference vibe
  static const _cardLight = Color(0xFFFFFFFF);

  // ── Bin category colours ──────────────────────────────
  static const lightBinColors = BinColors(
    organik: Color(0xFF2ECC71),
    nonOrganik: Color(0xFFF1C40F),
    residu: Color(0xFFE74C3C),
  );

  // ── Light theme ───────────────────────────────────────
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: neonGreen,
      primary: neonGreen,
      brightness: Brightness.light,
      surface: _background,
      surfaceContainerLowest: const Color(0xFFFFFFFF),
      surfaceContainerLow: _cardLight,
      surfaceContainer: const Color(0xFFF5F6FA),
      surfaceContainerHigh: const Color(0xFFEAECEF),
      surfaceContainerHighest: const Color(0xFFE0E2E5),
    ),
    scaffoldBackgroundColor: _background,
    extensions: const <ThemeExtension<dynamic>>[
      lightBinColors,
    ],
    textTheme: GoogleFonts.outfitTextTheme(
      ThemeData.light().textTheme,
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      titleTextStyle: GoogleFonts.outfit(
        color: const Color(0xFF1A2318),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: _cardLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _cardLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: neonGreen,
          width: 1.5,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      selectedColor: neonGreen,
      checkmarkColor: const Color(0xFF1A2318),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: _background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
