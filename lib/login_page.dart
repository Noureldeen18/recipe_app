import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _loginUser() async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (userCredential.user != null) {
        // User logged in successfully, navigate to home page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful!')),
        );
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf6f4fa), // Background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF3c444c)), // Dark text color
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Login',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3c444c), // Dark text color
              ),
            ),
            SizedBox(height: 20),
            // Email Field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 15),
            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFf96163), // Primary color
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: GoogleFonts.poppins(fontSize: 18),
                ),
                child: Text('Log In'),
              ),
            ),
            SizedBox(height: 15),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/register');
                },
                child: Text(
                  'Don\'t have an account? Sign up',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Color(0xFFf96163),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
