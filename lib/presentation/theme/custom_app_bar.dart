import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A unified custom app bar that displays the app logo and screen title.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min, // Allows centerTitle to work properly
        children: [
          Image.asset(
            'assets/icon/icon.png',
            height: 32,
            errorBuilder: (context, error, stackTrace) => 
                Icon(Icons.eco_rounded, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
