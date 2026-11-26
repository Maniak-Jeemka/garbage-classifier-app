import 'package:flutter/material.dart';
import '../history/history_screen.dart';
import '../home/home_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/clay.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: switch (_index) {
        0 => const HomeScreen(),
        _ => const HistoryScreen(),
      },
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
          child: ClaySurface(
            radius: AppRadius.pill,
            child: NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (value) => setState(() => _index = value),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.center_focus_strong_outlined),
                  selectedIcon: Icon(Icons.center_focus_strong_rounded),
                  label: 'Pindai',
                ),
                NavigationDestination(
                  icon: Icon(Icons.history_outlined),
                  selectedIcon: Icon(Icons.history_rounded),
                  label: 'Riwayat',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
