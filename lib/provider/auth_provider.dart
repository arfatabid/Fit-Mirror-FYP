import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // Sheza ki file import karegi

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners(); // UI ko bataye ga ke loading ho rahi hai

    try {
      await _authService.loginUser(email, password);
      print("Login Successful");
    } catch (e) {
      print("Error: $e");
    }

    _isLoading = false;
    notifyListeners(); // UI ko bataye ga ke loading khatam ho gayi
  }
}
