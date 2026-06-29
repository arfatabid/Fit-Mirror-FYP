import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Create Account", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(
              controller: _passwordController,
              obscureText: true,
              maxLength: 8, // Password limit
              decoration: InputDecoration(labelText: 'Password (Max 8 characters)', counterText: ""),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false)
                    .signUp(_emailController.text, _passwordController.text, context);
              },
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}