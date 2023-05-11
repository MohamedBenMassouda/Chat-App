import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:true_chat_app/utils/message_tile.dart';
import 'package:true_chat_app/utils/show_messages.dart';

class GroupChatPage extends StatefulWidget {
  final Stream<DocumentSnapshot<Map<String, dynamic>>> group;

  const GroupChatPage({
    super.key,
    required this.group,
  });

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: widget.group,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!.data()!["messages"];
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return MessageTile(
                        message: messages[index]["message"],
                        uid: messages[index]["sender"],
                        edit: () {},
                        delete: () {},
                        copy: () {},
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          TextField(
            controller: messageController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Message',
            ),
          ),
          IconButton(
            onPressed: () async {
              if (messageController.text.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection("groups")
                    .doc("GAS0aWLnhSryFt4tmAI4")
                    .update({
                  "messages": FieldValue.arrayUnion([
                    {
                      "uid": FirebaseAuth.instance.currentUser!.uid,
                      "sender": FirebaseAuth.instance.currentUser!.displayName,
                      "message": messageController.text,
                      "timestamp": DateTime.now(),
                    }
                  ])
                });
                messageController.clear();
              }
            },
            icon: const Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
