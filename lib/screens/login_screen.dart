import 'package:flutter/material.dart';
import 'package:flutter_app_1/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  // --- ADDED: Callback to toggle to the sign-up page ---
  final VoidCallback onTap;

  const LoginScreen({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordObscured = true;
  bool _keepMeSignedIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    final user = await _authService.signInWithEmailAndPassword(
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
        const SnackBar(content: Text('Sign in failed. Please check your credentials.')),
      );
    }
    // If sign in is successful, the AuthGate will automatically navigate to MainScreen.
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
                const SizedBox(height: 90),
                const Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'K2D',
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontFamily: 'K2D',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to Forgot Password screen
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Color(0xFF4A55A8),
                          fontSize: 16,
                          fontFamily: 'K2D',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                _buildTextField(
                  hint: 'Enter Password',
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

                Row(
                  children: [
                    SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: Checkbox(
                        value: _keepMeSignedIn,
                        onChanged: (value) {
                          setState(() {
                            _keepMeSignedIn = value ?? false;
                          });
                        },
                        activeColor: const Color.fromARGB(255, 46, 57, 138),
                        checkColor: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Keep me signed in',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontFamily: 'K2D',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 22, 97, 171),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 30),

                const Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'or',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'K2D',
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey)),
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                
                // --- MODIFIED: Link to Create Account Page now uses the onTap callback ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'K2D',
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap, // Use the callback here
                      child: const Text(
                        'Create an Account',
                        style: TextStyle(
                          color: Color(0xFF4A55A8),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'K2D',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    String? label,
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
        if (label != null) ...[
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'K2D',
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          obscureText: isObscured,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontFamily: 'K2D'),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontFamily: 'K2D'),
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