import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final ImagePicker _picker = ImagePicker();
  String? _newPhotoUrl;

  Future<void> _changePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);

      try {
        String fileName = 'profile_photos/${user!.uid}.jpg';
        Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
        await storageRef.putFile(file);

        String photoUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
          'photoUrl': photoUrl,
        });

        setState(() {
          _newPhotoUrl = photoUrl;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading photo: $e')),
        );
      }
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _editProfile() {
    Navigator.of(context).pushNamed('/edit-profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(user!.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('No User Data Available'));
            }

            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _newPhotoUrl != null
                            ? NetworkImage(_newPhotoUrl!)
                            : (userData['photoUrl'] != null && userData['photoUrl'].isNotEmpty)
                            ? NetworkImage(userData['photoUrl'])
                            : const AssetImage('assets/default_profile.png') as ImageProvider,
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: _changePhoto,
                        child: const Text(
                          'Change Photo',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        userData['name'] ?? 'No Name',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userData['email'] ?? 'No Email',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: _editProfile,
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFf96163),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _logout,
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text('Logout', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[700],
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
