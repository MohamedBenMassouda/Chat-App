import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:true_chat_app/functions/display_timestamp.dart';
import 'package:true_chat_app/pages/chat_page.dart';

class ConversationTile extends StatelessWidget {
  final String name;
  final friend;
  final String photoURL;
  final DocumentReference<Map<String, dynamic>> chatDoc;

  const ConversationTile({
    super.key,
    required this.name,
    required this.friend,
    required this.photoURL,
    required this.chatDoc,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(photoURL),
      ),
      
      title: Text(name),

      subtitle: StreamBuilder(
        stream: chatDoc.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading');
          }

          final messages = snapshot.data!.get("messages") as List<dynamic>;

          if (messages.isEmpty) {
            return const Text("No messages yet");
          }

          final lastMessage = messages.last["message"];

          final read = messages.last["read"];

          final lastMessageSender = messages.last["uid"] == friend["uid"]
              ? friend["displayName"]
              : "You";

          return Row(
            children: [
              Text(
                "$lastMessageSender: $lastMessage",
                style: TextStyle(
                  fontWeight: !read ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const Spacer(),
              Text(
                displayTimeStamp(messages.last["timestamp"].toDate()),
                style: TextStyle(
                  fontWeight: !read ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          );
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              friend: friend,
            ),
          ),
        );
      },
    );
  }
}
