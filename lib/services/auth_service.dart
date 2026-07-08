import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  /// Fetches the user data from Firestore.
  ///
  /// Times out after 5 seconds to prevent hanging.
  /// If the document does not exist but the user is authenticated,
  /// it automatically creates a default user document as a fallback.
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .get()
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw TimeoutException(
              'Connection to database timed out. Please check your internet connection.',
            ),
          );

      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }

      // Fallback: If user is authenticated in Firebase Auth but has no Firestore doc,
      // create a default one so they are not locked out of the app.
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null && firebaseUser.uid == uid) {
        final fallbackUser = UserModel(
          uid: uid,
          name:
              firebaseUser.displayName ??
              firebaseUser.email?.split('@').first ??
              'User',
          email: firebaseUser.email ?? '',
          createdAt: DateTime.now(),
        );
        await _firestore
            .collection('users')
            .doc(uid)
            .set(fallbackUser.toJson())
            .timeout(const Duration(seconds: 5));
        return fallbackUser;
      }

      return null;
    } catch (e) {
      throw Exception('Failed to fetch user data: $e');
    }
  }

  /// Signs in with email and password.
  ///
  /// Returns the Firebase [User] on success.
  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getFirebaseAuthErrorMessage(e));
    } catch (e) {
      throw Exception('An unknown error occurred.');
    }
  }

  Future<UserModel?> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        final newUser = UserModel(
          uid: user.uid,
          name: name,
          email: email,
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(newUser.toJson());

        return newUser;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getFirebaseAuthErrorMessage(e));
    } catch (e) {
      throw Exception('An unknown error occurred.');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_getFirebaseAuthErrorMessage(e));
    } catch (e) {
      throw Exception('An unknown error occurred.');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> updateUserData(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(user.toJson(), SetOptions(merge: true))
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  String _getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'operation-not-allowed':
        return 'Operation not allowed. Please contact support.';
      default:
        return e.message ?? 'An unknown error occurred.';
    }
  }

  Future<User?> signInWithGoogle() async {
  try {
    // Pilih akun Google
    final GoogleSignInAccount? googleUser =
        await _googleSignIn.signIn();

    if (googleUser == null) {
      // User membatalkan login
      return null;
    }

    // Ambil token autentikasi
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Buat credential Firebase
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Login ke Firebase
    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);

    final user = userCredential.user;

    if (user != null) {
      final doc = _firestore.collection('users').doc(user.uid);

      if (!(await doc.get()).exists) {
        final newUser = UserModel(
          uid: user.uid,
          name: user.displayName ?? 'User',
          email: user.email ?? '',
          createdAt: DateTime.now(),
        );

        await doc.set(newUser.toJson());
      }
    }

    return user;
  } on FirebaseAuthException catch (e) {
    throw Exception(_getFirebaseAuthErrorMessage(e));
  } catch (e) {
    throw Exception('Google Sign-In failed: $e');
  }
}
}
