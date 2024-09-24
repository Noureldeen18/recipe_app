import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_app/login_page.dart';
import 'package:recipe_app/recipe_menu_page.dart'; // Change this to your main page if necessary
import 'dio_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DioHelper.init();
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
        primaryColor: const Color(0xFFf96163),
        fontFamily: 'Poppins',
      ),
      home: AuthWrapper(), // Use AuthWrapper to check auth state
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check if user is logged in
    User? user = FirebaseAuth.instance.currentUser;

    // If the user is logged in, show the RecipeMenuPage; otherwise, show the LoginPage
    if (user != null) {
      return Test(); // Navigate to your main page
    } else {
      return LoginPage(); // Navigate to the login page
    }
  }
}
