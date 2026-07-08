import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

part 'auth_provider.g.dart';

@riverpod
AuthService authService(Ref ref) {
  return AuthService();
}

@Riverpod(keepAlive: true)
Stream<User?> authStateChanges(Ref ref) {
  return ref.watch(authServiceProvider).authStateChanges;
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<UserModel?> build() async {
    final user = await ref.watch(authStateChangesProvider.future);
    if (user != null) {
      return ref.read(authServiceProvider).getUserData(user.uid);
    }
    return null;
  }

  /// Signs in with email/password.
  ///
  /// On success, Firebase auth state changes automatically,
  /// which triggers [build] to re-run and update state.
  /// Throws on failure so callers can handle navigation.
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await ref
          .read(authServiceProvider)
          .signInWithEmailAndPassword(email, password);
      // Don't set state here – the Firebase auth stream
      // will trigger build() to resolve with the new user.
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> loginWithGoogle() async {
  state = const AsyncValue.loading();

  try {
    await ref.read(authServiceProvider).signInWithGoogle();

    // Tidak perlu mengubah state di sini.
    // Firebase Auth akan memicu authStateChanges,
    // lalu build() akan otomatis mengambil data user.
  } catch (e, st) {
    state = AsyncValue.error(e, st);
    rethrow;
  }
}

  /// Creates a new account.
  ///
  /// On success, Firebase auth state changes automatically.
  /// Throws on failure so callers can handle navigation.
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref
          .read(authServiceProvider)
          .createUserWithEmailAndPassword(
            name: name,
            email: email,
            password: password,
          );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authServiceProvider).sendPasswordResetEmail(email);
      state = const AsyncValue.data(
        null,
      ); // Keep user null as reset password doesn't login
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Signs out the current user.
  ///
  /// On success, Firebase auth state changes automatically.
  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authServiceProvider).signOut();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile({
    String? name,
    String? photoUrl,
    String? wilayah,
  }) async {
    final currentUser = state.value;
    if (currentUser == null) {
      throw Exception('No user logged in to update profile');
    }

    final updatedUser = currentUser.copyWith(
      name: name,
      photoUrl: photoUrl,
      wilayah: wilayah,
    );

    // Optimistically update local state:
    state = AsyncValue.data(updatedUser);

    try {
      await ref.read(authServiceProvider).updateUserData(updatedUser);
    } catch (e) {
      // Revert local state on error:
      state = AsyncValue.data(currentUser);
      rethrow;
    }
  }
}
