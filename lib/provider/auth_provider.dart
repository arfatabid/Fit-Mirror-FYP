import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // --- Login Function ---
  Future<bool> login(String email, String password, BuildContext context) async {
    if (password.length > 8) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password must be 8 characters or less")));
      return false;
    }

    _isLoading = true;
    notifyListeners();
    try {
      await _authService.loginUser(email, password);
      _isLoading = false;
      notifyListeners();
      return true; // Kamyab hone par true return karega
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      return false;
    }
  }

  // --- Signup Function ---
  Future<bool> signUp(String email, String password, BuildContext context) async {
    if (password.length > 8) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password must be 8 characters or less")));
      return false;
    }

    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signUpUser(email, password);
      _isLoading = false;
      notifyListeners();
      return true; // Kamyab hone par true return karega
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      return false;
    }
  }

  // --- Google Sign-In ---
  Future<void> signInWithGoogle(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Google Login Successful!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Google Sign-In Error: ${e.toString()}")));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}