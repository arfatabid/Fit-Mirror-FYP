import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Updated Login Function
  Future<void> login(String email, String password, BuildContext context) async {
    // Yahan limit add karein:
    if (password.length > 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be 8 characters or less")),
      );
      return; // Agar 8 se zyada hai to aage nahi badhega
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _authService.loginUser(email, password);
      // Login successful hone par yahan navigation add kar sakti hain
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    _isLoading = false;
    notifyListeners();
  }

  // Signup Function with 8 Character Validation
  Future<void> signUp(String email, String password, BuildContext context) async {
    // Password Validation: Max 8 characters check
    if (password.length > 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be 8 characters or less")),
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signUpUser(email, password);
      // Success hone par screen pop kar dein (ya login page par bhej dein)
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    _isLoading = false;
    notifyListeners();
  }
}