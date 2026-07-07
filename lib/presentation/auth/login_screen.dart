import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../widgets/clay_button.dart';
import '../widgets/clay_feedback_dialog.dart';
import '../widgets/clay_text_field.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Validates the form and attempts to log in.
  ///
  /// On success, pops back to [AuthGuard] which will
  /// reactively show [DashboardScreen].
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref
          .read(authProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text.trim());
      // Login succeeded – show success popup, then navigate.
      if (mounted) {
        await ClayFeedbackDialog.showSuccess(
          context,
          title: 'Login Berhasil! 🌿',
          message: 'Selamat datang kembali di Bali Waste Classifier.',
        );
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    } catch (_) {
      // Error state is set by the provider; the listener
      // below will display it as a dialog.
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);

    // Show errors as clay popup dialogs.
    ref.listen<AsyncValue<dynamic>>(authProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        ClayFeedbackDialog.showError(
          context,
          title: 'Login Gagal',
          message: next.error.toString().replaceAll('Exception: ', ''),
        );
      }
    });

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme.colorScheme.primary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome Back',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Login to your account',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 48),
                  ClayTextField(
                    controller: _emailController,
                    hintText: 'Email Address',
                    icon: Icons.email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return 'Email is required';
                      if (!val.contains('@')) return 'Invalid email address';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ClayTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    icon: Icons.lock_rounded,
                    obscureText: true,
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return 'Password is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ClayButton(
                    text: 'Login',
                    isLoading: authState.isLoading,
                    onPressed: _login,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
