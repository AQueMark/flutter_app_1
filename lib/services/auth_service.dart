// In lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Create an instance of Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- AUTH STATE CHANGES STREAM ---
  // This stream will notify the app whenever the user's login state changes (logged in or out).
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // --- SIGN UP WITH EMAIL & PASSWORD ---
  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // We can handle specific errors here later (e.g., email-already-in-use)
      print(e.toString());
      return null;
    }
  }

  // --- SIGN IN WITH EMAIL & PASSWORD ---
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Handle errors like wrong-password, user-not-found
      print(e.toString());
      return null;
    }
  }
  Future<void> sendEmailVerification() async {
    try {
      // Get the current user
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        // Send the verification email
        await user.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
  }

  // --- PASSWORD RESET ---
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
  }

  // --- SIGN OUT ---
  Future<void> signOut() async {
    await _auth.signOut();
  }
}