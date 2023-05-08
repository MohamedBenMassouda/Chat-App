import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:true_chat_app/pages/contact_page.dart';
import 'package:true_chat_app/pages/login_page.dart';
import 'package:true_chat_app/utils/my_drawer.dart';
import 'package:true_chat_app/utils/show_conversations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<DocumentSnapshot<Map<String, dynamic>>> friendsList = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      drawer: const MyDrawer(),
      body: ShowConversations(friendsList: friendsList),
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
