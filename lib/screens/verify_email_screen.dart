import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/services/auth_service.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final AuthService _authService = AuthService();
  Timer? _timer;
  // --- ADDED: State for the "Continue" button's loading indicator ---
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _authService.sendEmailVerification();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _checkEmailVerified());
  }

  Future<void> _checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    final isVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    if (isVerified) {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // --- ADDED: A new method for the continue button's logic ---
  Future<void> _onContinuePressed() async {
    setState(() {
      _isChecking = true;
    });

    await FirebaseAuth.instance.currentUser?.reload();
    final isVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    if (!isVerified) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please verify your email by clicking the link in your inbox first.')),
        );
      }
    }
    // If it IS verified, we don't need to do anything. The AuthGate's stream
    // and the timer will detect the change and navigate automatically.

    if (mounted) {
      setState(() {
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'your email';

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Verify Email"),
        actions: [
          TextButton(
            onPressed: () => _authService.signOut(),
            child: const Text("Cancel", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "A verification link has been sent to:\n$userEmail",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white, height: 1.5),
              ),
              const SizedBox(height: 24),
              const Text(
                "Click the link to activate your account, then tap 'Continue' below.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              
              // --- MODIFIED: The "Continue" button ---
              ElevatedButton(
                onPressed: _isChecking ? null : _onContinuePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A55A8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: _isChecking
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Continue'),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  _authService.sendEmailVerification();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Another email has been sent.')),
                  );
                },
                icon: const Icon(Icons.email_outlined, size: 18),
                label: const Text('Resend Email'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}