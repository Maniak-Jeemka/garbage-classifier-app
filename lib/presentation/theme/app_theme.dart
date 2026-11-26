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

  Color forCategory(String category) {
    return switch (category.toLowerCase()) {
      'organik' => organik,
      'non-organik' => nonOrganik,
      _ => residu,
    };
  }

  @override
  BinColors copyWith({Color? organik, Color? nonOrganik, Color? residu}) {
    return BinColors(
      organik: organik ?? this.organik,
      nonOrganik: nonOrganik ?? this.nonOrganik,
      residu: residu ?? this.residu,
    );
  }

  @override
  BinColors lerp(ThemeExtension<BinColors>? other, double t) {
    if (other is! BinColors) return this;
    return BinColors(
      organik: Color.lerp(organik, other.organik, t)!,
      nonOrganik: Color.lerp(nonOrganik, other.nonOrganik, t)!,
      residu: Color.lerp(residu, other.residu, t)!,
    );
  }
}

abstract final class AppRadius {
  static const double small = 16;
  static const double medium = 20;
  static const double large = 28;
  static const double pill = 999;
}

abstract final class AppTheme {
  static const lime = Color(0xFFC9F23B);
  static const charcoal = Color(0xFF263238);
  static const canvas = Color(0xFFF6F8F2);
  static const _darkCanvas = Color(0xFF141A1D);

  static const _lightBins = BinColors(
    organik: Color(0xFF2E7D32),
    nonOrganik: Color(0xFFB26A00),
    residu: Color(0xFFC62828),
  );

  static const _darkBins = BinColors(
    organik: Color(0xFF6FD38A),
    nonOrganik: Color(0xFFF2B84B),
    residu: Color(0xFFFF8A80),
  );

  static final darkTheme = _build(
    const ColorScheme(
      brightness: Brightness.dark,
      primary: lime,
      onPrimary: charcoal,
      secondary: Color(0xFF2E3B42),
      onSecondary: Color(0xFFF4F7F8),
      error: Color(0xFFFF8A80),
      onError: charcoal,
      surface: _darkCanvas,
      onSurface: Color(0xFFF4F7F8),
      onSurfaceVariant: Color(0xFFA0ADB4),
      surfaceContainerLow: Color(0xFF1C2428),
      surfaceContainer: Color(0xFF242E33),
      surfaceContainerHigh: Color(0xFF2E3A40),
      outlineVariant: Color(0xFF334047),
    ),
    _darkBins,
  );

  static final lightTheme = _build(
    const ColorScheme(
      brightness: Brightness.light,
      primary: lime,
      onPrimary: charcoal,
      secondary: charcoal,
      onSecondary: Colors.white,
      error: Color(0xFFC62828),
      onError: Colors.white,
      surface: canvas,
      onSurface: charcoal,
      onSurfaceVariant: Color(0xFF5C686E),
      surfaceContainerLow: Colors.white,
      surfaceContainer: Color(0xFFEEF2E6),
      surfaceContainerHigh: Color(0xFFE1E7D8),
      outlineVariant: Color(0xFFDDE3D5),
    ),
    _lightBins,
  );

  static ThemeData _build(ColorScheme scheme, BinColors bins) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
    );
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );
    final pillBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(AppRadius.pill)),
      borderSide: BorderSide(color: scheme.outlineVariant, width: 1),
    );
    final focusedPillBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(AppRadius.pill)),
      borderSide: BorderSide(color: scheme.primary, width: 2),
    );

    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      extensions: [bins],
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
          color: scheme.onSurface,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: scheme.primary,
        height: 64,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelMedium?.copyWith(
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? scheme.onSurface
                : scheme.onSurfaceVariant,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? scheme.onPrimary
                : scheme.onSurfaceVariant,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.secondary,
          foregroundColor: scheme.onSecondary,
          minimumSize: const Size.fromHeight(56),
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          shape: const StadiumBorder(),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        hintStyle: TextStyle(color: scheme.onSurfaceVariant, fontSize: 14),
        prefixIconColor: scheme.onSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 16,
        ),
        border: pillBorder,
        enabledBorder: pillBorder,
        focusedBorder: focusedPillBorder,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: charcoal,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        actionTextColor: lime,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.small),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
      ),
    );
  }
}
