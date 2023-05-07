import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:true_chat_app/pages/contact_page.dart';
import 'package:true_chat_app/pages/login_page.dart';
import 'package:true_chat_app/services/auth_service.dart';
import 'package:true_chat_app/utils/message_tile.dart';
import 'package:true_chat_app/utils/my_drawer.dart';
import 'package:true_chat_app/utils/show_messages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      drawer: const MyDrawer(),
      body: MessageTile(
        uid: FirebaseAuth.instance.currentUser!.uid,
        message: "Hello",
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ContactPage(),
            ),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}