import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login
  Future<void> loginUser(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Signup (Naya Code)
  Future<void> signUpUser(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
    );
  }
}