import 'package:flutter/material.dart';

class ClayContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? color;
  final bool depth;
  final double spread;
  final VoidCallback? onTap;

  const ClayContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 24,
    this.color,
    this.depth = true,
    this.spread = 6,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Choose base color
    final baseColor = color ?? theme.colorScheme.surface;

    // Subtle gradient for 3D pillowy clay effect
    final lightColor = isDark
        ? Color.lerp(baseColor, Colors.white, 0.04)!
        : Color.lerp(baseColor, Colors.white, 0.6)!;
    final darkColor = isDark
        ? Color.lerp(baseColor, Colors.black, 0.15)!
        : Color.lerp(baseColor, Colors.black, 0.03)!;

    // Define outer shadows
    final List<BoxShadow> shadows = [];
    if (depth) {
      shadows.addAll([
        BoxShadow(
          color: isDark
              ? Colors.black.withAlpha(160)
              : Colors.black.withAlpha(20),
          offset: Offset(spread, spread),
          blurRadius: spread * 2,
        ),
        BoxShadow(
          color: isDark
              ? const Color(0xFFB5EAD7).withAlpha(
                  40,
                ) // Soft glowing mint for enchanted dark mode
              : Colors.white.withAlpha(255),
          offset: Offset(-spread, -spread),
          blurRadius: spread * 2,
        ),
      ]);
    }

    Widget container = Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors: [lightColor, darkColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: shadows,
        border: Border.all(
          color: isDark
              ? Colors.white.withAlpha(15)
              : Colors.white.withAlpha(80),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - 1.5),
        child: child,
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: container,
      );
    }
    return container;
  }
}
