import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; // Import zaroori hai
import 'firebase_options.dart'; // Ye wahi file hai jo abhi bani hai
import 'provider/auth_provider.dart';
import 'ui/screens/login_screen.dart';

void main() async {
  // Flutter binding aur Firebase initialize karna zaroori hai
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fit Mirror',
      home: LoginScreen(),
    );
  }
}
