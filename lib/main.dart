import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'login_page.dart';
// import 'register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensure Flutter is initialized before Firebase
  await Firebase.initializeApp();             // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyApp() ;
}

class _MyApp extends State<MyApp>{
  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  );
  }
}


