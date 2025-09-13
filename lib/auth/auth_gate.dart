// In lib/auth/auth_gate.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/auth/login_or_register.dart';
import 'package:flutter_app_1/main.dart';
import 'package:flutter_app_1/screens/verify_email_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        // --- MODIFIED: Switched to the userChanges() stream ---
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          // User is not logged in
          if (!snapshot.hasData) {
            return const LoginOrRegisterPage();
          }

          // User is logged in
          final user = snapshot.data!;

          // Check if the user's email is verified
          if (user.emailVerified) {
            // If verified, show the main app
            return const MainScreen();
          } else {
            // If not verified, show the verification screen
            return const VerifyEmailScreen();
          }
        },
      ),
    );
  }
}