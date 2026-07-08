import 'package:flutter/material.dart';

class ClayInnerShadowPainter extends CustomPainter {
  final Color shadowColor;
  final double blurRadius;
  final Offset offset;
  final double borderRadius;

  ClayInnerShadowPainter({
    required this.shadowColor,
    required this.blurRadius,
    required this.offset,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    // Clip to the container boundaries
    canvas.clipRRect(rrect);

    final shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius)
      ..style = PaintingStyle.stroke
      ..strokeWidth = blurRadius * 2;

    final shadowPath = Path()
      ..addRRect(rrect)
      ..fillType = PathFillType.evenOdd;

    // Shift path by the offset to draw the inner shadow edge
    canvas.translate(offset.dx, offset.dy);
    canvas.drawPath(shadowPath, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant ClayInnerShadowPainter oldDelegate) {
    return oldDelegate.shadowColor != shadowColor ||
        oldDelegate.blurRadius != blurRadius ||
        oldDelegate.offset != offset ||
        oldDelegate.borderRadius != borderRadius;
  }
}

class ClayTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final IconData? icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  const ClayTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baseColor = isDark
        ? Color.lerp(theme.colorScheme.surface, Colors.black, 0.15)!
        : Color.lerp(theme.colorScheme.surface, Colors.black, 0.02)!;

    final shadowColor = isDark
        ? Colors.black.withAlpha(200)
        : Colors.black.withAlpha(35);

    final highlightColor = isDark
        ? Colors.white.withAlpha(15)
        : Colors.white.withAlpha(200);

    return CustomPaint(
      painter: ClayInnerShadowPainter(
        shadowColor: shadowColor,
        blurRadius: 4,
        offset: const Offset(2.5, 2.5),
        borderRadius: 20,
      ),
      foregroundPainter: ClayInnerShadowPainter(
        shadowColor: highlightColor,
        blurRadius: 3,
        offset: const Offset(-1.5, -1.5),
        borderRadius: 20,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withAlpha(10)
                : Colors.black.withAlpha(5),
            width: 1.0,
          ),
        ),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: icon != null
                ? Icon(icon, color: theme.colorScheme.primary.withAlpha(200))
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurfaceVariant.withAlpha(120),
            ),
          ),
        ),
      ),
    );
  }
}
