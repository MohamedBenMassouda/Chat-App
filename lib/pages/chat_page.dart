import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:true_chat_app/utils/my_text_field.dart';
import 'package:true_chat_app/utils/show/show_messages.dart';

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
          MyTextField(
              messageController: messageController,
              focusNode: focusNode,
              onPressed: () {
                db.collection("chats").doc(widget.friend["chatId"]).update({
                  "lastMessageTime": DateTime.now(),
                  "messages": FieldValue.arrayUnion([
                    {
                      "message": messageController.text,
                      "uid": user.uid,
                      "timestamp": DateTime.now(),
                    }
                  ])
                });
              }),
        ],
      ),
    );
  }
}
