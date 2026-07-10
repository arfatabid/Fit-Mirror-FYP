import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
        child: Column(
          children: [
            const Text("Fit Mirror",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
            const SizedBox(height: 40),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder())),
            const SizedBox(height: 25),

            auth.isLoading
                ? const CircularProgressIndicator()
                : Column(
              children: [
                SizedBox(width: double.infinity, child: ElevatedButton(
                  onPressed: () => auth.login(_emailController.text, _passwordController.text, context),
                  child: const Text("Login"),
                )),
                const SizedBox(height: 15),

                // Google Login Button
                SizedBox(width: double.infinity, child: OutlinedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text("Sign in with Google"),
                  onPressed: () => auth.signInWithGoogle(context),
                )),

                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SignupScreen())),
                  child: const Text("Don't have an account? Sign Up"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}