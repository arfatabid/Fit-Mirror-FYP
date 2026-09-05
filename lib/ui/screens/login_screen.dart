import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart' as custom_auth;
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<custom_auth.AuthProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top Soft Purple Gradient Circle Background
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: size.width * 0.85,
              height: size.width * 0.85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFD3B6FF).withOpacity(0.6),
                    const Color(0xFFEEDCFF).withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SignupScreen()),
                      ),
                      child: const Text(
                        "sign up",
                        style: TextStyle(
                          color: Color(0xFF8B5CF6),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),

                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 2),
                    ),
                  ),
                ),

                // Forgot Password Click Action Handling via Suffix or separate link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () async {
                      if (_emailController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please enter your email first to reset password")),
                        );
                        return;
                      }
                      try {
                        await fb.FirebaseAuth.instance.sendPasswordResetEmail(
                          email: _emailController.text.trim(),
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Password reset link sent to your email!")),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: ${e.toString()}")),
                          );
                        }
                      }
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Color(0xFF8B5CF6), fontSize: 13),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                auth.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                  children: [
                    // Login Button aligned nicely with modern theme
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9D65FF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 2,
                          ),
                          onPressed: () async {
                            bool success = await auth.login(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                              context,
                            );

                            if (success && context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => HomeScreen()),
                              );
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Login",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Google Sign-In Button matching styling
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        icon: const Icon(Icons.login, color: Color(0xFF8B5CF6)),
                        label: const Text(
                          "Sign in with Google",
                          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                        ),
                        onPressed: () async {
                          await auth.signInWithGoogle(context);
                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => HomeScreen()),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}