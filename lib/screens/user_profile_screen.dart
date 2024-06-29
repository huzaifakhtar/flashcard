// File: /lib/screens/user_profile_screen.dart

import 'package:flashcard/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';


class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return LoginScreen(); // Replace with your login/register page
          } else {
            return UserProfileScreen(user: user); // Pass the user to the profile page
          }
        } else {
          return const CircularProgressIndicator(); // Show a loading spinner while waiting for the connection
        }
      },
    );
  }
}

class UserProfileScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  final User? user; // Add a user parameter


  UserProfileScreen({super.key, this.user}); // Update the constructor to take the user parameter

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://via.placeholder.com/150'),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? 'User Name',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user?.email ?? 'user@example.com',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            if (user != null)  
             OutlinedButton(
                onPressed: () {
                // Navigate to edit profile screen
              },
                child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () async {
                if (user == null) {
                  // Navigate to login screen
                  Navigator.of(context).pushReplacementNamed('/login');
                } else {
                  // Log out the user
                  await _auth.signOut();
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              },
              style: OutlinedButton.styleFrom(
                  backgroundColor: user == null ? Colors.blue : Colors.red),
              child: Text(
                user == null ? 'Login' : 'Logout',
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}