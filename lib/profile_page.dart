import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Profile Photo
              CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage('assets/placeholder_image.png'), // Placeholder for profile image
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(height: 20),
              // Full Name
              const Text(
                'Full Name',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 10),
              // Email
              const Text(
                'email@example.com',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 30),
              // Edit Profile Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to Edit Profile Page
                  // Placeholder for now
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFf96163), // Use your primary color
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 80),
                  textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
