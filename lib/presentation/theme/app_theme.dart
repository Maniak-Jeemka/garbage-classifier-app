import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  static const primaryColor = Color(0xFFB5EAD7); // Soft Pastel Mint Green
  static const secondaryColor = Color(0xFFC7E9B0); // Pastel Lime Green
  static const backgroundColor = Color(
    0xFFF9F9F6,
  ); // Creamy Off-White for claymorphism
  static const darkBackgroundColor = Color(
    0xFF2D423F,
  ); // Enchanted Forest Dark Green

  static const lightBinColors = BinColors(
    organik: Color(0xFF81C784), // Soft Green
    nonOrganik: Color(0xFFFFD54F), // Soft Amber
    residu: Color(0xFFE57373), // Soft Red
  );

  static const darkBinColors = BinColors(
    organik: Color(0xFF4CAF50), // Vibrant Mint/Green
    nonOrganik: Color(0xFFFFC107), // Vibrant Amber
    residu: Color(0xFFEF5350), // Vibrant Red
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      surface: backgroundColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    extensions: const <ThemeExtension<dynamic>>[lightBinColors],
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      titleTextStyle: GoogleFonts.outfit(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: GoogleFonts.outfitTextTheme(),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      surface: darkBackgroundColor,
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    extensions: const <ThemeExtension<dynamic>>[darkBinColors],
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      titleTextStyle: GoogleFonts.outfit(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
  );
}
