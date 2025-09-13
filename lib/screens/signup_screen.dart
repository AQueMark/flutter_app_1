import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  // --- ADDED: Callback to toggle to the login page ---
  final VoidCallback onTap;

  const SignUpScreen({
    super.key,
    required this.onTap,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final user = await _authService.signUpWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign up failed. Please try again.')),
      );
    }
    // If sign up is successful, the AuthGate will automatically navigate.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Create an Account',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'K2D',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                
                _buildTextField(
                  label: 'Email Address',
                  hint: 'user@mail.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  label: 'Password',
                  hint: 'At least 8 characters',
                  controller: _passwordController,
                  isPassword: true,
                  isObscured: _isPasswordObscured,
                  onVisibilityToggle: () {
                    setState(() {
                      _isPasswordObscured = !_isPasswordObscured;
                    });
                  },
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  label: 'Re-enter Password',
                  hint: 'Re-enter your password',
                  controller: _confirmPasswordController,
                  isPassword: true,
                  isObscured: _isConfirmPasswordObscured,
                  onVisibilityToggle: () {
                    setState(() {
                      _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                    });
                  },
                ),
                const SizedBox(height: 28),

                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'K2D'),
                    children: <TextSpan>[
                      const TextSpan(text: 'By continuing, you agree to our '),
                      TextSpan(
                        text: 'terms of service',
                        style: const TextStyle(color: Color(0xFF4A55A8), fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print('Terms of Service tapped!');
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A55A8),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 30),

                const Row(
                  children: [
                    Expanded(child: Divider(color: Color.fromARGB(123, 158, 158, 158))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('or', style: TextStyle(color: Colors.grey, fontFamily: 'K2D')),
                    ),
                    Expanded(child: Divider(color: Color.fromARGB(123, 158, 158, 158))),
                  ],
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement Google Sign In Logic
                    },
                    icon: Image.asset('assets/icons/google_logo.png', height: 20),
                    label: const Text(
                      'Sign in with Google',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // --- MODIFIED: Link to Sign In Page now uses the onTap callback ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.grey, fontFamily: 'K2D'),
                    ),
                    GestureDetector(
                      onTap: widget.onTap, // Use the callback here
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          color: Color(0xFF4A55A8),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'K2D',
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    bool isObscured = false,
    VoidCallback? onVisibilityToggle,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'K2D')),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isObscured,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFF282828),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isObscured ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: onVisibilityToggle,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}