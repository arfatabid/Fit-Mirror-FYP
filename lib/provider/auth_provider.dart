import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final DatabaseService _dbService = DatabaseService();
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
      
      final user = _auth.currentUser;
      if (user != null) {
        final isBlocked = await _dbService.isUserBlocked(user.uid);
        if (isBlocked) {
          await _auth.signOut();
          _isLoading = false;
          notifyListeners();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Your account has been suspended by the Admin.")),
            );
          }
          return false;
        }
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      if (!context.mounted) return false;

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

  // Signup 8 characters
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

      if (!context.mounted) return false;

      // Firebase errors
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

      final UserCredential cred = await _auth.signInWithCredential(credential);

      // Save user to Firestore
      if (cred.user != null) {
        final isBlocked = await _dbService.isUserBlocked(cred.user!.uid);
        if (isBlocked) {
          await _auth.signOut();
          _isLoading = false;
          notifyListeners();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Your account has been suspended by the Admin.")),
            );
          }
          return;
        }

        final userDoc = await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).get();
        if (!userDoc.exists) {
          await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
            'uid': cred.user!.uid,
            'email': cred.user!.email,
            'displayName': cred.user!.displayName,
            'role': 'user',
            'isBlocked': false,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Google Login Successful!")));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Google Sign-In Error: ${e.toString()}")));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
