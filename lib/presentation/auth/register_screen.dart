import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../widgets/clay_button.dart';
import '../widgets/clay_feedback_dialog.dart';
import '../widgets/clay_text_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Validates the form and attempts to register.
  ///
  /// On success, pops back to [AuthGuard] which will
  /// reactively show [DashboardScreen].
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref
          .read(authProvider.notifier)
          .register(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
      // Register succeeded – show success popup, then navigate.
      if (mounted) {
        await ClayFeedbackDialog.showSuccess(
          context,
          title: 'Registrasi Berhasil!',
          message:  'Kami telah mengirim email verifikasi ke alamat email Anda.\n\n'
                      'Silakan buka inbox (atau folder Spam), klik tautan verifikasi, '
                      'kemudian login kembali.',
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
          title: 'Registrasi Gagal',
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
                    'Create Account',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join us to keep Bali clean',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 48),
                  ClayTextField(
                    controller: _nameController,
                    hintText: 'Full Name',
                    icon: Icons.person_rounded,
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Name is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
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
                      if (val.length < 6)
                        return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 48),
                  ClayButton(
                    text: 'Register',
                    isLoading: authState.isLoading,
                    onPressed: _register,
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
