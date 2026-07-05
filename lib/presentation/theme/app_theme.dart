import 'package:flutter/material.dart';

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
  ThemeExtension<BinColors> lerp(ThemeExtension<BinColors>? other, double t) {
    if (other is! BinColors) return this;
    return BinColors(
      organik: Color.lerp(organik, other.organik, t)!,
      nonOrganik: Color.lerp(nonOrganik, other.nonOrganik, t)!,
      residu: Color.lerp(residu, other.residu, t)!,
    );
  }
}

@immutable
class AppTheme {
  static const primaryColor = Color(0xFF6366F1); // Indigo
  static const secondaryColor = Color(0xFFEC4899); // Pink
  
  static const lightBinColors = BinColors(
    organik: Color(0xFF10B981), // Emerald
    nonOrganik: Color(0xFFF59E0B), // Amber
    residu: Color(0xFFEF4444), // Rose
  );

  static const darkBinColors = BinColors(
    organik: Color(0xFF34D399), // Mint-Emerald
    nonOrganik: Color(0xFFFBBF24), // Light Amber
    residu: Color(0xFFF87171), // Light Rose
  );
  
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
    extensions: const <ThemeExtension<dynamic>>[
      lightBinColors,
    ],
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
    extensions: const <ThemeExtension<dynamic>>[
      darkBinColors,
    ],
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
