import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:true_chat_app/services/auth_service.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      return const HomePage();
    }

    return Scaffold(
      appBar: AppBar(
        title:
            user == null ? const Text('Login Page') : Text(user.displayName!),
        actions: [
          IconButton(
            onPressed: () {
              AuthManager().signOut();

              setState(() {
                user = auth.currentUser;
              });
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            AuthManager().signInWithGoogle().then((value) {
              setState(() {
                user = value;
              });

              if (user != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              }
            });
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
