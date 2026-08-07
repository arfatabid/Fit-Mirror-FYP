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

  // Login Function
  Future<bool> login(String email, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.loginUser(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      // Firebase errors
      String errorMessage = "An error occurred. Please try again.";
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
          errorMessage = "Incorrect email or password.";
        } else if (e.code == 'wrong-password') {
          errorMessage = "Incorrect password.";
        } else if (e.code == 'invalid-email') {
          errorMessage = "The email address is badly formatted.";
        } else {
          errorMessage = e.message ?? errorMessage;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      return false;
    }
  }

  // Signup Function (Document ke mutabiq 8 characters check)
  Future<bool> signUp(String email, String password, BuildContext context) async {
    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 8 characters long")),
      );
      return false;
    }

    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signUpUser(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      // Firebase  main errors
      String errorMessage = "An error occurred. Please try again.";
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          errorMessage = "This email is already registered. Please login instead.";
        } else if (e.code == 'weak-password') {
          errorMessage = "The password provided is too weak.";
        } else if (e.code == 'invalid-email') {
          errorMessage = "The email address is invalid.";
        } else {
          errorMessage = e.message ?? errorMessage;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      return false;
    }
  }

  // Google Sign-In Function
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
