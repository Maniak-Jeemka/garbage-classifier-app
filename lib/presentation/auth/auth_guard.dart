import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import 'splash_screen.dart';
import 'welcome_screen.dart';
import '../dashboard/dashboard_screen.dart';

class AuthGuard extends ConsumerWidget {
  const AuthGuard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return const DashboardScreen();
        } else {
          return const WelcomeScreen();
        }
      },
      loading: () => const SplashScreen(),
      error: (e, st) =>
          Scaffold(body: Center(child: Text('An error occurred: $e'))),
    );
  }
}
