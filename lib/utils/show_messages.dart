import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:true_chat_app/utils/message_tile.dart';

class ShowMessages extends StatelessWidget {
  final Stream<DocumentSnapshot<Map<String, dynamic>>> stream;
  final String chatId;

  const ShowMessages({
    Key? key,
    required this.stream,
    required this.chatId,
  });

  void deleteMessage(messageId, message, uid, timestamp) {
    if (uid != FirebaseAuth.instance.currentUser!.uid) {
      return;
    } else {
      FirebaseFirestore.instance.collection("chats").doc(chatId).update({
        "messages": FieldValue.arrayRemove([
          {
            "message": message,
            "timestamp": timestamp,
            "uid": uid,
          }
        ])
      });
    }
  }

  void edit() {}

  void copy(message) {
    Clipboard.setData(ClipboardData(text: message));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final messages = snapshot.data!.get("messages");

        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return MessageTile(
              message: messages[index]["message"],
              uid: messages[index]["uid"],
              delete: () {
                deleteMessage(
                  index,
                  messages[index]["message"],
                  messages[index]["uid"],
                  messages[index]["timestamp"],
                );
              },
              edit: edit,
              copy: () {
                copy(messages[index]["message"]);
              } ,
            );
          },
        );
      },
    );
  }
}
