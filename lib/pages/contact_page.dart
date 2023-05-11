import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:true_chat_app/pages/add_group_page.dart';
import 'package:true_chat_app/utils/friend_tile.dart';
import 'package:true_chat_app/utils/generateUID.dart';
import 'package:true_chat_app/utils/my_snack_bar.dart';
import 'package:true_chat_app/utils/show_friends.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final user = FirebaseAuth.instance.currentUser!;
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  final scaffoldMessengerState = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerState,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Contacts'),
        ),
        body: Column(
          children: [
            const AddGroup(),
            ShowFriends(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return SizedBox(
                  child: Column(
                    children: [
                      const Text(
                        'Add a friend',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email (optional)',
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (usernameController.text.trim().isEmpty) {
                            MySnackBar(
                                context, "Please fill in all the fields");
                            return;
                          }

                          // Search for the user with the given email and username
                          final querySnapshot = emailController.text != ""
                              ? FirebaseFirestore.instance
                                  .collection('users')
                                  .where('email',
                                      isEqualTo: emailController.text)
                                  .where('displayName',
                                      isEqualTo: usernameController.text)
                                  .get()
                              : FirebaseFirestore.instance
                                  .collection('users')
                                  .where('displayName',
                                      isEqualTo: usernameController.text)
                                  .get();

                          querySnapshot.then((value) async {
                            if (value.docs.isNotEmpty) {
                              final userDoc = value.docs.first;
                              final friendUid = userDoc.id;

                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .get()
                                  .then((value) async {
                                final friends =
                                    value.get('friends') as List<dynamic>;
                                for (final friend in friends) {
                                  if (friend['uid'] == friendUid) {
                                    MySnackBar(context,
                                        "You are already friends with this user");
                                    return;
                                  }
                                }

                                String uid = generateUID();

                                FirebaseFirestore.instance
                                    .collection("chats")
                                    .doc(uid)
                                    .set({
                                  "members": [user.uid, friendUid],
                                  "messages": [],
                                });

                                // Add the friend to the current user's friends list
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .update({
                                  'friends': FieldValue.arrayUnion([
                                    {
                                      "uid": friendUid,
                                      "displayName": userDoc.get('displayName'),
                                      "email": userDoc.get('email'),
                                      "photoURL": userDoc.get('photoURL'),
                                      "chatId": uid,
                                    }
                                  ])
                                });

                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(friendUid)
                                    .update({
                                  'friends': FieldValue.arrayUnion([
                                    {
                                      "uid": user.uid,
                                      "displayName": user.displayName,
                                      "email": user.email,
                                      "photoURL": user.photoURL,
                                      "chatId": uid,
                                    }
                                  ])
                                });

                                MySnackBar(context, "Friend added");
                                emailController.clear();
                                usernameController.clear();
                              });
                            } else {
                              MySnackBar(context, "User not found");
                            }
                          });

                          Navigator.pop(context);
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: const Icon(Icons.person_add_alt_1),
        ),
      ),
    );
  }
}

class AddGroup extends StatelessWidget {
  const AddGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  AddGroupPage()
          )
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(30, 10, 0, 10),
        child: Row(
          children: const [
            Icon(Icons.group_add),
            SizedBox(width: 10),
            Text(
              'Add a group',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
