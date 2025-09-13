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

    if (mounted) {
      setState(() {
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? '{email}';

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- FIX: Sign out instead of pop ---
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => _authService.signOut(),
                iconSize: 32,
              ),
              const SizedBox(height: 110),

              // Title
              const Text(
                "Verify your email",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'K2D'
                ),
              ),
              const SizedBox(height: 20),

              // Email message
              Text(
                "A verification link has been sent to $userEmail",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'K2D',
                ),
              ),
              const SizedBox(height: 18),

              const Text(
                "Click the link to activate your account, then tap 'Continue' below",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'K2D',
                ),
              ),
              // --- FIX: Using Spacer correctly for layout ---
              const Spacer(),

              // Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isChecking ? null : _onContinuePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 22, 97, 171),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: _isChecking
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Continue',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Resend email
              Center(
                child: TextButton(
                  onPressed: () {
                    _authService.sendEmailVerification();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Another email has been sent.')),
                    );
                  },
                  child: const Text(
                    'Resend Email',
                    style: TextStyle(color: Colors.blueAccent,fontSize: 16),
                  ),
                ),
              ),
              // Give some padding at the bottom
              const SizedBox(height: 350),
            ],
          ),
        ),
      ),
    );
  }
}