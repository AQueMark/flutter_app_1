// In lib/auth/login_or_register.dart

import 'package:flutter/material.dart';
import 'package:flutter_app_1/screens/login_screen.dart';
import 'package:flutter_app_1/screens/signup_screen.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  // Initially, show the login page
  bool showLoginPage = true;

  // Method to toggle between login and register pages
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginScreen(onTap: togglePages);
    } else {
      return SignUpScreen(onTap: togglePages);
    }
  }
}