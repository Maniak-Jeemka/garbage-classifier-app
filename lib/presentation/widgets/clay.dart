import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

List<BoxShadow> clayShadows(BuildContext context, {double depth = 1}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  if (isDark) {
    return [
      BoxShadow(
        color: Colors.black.withAlpha(135),
        offset: Offset(0, 10 * depth),
        blurRadius: 24 * depth,
        spreadRadius: -4,
      ),
      BoxShadow(
        color: Colors.white.withAlpha(10),
        offset: Offset(0, -2 * depth),
        blurRadius: 6 * depth,
      ),
    ];
  }

  return [
    BoxShadow(
      color: const Color(0xFF1F2933).withAlpha(18),
      offset: Offset(0, 10 * depth),
      blurRadius: 24 * depth,
      spreadRadius: -4,
    ),
    BoxShadow(
      color: const Color(0xFF1F2933).withAlpha(10),
      offset: Offset(0, 3 * depth),
      blurRadius: 8 * depth,
    ),
    BoxShadow(
      color: Colors.white.withAlpha(210),
      offset: Offset(0, -2 * depth),
      blurRadius: 6 * depth,
    ),
  ];
}

class ClaySurface extends StatelessWidget {
  const ClaySurface({
    super.key,
    required this.child,
    this.color,
    this.radius = AppRadius.large,
    this.padding = EdgeInsets.zero,
    this.depth = 1,
    this.onTap,
  });

  final Widget child;
  final Color? color;
  final double radius;
  final EdgeInsetsGeometry padding;
  final double depth;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final shape = BorderRadius.circular(radius);
    final resolvedColor = color ?? scheme.surfaceContainerLow;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        border: Border.all(
          color: scheme.outlineVariant.withAlpha(110),
          width: 1,
        ),
        boxShadow: clayShadows(context, depth: depth),
      ),
      child: Material(
        color: resolvedColor,
        borderRadius: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class _Pressable extends StatefulWidget {
  const _Pressable({required this.onTap, required this.builder});

  final VoidCallback? onTap;
  final Widget Function(bool pressed) builder;

  @override
  State<_Pressable> createState() => _PressableState();
}

class _PressableState extends State<_Pressable> {
  bool _pressed = false;

  void _set(bool value) => setState(() => _pressed = value);

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? (_) => _set(true) : null,
      onTapUp: enabled ? (_) => _set(false) : null,
      onTapCancel: enabled ? () => _set(false) : null,
      onTap: widget.onTap,
      child: widget.builder(_pressed),
    );
  }
}

class ClayButton extends StatelessWidget {
  const ClayButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.accent = false,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final enabled = onPressed != null;
    final background = !enabled
        ? scheme.surfaceContainerHigh
        : (accent ? scheme.primary : scheme.secondary);
    final foreground = !enabled
        ? scheme.onSurfaceVariant
        : (accent ? scheme.onPrimary : scheme.onSecondary);

    return Semantics(
      button: true,
      enabled: enabled,
      child: _Pressable(
        onTap: onPressed,
        builder: (pressed) => AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: clayShadows(
              context,
              depth: !enabled ? 0.2 : (pressed ? 0.35 : 1),
            ),
          ),
          child: Center(
            child: DefaultTextStyle.merge(
              style: theme.textTheme.titleMedium?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w700,
              ),
              child: IconTheme(
                data: IconThemeData(color: foreground),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ClayCircleButton extends StatelessWidget {
  const ClayCircleButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.size = 56,
    this.iconSize = 26,
    this.accent = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = onPressed != null;
    final background = !enabled
        ? scheme.surfaceContainerHigh
        : (accent ? scheme.primary : scheme.surfaceContainerLow);
    final foreground = !enabled
        ? scheme.onSurfaceVariant
        : (accent ? scheme.onPrimary : scheme.onSurface);

    return Semantics(
      button: true,
      enabled: enabled,
      label: tooltip,
      child: _Pressable(
        onTap: onPressed,
        builder: (pressed) => AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: background,
            shape: BoxShape.circle,
            border: accent
                ? null
                : Border.all(color: scheme.outlineVariant, width: 1),
            boxShadow: clayShadows(
              context,
              depth: !enabled ? 0.2 : (pressed ? 0.35 : 1),
            ),
          ),
          child: ExcludeSemantics(
            child: Icon(icon, size: iconSize, color: foreground),
          ),
        ),
      ),
    );
  }
}
