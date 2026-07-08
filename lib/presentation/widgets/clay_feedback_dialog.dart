import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The type of feedback popup to display.
enum ClayDialogType { success, error }

/// A reusable claymorphism-styled popup dialog.
///
/// Use the static helpers [showSuccess] and [showError] for
/// convenience. The dialog auto-dismisses after [autoDismiss]
/// duration (defaults to 2 seconds for success, no auto-dismiss
/// for error).
class ClayFeedbackDialog extends StatefulWidget {
  final ClayDialogType type;
  final String title;
  final String message;
  final Duration? autoDismiss;
  final IconData? icon;

  const ClayFeedbackDialog({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    this.autoDismiss,
    this.icon,
  });

  /// Show a success dialog centered on screen.
  static Future<void> showSuccess(
    BuildContext context, {
    required String title,
    required String message,
    Duration autoDismiss = const Duration(seconds: 2),
    IconData icon = Icons.check_circle_rounded,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'ClaySuccessDialog',
      barrierColor: Colors.black38,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, anim1, anim2) {
        return ClayFeedbackDialog(
          type: ClayDialogType.success,
          title: title,
          message: message,
          autoDismiss: autoDismiss,
          icon: icon,
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: anim1,
            curve: Curves.elasticOut,
            reverseCurve: Curves.easeIn,
          ),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  /// Show an error dialog centered on screen.
  static Future<void> showError(
    BuildContext context, {
    required String title,
    required String message,
    IconData icon = Icons.error_rounded,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'ClayErrorDialog',
      barrierColor: Colors.black38,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, anim1, anim2) {
        return ClayFeedbackDialog(
          type: ClayDialogType.error,
          title: title,
          message: message,
          icon: icon,
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: anim1,
            curve: Curves.elasticOut,
            reverseCurve: Curves.easeIn,
          ),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  @override
  State<ClayFeedbackDialog> createState() => _ClayFeedbackDialogState();
}

class _ClayFeedbackDialogState extends State<ClayFeedbackDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _iconBounce;

  @override
  void initState() {
    super.initState();
    _iconBounce = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    // Auto-dismiss after the given duration.
    if (widget.autoDismiss != null) {
      Future.delayed(widget.autoDismiss!, () {
        if (mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  void dispose() {
    _iconBounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final isSuccess = widget.type == ClayDialogType.success;
    final accentColor = isSuccess
        ? const Color(0xFF81C784) // Soft green
        : const Color(0xFFE57373); // Soft red

    final baseColor = isDark
        ? Color.lerp(theme.colorScheme.surface, Colors.white, 0.04)!
        : Color.lerp(theme.colorScheme.surface, Colors.white, 0.5)!;
    final darkShade = isDark
        ? Color.lerp(theme.colorScheme.surface, Colors.black, 0.15)!
        : Color.lerp(theme.colorScheme.surface, Colors.black, 0.02)!;

    final iconData = widget.icon ??
        (isSuccess ? Icons.check_circle_rounded : Icons.error_rounded);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 320),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                colors: [baseColor, darkShade],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: isDark
                    ? Colors.white.withAlpha(15)
                    : Colors.white.withAlpha(120),
                width: 1.5,
              ),
              boxShadow: [
                // Dark shadow (bottom-right)
                BoxShadow(
                  color: isDark
                      ? Colors.black.withAlpha(180)
                      : Colors.black.withAlpha(25),
                  offset: const Offset(8, 8),
                  blurRadius: 16,
                ),
                // Light shadow (top-left)
                BoxShadow(
                  color: isDark
                      ? const Color(0xFFB5EAD7).withAlpha(30)
                      : Colors.white,
                  offset: const Offset(-6, -6),
                  blurRadius: 14,
                ),
                // Accent glow
                BoxShadow(
                  color: accentColor.withAlpha(isDark ? 50 : 35),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated icon
                  ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _iconBounce,
                      curve: Curves.elasticOut,
                    ),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentColor.withAlpha(30),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withAlpha(isDark ? 60 : 40),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        iconData,
                        color: accentColor,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Title
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Message
                  Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      height: 1.4,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  // Only show OK button for error dialogs
                  if (!isSuccess || widget.autoDismiss == null) ...[
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: _ClayDialogButton(
                        accentColor: accentColor,
                        isDark: isDark,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A small clay-styled OK button used inside the dialog.
class _ClayDialogButton extends StatefulWidget {
  final Color accentColor;
  final bool isDark;
  final VoidCallback onTap;

  const _ClayDialogButton({
    required this.accentColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_ClayDialogButton> createState() => _ClayDialogButtonState();
}

class _ClayDialogButtonState extends State<_ClayDialogButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            color: widget.accentColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: _pressed
                ? []
                : [
                    BoxShadow(
                      color: widget.accentColor.withAlpha(100),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: widget.isDark
                          ? Colors.black.withAlpha(120)
                          : Colors.black.withAlpha(15),
                      offset: const Offset(3, 3),
                      blurRadius: 6,
                    ),
                    BoxShadow(
                      color: widget.isDark
                          ? Colors.white.withAlpha(10)
                          : Colors.white.withAlpha(200),
                      offset: const Offset(-2, -2),
                      blurRadius: 6,
                    ),
                  ],
          ),
          child: Center(
            child: Text(
              'OK',
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: widget.isDark ? Colors.black87 : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
