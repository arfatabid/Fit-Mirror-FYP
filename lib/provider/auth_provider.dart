import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Login Function
  Future<void> login(String email, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.loginUser(email, password);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    _isLoading = false;
    notifyListeners();
  }

  // Signup Function (Naya Code)
  Future<void> signUp(String email, String password, BuildContext context) async {
    // Password Validation: 8 characters limit
    if (password.length > 8) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password must be 8 characters or less")));
      return;
    }
    
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signUpUser(email, password);
      Navigator.pop(context); // Signup successful, go back to Login
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    _isLoading = false;
    notifyListeners();
  }
}