import 'package:flutter/material.dart';
import 'clay_container.dart';

class ClayButton extends StatefulWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Color? color;
  final Color? textColor;
  final double borderRadius;
  final double height;
  final double width;

  const ClayButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.color,
    this.textColor,
    this.borderRadius = 20,
    this.height = 55,
    this.width = double.infinity,
  });

  @override
  State<ClayButton> createState() => _ClayButtonState();
}

class _ClayButtonState extends State<ClayButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Choose base button color
    final buttonColor = widget.color ?? theme.colorScheme.primary;
    final contentColor =
        widget.textColor ??
        (buttonColor == theme.colorScheme.primary
            ? (isDark ? Colors.black87 : Colors.white)
            : theme.colorScheme.onSurface);

    final bool active =
        widget.isEnabled && !widget.isLoading && widget.onPressed != null;

    // Apply scale animation on press
    final double scale = _isPressed ? 0.97 : 1.0;
    // Apply less depth when pressed or when disabled
    final double depthSpread = !active ? 2.0 : (_isPressed ? 2.0 : 5.0);

    return GestureDetector(
      onTapDown: active ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: active
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: active ? () => setState(() => _isPressed = false) : null,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: ClayContainer(
          width: widget.width,
          height: widget.height,
          borderRadius: widget.borderRadius,
          color: active ? buttonColor : buttonColor.withAlpha(120),
          spread: depthSpread,
          depth: active, // flat if disabled
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(contentColor),
                    ),
                  )
                : (widget.child ??
                      Text(
                        widget.text ?? '',
                        style: TextStyle(
                          color: contentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )),
          ),
        ),
      ),
    );
  }
}
