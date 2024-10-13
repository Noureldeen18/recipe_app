import 'package:flutter/material.dart';
import 'package:recipe_app/register_page.dart';

import 'login_page.dart';

class LogOrReg extends StatelessWidget {
  const LogOrReg({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Image.asset(
                'assets/images/logo.png',
                height: 146,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=> const Login()));},
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xfffee3625),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: const StadiumBorder(),
                ),
                child: const Text("Login"),
              ),
              const SizedBox(height: 20.0),
              const Text('OR'),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=> const Register()));},
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: const StadiumBorder(),
                    backgroundColor: const Color(0xFF3C444C)),
                child: const Text("Register"),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
