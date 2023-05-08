import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:true_chat_app/utils/show_messages.dart';

class ChatPage extends StatefulWidget {
  final Map<String, dynamic> friend;

  const ChatPage({
    super.key,
    required this.friend,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  FocusNode focusNode = FocusNode();
  TextEditingController messageController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final chatsStream =
        db.collection("chats").doc(widget.friend["chatId"]).snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.friend["photoURL"]),
              radius: 20,
            ),
            const SizedBox(width: 8),
            Text(
              widget.friend["displayName"],
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ShowMessages(
              stream: chatsStream,
              chatId: widget.friend["chatId"],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: messageController,
                    onTapOutside: (event) {
                      focusNode.unfocus();
                    },
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type a message',
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (messageController.text.trim().isEmpty) {
                    return;
                  }

                  db.collection("chats").doc(widget.friend["chatId"]).update({
                    "messages": FieldValue.arrayUnion([
                      {
                        "message": messageController.text,
                        "uid": user.uid,
                        "timestamp": DateTime.now(),
                      }
                    ])
                  });
                  
                  focusNode.requestFocus();

                  messageController.clear();
                },
                icon: const Icon(Icons.send),
              ),
            ],
          )
        ],
      ),
    );
  }
}
