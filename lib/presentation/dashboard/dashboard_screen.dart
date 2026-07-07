import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home_screen.dart';
import '../history/history_screen.dart';
import '../guide/guide_screen.dart';
import '../profile/profile_screen.dart';
import '../widgets/clay_container.dart';
import '../../providers/settings_provider.dart';
import '../../utils/localization.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HistoryScreen(),
    HomeScreen(),
    GuideScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(settingsProvider);
    final language = settingsAsync.value?.language ?? AppLanguage.id;
    final localizations = AppLocalizations(language);

    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 12.0),
          child: ClayContainer(
            borderRadius: 24,
            spread: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    index: 0,
                    icon: Icons.dashboard_rounded,
                    label: localizations.get('dasbor'),
                    color: theme.colorScheme.primary,
                  ),
                  _buildNavItem(
                    index: 1,
                    icon: Icons.qr_code_scanner_rounded,
                    label: localizations.get('scan'),
                    color: theme.colorScheme.secondary,
                  ),
                  _buildNavItem(
                    index: 2,
                    icon: Icons.eco_rounded,
                    label: localizations.get('panduan'),
                    color: const Color(0xFF81C784), // Soft Emerald
                  ),
                  _buildNavItem(
                    index: 3,
                    icon: Icons.person_rounded,
                    label: localizations.get('profil'),
                    color: const Color(0xFFBA68C8), // Soft Purple
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final isSelected = _currentIndex == index;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(30) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? color : theme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              AnimatedOpacity(
                opacity: isSelected ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: Text(
                  label,
                  style: GoogleFonts.outfit(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
