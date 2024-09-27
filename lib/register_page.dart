import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firestore
import 'package:recipe_app/login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordObscured = true; // Control the password visibility for password field
  bool _isConfirmPasswordObscured = true; // Control the password visibility for confirm password field
  String? _errorMessage;
  bool _isLoading = false; // Track loading state

  Future<void> _register() async {
    setState(() {
      _errorMessage = null; // Clear previous error message
      _isLoading = true;    // Show loading indicator
    });

    // Validate input
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = "Please fill in all fields.";
        _isLoading = false;
      });
      return;
    }

    // Check if passwords match
    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      setState(() {
        _errorMessage = "Passwords do not match.";
        _isLoading = false;
      });
      return;
    }

    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Update user's display name in Firebase Authentication
      await userCredential.user?.updateProfile(displayName: _nameController.text.trim());

      // Save user information in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'createdAt': DateTime.now(),
      });

      // Navigate to the login page after successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff36444c),
                  ),
                ),
                const SizedBox(height: 30),
                // Name TextField with custom styles
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    labelStyle: TextStyle(color: Colors.grey[700]),
                    prefixIcon: const Icon(Icons.person),
                    prefixIconColor: const Color(0xFFF96163),
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFFF96163)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFFF96163)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Email TextField with custom styles
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.grey[700]),
                    prefixIcon: const Icon(Icons.email),
                    prefixIconColor: const Color(0xFFF96163),
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFFF96163)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFFF96163)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Password TextField with custom styles and Eye Icon
                TextField(
                  controller: _passwordController,
                  obscureText: _isPasswordObscured,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.grey[700]),
                    prefixIcon: const Icon(Icons.lock),
                    prefixIconColor: const Color(0xFFF96163),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordObscured ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordObscured = !_isPasswordObscured;
                        });
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFFF96163)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFFF96163)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Confirm Password TextField with custom styles and Eye Icon
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _isConfirmPasswordObscured,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    labelStyle: TextStyle(color: Colors.grey[700]),
                    prefixIcon: const Icon(Icons.lock),
                    prefixIconColor: const Color(0xFFF96163),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordObscured ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                        });
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFFF96163)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFFF96163)),
                    ),
                  ),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 40),
                // Show a loading spinner when registering
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF96163),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: _register,
                      child: const Text(
                        "Register Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text(
                        "Login Now",
                        style: TextStyle(color: Color(0xFFF96163), fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
