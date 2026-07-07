import 'package:flutter/material.dart';

/// Provides factory methods for consistent **soft
/// claymorphism** decorations across the app.
///
/// Soft claymorphism uses gentle dual-directional
/// shadows (a muted dark shadow bottom-right and a
/// white highlight top-left) to create a pillowy,
/// inflated 3D appearance — without any glow effects.
class ClayDecoration {
  const ClayDecoration._();

  /// Standard card-level soft clay container.
  static BoxDecoration card({
    required Color color,
    required Brightness brightness,
    double radius = 24,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: const [
        BoxShadow(
          color: Color(0x28B0B8C8),
          offset: Offset(6, 6),
          blurRadius: 16,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: Color(0xDDFFFFFF),
          offset: Offset(-5, -5),
          blurRadius: 14,
          spreadRadius: 1,
        ),
      ],
    );
  }

  /// Elevated hero-level soft clay container with
  /// slightly stronger depth for stat cards and
  /// profile headers.
  static BoxDecoration elevated({
    required Color color,
    required Brightness brightness,
    double radius = 28,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: const [
        BoxShadow(
          color: Color(0x30B0B8C8),
          offset: Offset(8, 8),
          blurRadius: 20,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: Color(0xE0FFFFFF),
          offset: Offset(-8, -8),
          blurRadius: 20,
          spreadRadius: 1,
        ),
      ],
    );
  }

  /// Button-level soft clay effect — no glow, just
  /// gentle shadows for a raised, tappable feel.
  static BoxDecoration button({
    required Color color,
    required Brightness brightness,
    double radius = 20,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: const [
        BoxShadow(
          color: Color(0x28B0B8C8),
          offset: Offset(4, 6),
          blurRadius: 14,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: Color(0xDDFFFFFF),
          offset: Offset(-4, -4),
          blurRadius: 12,
          spreadRadius: 1,
        ),
      ],
    );
  }

  /// Text field / input soft clay styling with a
  /// subtle inset feel.
  static BoxDecoration input({
    required Color color,
    required Brightness brightness,
    double radius = 18,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: const [
        BoxShadow(
          color: Color(0x20B0B8C8),
          offset: Offset(3, 3),
          blurRadius: 6,
        ),
        BoxShadow(
          color: Color(0xCCFFFFFF),
          offset: Offset(-3, -3),
          blurRadius: 6,
        ),
      ],
    );
  }

  /// Pill / chip soft clay shape for nav items and
  /// filter chips — no glow.
  static BoxDecoration pill({
    required Color color,
    required Brightness brightness,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(50),
      boxShadow: const [
        BoxShadow(
          color: Color(0x22B0B8C8),
          offset: Offset(3, 3),
          blurRadius: 10,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: Color(0xCCFFFFFF),
          offset: Offset(-3, -3),
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ],
    );
  }

  /// Circular soft clay shape.
  static BoxDecoration circle({
    required Color color,
    required Brightness brightness,
    BoxBorder? border,
  }) {
    return BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: border,
      boxShadow: const [
        BoxShadow(
          color: Color(0x22B0B8C8),
          offset: Offset(3, 3),
          blurRadius: 10,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: Color(0xCCFFFFFF),
          offset: Offset(-3, -3),
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ],
    );
  }
}
