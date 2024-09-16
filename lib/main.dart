import 'package:flutter/material.dart';
import 'login_page.dart';  // Import the LoginPage from login_page.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe App',
      theme: ThemeData(
        primaryColor: const Color(0xFFF96163), // Main color
        fontFamily: 'Poppins', // Default font
      ),
      home: const LoginPage(), // First page of the app
    );
  }
}
