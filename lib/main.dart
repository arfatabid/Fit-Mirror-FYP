import 'package:flutter/material.dart';

void main() {
  runApp(FitMirrorApp());
}

class FitMirrorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fit Mirror',
      home: WelcomeScreen(),
    );
  }
}

// 1. WELCOME SCREEN (Pink-Purple Gradient ke sath)
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple[100]!, // Soft Purple
              Colors.pink[100]!,   // Soft Pink
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'FIT MIRROR',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[900],
                  letterSpacing: 3,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Your AI Fashion Assistant',
                style: TextStyle(fontSize: 16, color: Colors.purple[700]),
              ),
              SizedBox(height: 60),

              // LOGIN BUTTON
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('Login', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              SizedBox(height: 20),

              // SIGN UP BUTTON
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text('Sign Up', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. KHALI LOGIN SCREEN
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(child: Text('Login Form Coming Soon!')),
    );
  }
}

// 3. KHALI SIGN UP SCREEN
class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Center(child: Text('Sign Up Form Coming Soon!')),
    );
  }
}